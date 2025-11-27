import mongoose from "mongoose";

const ClientSchema = new mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: "Company", required: true },
  name: String,
  email: String,
  phone: String,
  address: String,
  notes: String,
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("Client", ClientSchema);
