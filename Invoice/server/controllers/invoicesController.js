import express from "express";
import { body, validationResult } from "express-validator";
import Invoice from "../models/Invoice.js";
import Client from "../models/Client.js";
import Item from "../models/Item.js";

import path from "path";
import { fileURLToPath } from "url";
import { generateInvoicePDF } from "../utils/pdfGenerator.js";
import Company from "../models/Company.js";

import { auth } from "../middlewares/auth.js";
import { generateInvoiceNumber } from "../utils/invoiceNumber.js";
import { sendAutomationEvent } from "../utils/automation.js";

const router = express.Router();


// --------------------------------------------------
// CREATE INVOICE
// POST /api/invoices
// --------------------------------------------------
router.post(
  "/",
  auth,
  [
    body("clientId").notEmpty().withMessage("Client ID is required"),
    body("items")
      .isArray({ min: 1 })
      .withMessage("At least one invoice item is required")
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty())
        return res.status(400).json({ errors: errors.array() });

      const { clientId, items, tax = 0, discount = 0, notes, issueDate, dueDate } =
        req.body;

      // ensure client belongs to this company
      const client = await Client.findOne({
        _id: clientId,
        companyId: req.user.companyId
      });

      if (!client)
        return res.status(404).json({ message: "Client does not exist" });

      // calculate totals
      let subTotal = 0;

      const formattedItems = items.map((i) => {
        const total = i.qty * i.unitPrice;
        subTotal += total;

        return {
          description: i.description,
          itemId: i.itemId,
          qty: i.qty,
          unitPrice: i.unitPrice,
          total
        };
      });

      const total = subTotal + tax - discount;

      const invoice = new Invoice({
        companyId: req.user.companyId,
        userId: req.user.id,
        clientId,
        number: generateInvoiceNumber(req.user.companyId),

        items: formattedItems,

        subTotal,
        tax,
        discount,
        total,

        notes,
        issueDate: issueDate || new Date(),
        dueDate: dueDate || null,
        status: "draft",

        createdAt: new Date()
      });

      await invoice.save();

      // Send event to n8n
      await sendAutomationEvent("invoice.created", invoice);

      res.json({
        message: "Invoice created successfully",
        invoice
      });
    } catch (err) {
      next(err);
    }
  }
);


// --------------------------------------------------
// LIST INVOICES (with filters)
// GET /api/invoices
// --------------------------------------------------
router.get("/", auth, async (req, res, next) => {
  try {
    const { status, clientId, search } = req.query;

    const filter = {
      companyId: req.user.companyId
    };

    if (status) filter.status = status;
    if (clientId) filter.clientId = clientId;

    if (search) {
      filter.number = { $regex: search, $options: "i" };
    }

    const invoices = await Invoice.find(filter)
      .populate("clientId")
      .sort({ createdAt: -1 });

    res.json(invoices);
  } catch (err) {
    next(err);
  }
});


// --------------------------------------------------
// GET SINGLE INVOICE
// GET /api/invoices/:id
// --------------------------------------------------
router.get("/:id", auth, async (req, res, next) => {
  try {
    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    }).populate("clientId");

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    res.json(invoice);
  } catch (err) {
    next(err);
  }
});


// --------------------------------------------------
// UPDATE INVOICE (Full update except payments)
// PUT /api/invoices/:id
// --------------------------------------------------
router.put("/:id", auth, async (req, res, next) => {
  try {
    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    Object.assign(invoice, req.body);
    invoice.updatedAt = new Date();

    await invoice.save();

    await sendAutomationEvent("invoice.updated", invoice);

    res.json({ message: "Invoice updated", invoice });
  } catch (err) {
    next(err);
  }
});


// --------------------------------------------------
// UPDATE STATUS (draft → sent, paid, overdue)
// PATCH /api/invoices/:id/status
// --------------------------------------------------
router.patch("/:id/status", auth, async (req, res, next) => {
  try {
    const { status } = req.body;

    const allowed = ["draft", "sent", "paid", "overdue"];
    if (!allowed.includes(status))
      return res.status(400).json({ message: "Invalid status" });

    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    invoice.status = status;
    invoice.updatedAt = new Date();

    await invoice.save();

    await sendAutomationEvent("invoice.status_changed", invoice);

    res.json({ message: "Status updated", invoice });
  } catch (err) {
    next(err);
  }
});


// --------------------------------------------------
// ADD PAYMENT TO INVOICE
// PATCH /api/invoices/:id/payments
// --------------------------------------------------
router.patch("/:id/payments", auth, async (req, res, next) => {
  try {
    const { amount, method, transactionId } = req.body;

    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    invoice.payments.push({
      amount,
      method,
      transactionId,
      date: new Date()
    });

    // auto mark as paid if total is reached
    const totalPayments = invoice.payments.reduce(
      (sum, p) => sum + p.amount,
      0
    );

    if (totalPayments >= invoice.total) {
      invoice.status = "paid";
    }

    invoice.updatedAt = new Date();
    await invoice.save();

    await sendAutomationEvent("invoice.payment_added", invoice);

    res.json({
      message: "Payment added",
      invoice
    });
  } catch (err) {
    next(err);
  }
});


// --------------------------------------------------
// DELETE INVOICE
// DELETE /api/invoices/:id
// --------------------------------------------------
router.delete("/:id", auth, async (req, res, next) => {
  try {
    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    await invoice.deleteOne();

    res.json({ message: "Invoice deleted" });
  } catch (err) {
    next(err);
  }
});





const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// DOWNLOAD PDF
router.get("/:id/pdf", auth, async (req, res, next) => {
  try {
    const invoice = await Invoice.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });

    if (!invoice)
      return res.status(404).json({ message: "Invoice not found" });

    const client = await Client.findById(invoice.clientId);
    const company = await Company.findById(req.user.companyId);

    const filePath = path.join(
      __dirname,
      `../tmp/invoice_${invoice._id}.pdf`
    );

    await generateInvoicePDF(invoice, client, company, filePath);

    res.download(filePath);
  } catch (err) {
    next(err);
  }
});


export default router;
