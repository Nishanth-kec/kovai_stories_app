import express from "express";
import { body, validationResult } from "express-validator";

import Client from "../models/Client.js";
import { auth } from "../middlewares/auth.js";

const router = express.Router();


// ---------------------------------------------
// CREATE CLIENT
// POST /api/clients
// ---------------------------------------------
router.post(
  "/",
  auth,
  [
    body("name").notEmpty().withMessage("Client name is required"),
    body("email").optional().isEmail().withMessage("Invalid email format")
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty())
        return res.status(400).json({ errors: errors.array() });

      const { name, email, phone, address, notes } = req.body;

      const client = new Client({
        companyId: req.user.companyId,
        name,
        email,
        phone,
        address,
        notes
      });

      await client.save();

      res.json({
        message: "Client created successfully",
        client
      });
    } catch (err) {
      next(err);
    }
  }
);


// ---------------------------------------------
// LIST CLIENTS
// GET /api/clients
// ---------------------------------------------
router.get("/", auth, async (req, res, next) => {
  try {
    const { search } = req.query;

    const filter = {
      companyId: req.user.companyId
    };

    if (search) {
      filter.name = { $regex: search, $options: "i" };
    }

    const clients = await Client.find(filter).sort({ createdAt: -1 });

    res.json(clients);
  } catch (err) {
    next(err);
  }
});


// ---------------------------------------------
// GET SINGLE CLIENT
// GET /api/clients/:id
// ---------------------------------------------
router.get("/:id", auth, async (req, res, next) => {
  try {
    const client = await Client.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!client)
      return res.status(404).json({ message: "Client not found" });

    res.json(client);
  } catch (err) {
    next(err);
  }
});


// ---------------------------------------------
// UPDATE CLIENT
// PUT /api/clients/:id
// ---------------------------------------------
router.put(
  "/:id",
  auth,
  [
    body("name").optional().notEmpty().withMessage("Name cannot be empty"),
    body("email").optional().isEmail().withMessage("Invalid email format")
  ],
  async (req, res, next) => {
    try {
      const client = await Client.findOne({
        _id: req.params.id,
        companyId: req.user.companyId
      });

      if (!client)
        return res.status(404).json({ message: "Client not found" });

      const updates = req.body;

      Object.assign(client, updates);
      await client.save();

      res.json({
        message: "Client updated successfully",
        client
      });
    } catch (err) {
      next(err);
    }
  }
);


// ---------------------------------------------
// DELETE CLIENT
// DELETE /api/clients/:id
// ---------------------------------------------
router.delete("/:id", auth, async (req, res, next) => {
  try {
    const client = await Client.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!client)
      return res.status(404).json({ message: "Client not found" });

    await client.deleteOne();

    res.json({ message: "Client deleted successfully" });
  } catch (err) {
    next(err);
  }
});


export default router;
