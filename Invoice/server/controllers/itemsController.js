import express from "express";
import { body, validationResult } from "express-validator";

import Item from "../models/Item.js";
import { auth } from "../middlewares/auth.js";

const router = express.Router();


// ---------------------------------------------
// CREATE ITEM
// POST /api/items
// ---------------------------------------------
router.post(
  "/",
  auth,
  [
    body("name").notEmpty().withMessage("Item name is required"),
    body("unitPrice")
      .optional()
      .isFloat({ min: 0 })
      .withMessage("Unit price must be a positive number")
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty())
        return res.status(400).json({ errors: errors.array() });

      const { name, description, unitPrice, sku } = req.body;

      const item = new Item({
        companyId: req.user.companyId,
        name,
        description,
        unitPrice,
        sku
      });

      await item.save();

      res.json({
        message: "Item created successfully",
        item
      });
    } catch (err) {
      next(err);
    }
  }
);


// ---------------------------------------------
// LIST ITEMS
// GET /api/items
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

    const items = await Item.find(filter).sort({ createdAt: -1 });

    res.json(items);
  } catch (err) {
    next(err);
  }
});


// ---------------------------------------------
// GET ONE ITEM
// GET /api/items/:id
// ---------------------------------------------
router.get("/:id", auth, async (req, res, next) => {
  try {
    const item = await Item.findOne({
    _id: req.params.id,
    companyId: req.user.companyId
  });

    if (!item)
      return res.status(404).json({ message: "Item not found" });

    res.json(item);
  } catch (err) {
    next(err);
  }
});


// ---------------------------------------------
// UPDATE ITEM
// PUT /api/items/:id
// ---------------------------------------------
router.put(
  "/:id",
  auth,
  [
    body("name").optional().notEmpty().withMessage("Name cannot be empty"),
    body("unitPrice")
      .optional()
      .isFloat({ min: 0 })
      .withMessage("Unit price must be a positive number")
  ],
  async (req, res, next) => {
    try {
      const item = await Item.findOne({
        _id: req.params.id,
        companyId: req.user.companyId
      });

      if (!item)
        return res.status(404).json({ message: "Item not found" });

      Object.assign(item, req.body);
      await item.save();

      res.json({
        message: "Item updated successfully",
        item
      });
    } catch (err) {
      next(err);
    }
  }
);


// ---------------------------------------------
// DELETE ITEM
// DELETE /api/items/:id
// ---------------------------------------------
router.delete("/:id", auth, async (req, res, next) => {
  try {
    const item = await Item.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!item)
      return res.status(404).json({ message: "Item not found" });

    await item.deleteOne();

    res.json({ message: "Item deleted successfully" });
  } catch (err) {
    next(err);
  }
});


export default router;
