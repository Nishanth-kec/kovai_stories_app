import mongoose from "mongoose";

const InvoiceItemSchema = new mongoose.Schema({
  description: String,
  itemId: { type: mongoose.Schema.Types.ObjectId, ref: "Item" },
  qty: Number,
  unitPrice: Number,
  total: Number
});

const InvoiceSchema = new mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: "Company", required: true },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: "Client", required: true },

  number: String,
  issueDate: Date,
  dueDate: Date,
  status: { type: String, enum: ["draft", "sent", "paid", "overdue"], default: "draft" },

  items: [InvoiceItemSchema],

  subTotal: Number,
  tax: Number,
  discount: Number,
  total: Number,

  notes: String,
  attachments: [String],

  payments: [{
    amount: Number,
    method: String,
    date: Date,
    transactionId: String
  }],

  createdAt: { type: Date, default: Date.now },
  updatedAt: Date
});

export default mongoose.model("Invoice", InvoiceSchema);
