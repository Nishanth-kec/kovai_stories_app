import express from "express";
import multer from "multer";
import path from "path";
import { fileURLToPath } from "url";
import Company from "../models/Company.js";
import { auth } from "../middlewares/auth.js";

const router = express.Router();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Setup multer for file uploads
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    const assetsDir = path.join(__dirname, "../assets");
    cb(null, assetsDir);
  },
  filename: (_req, file, cb) => {
    cb(null, "company-logo" + path.extname(file.originalname));
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (_req, file, cb) => {
    const allowedMimes = ["image/jpeg", "image/png", "image/gif", "image/webp"];
    if (allowedMimes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error("Invalid file type. Only image files are allowed."));
    }
  },
});

// GET /api/company/me - Get company information
router.get("/me", auth, async (req, res, next) => {
  try {
    const company = await Company.findById(req.user.companyId);

    if (!company) {
      return res.status(404).json({ message: "Company not found" });
    }

    res.json(company);
  } catch (err) {
    next(err);
  }
});

// PUT /api/company/me - Update company information
router.put("/me", auth, async (req, res, next) => {
  try {
    const { name, email, phone, address, taxNumber } = req.body;

    const company = await Company.findByIdAndUpdate(
      req.user.companyId,
      {
        ...(name && { name }),
        ...(email && { email }),
        ...(phone && { phone }),
        ...(address && { address }),
        ...(taxNumber && { taxNumber }),
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!company) {
      return res.status(404).json({ message: "Company not found" });
    }

    res.json({
      message: "Company updated successfully",
      company,
    });
  } catch (err) {
    next(err);
  }
});

// POST /api/company/logo - Upload company logo
router.post("/logo", auth, upload.single("logo"), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const logoUrl = `/assets/${req.file.filename}`;

    const company = await Company.findByIdAndUpdate(
      req.user.companyId,
      {
        logoUrl,
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!company) {
      return res.status(404).json({ message: "Company not found" });
    }

    res.json({
      message: "Logo uploaded successfully",
      company,
      logoUrl,
    });
  } catch (err) {
    next(err);
  }
});

// DELETE /api/company/logo - Delete company logo
router.delete("/logo", auth, async (req, res, next) => {
  try {
    const company = await Company.findByIdAndUpdate(
      req.user.companyId,
      {
        logoUrl: null,
        updatedAt: new Date(),
      },
      { new: true }
    );

    if (!company) {
      return res.status(404).json({ message: "Company not found" });
    }

    res.json({
      message: "Logo deleted successfully",
      company,
    });
  } catch (err) {
    next(err);
  }
});

export default router;
