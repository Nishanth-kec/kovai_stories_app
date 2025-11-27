import mongoose from "mongoose";

const ItemSchema = new mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: "Company", required: true },
  name: String,
  description: String,
  unitPrice: Number,
  sku: String,
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("Item", ItemSchema);
