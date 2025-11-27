import express from "express";
import bcrypt from "bcryptjs";
import { body, validationResult } from "express-validator";

import User from "../models/User.js";
import Company from "../models/Company.js";
import { generateToken } from "../utils/jwt.js";

const router = express.Router();


// ---------------------------------------------
// REGISTER (Create Company + User)
// POST /api/auth/register
// ---------------------------------------------
router.post(
  "/register",
  [
    body("companyName").notEmpty().withMessage("Company name is required"),
    body("name").notEmpty().withMessage("Name is required"),
    body("email").isEmail().withMessage("Valid email required"),
    body("password").isLength({ min: 6 }).withMessage("Password ≥ 6 chars")
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty())
        return res.status(400).json({ errors: errors.array() });

      const { companyName, name, email, password } = req.body;

      // check email conflict
      const existing = await User.findOne({ email });
      if (existing)
        return res.status(400).json({ message: "Email already registered" });

      // create company
      const company = new Company({
        name: companyName
      });
      await company.save();

      // hash password
      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(password, salt);

      // create user (owner)
      const user = new User({
        companyId: company._id,
        name,
        email,
        passwordHash,
        role: "owner"
      });

      await user.save();

      // generate token
      const token = generateToken(user);

      res.json({
        message: "Registration successful",
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          companyId: user.companyId,
          role: user.role
        },
        company
      });
    } catch (err) {
      next(err);
    }
  }
);


// ---------------------------------------------
// LOGIN
// POST /api/auth/login
// ---------------------------------------------
router.post(
  "/login",
  [
    body("email").isEmail(),
    body("password").isLength({ min: 6 })
  ],
  async (req, res, next) => {
    try {
      const { email, password } = req.body;

      const user = await User.findOne({ email });
      if (!user)
        return res.status(400).json({ message: "Invalid credentials" });

      const valid = await bcrypt.compare(password, user.passwordHash);
      if (!valid)
        return res.status(400).json({ message: "Invalid credentials" });

      const token = generateToken(user);

      res.json({
        message: "Login successful",
        token,
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          companyId: user.companyId,
          role: user.role
        }
      });
    } catch (err) {
      next(err);
    }
  }
);


export default router;
