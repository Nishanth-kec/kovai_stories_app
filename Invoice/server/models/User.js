import mongoose from "mongoose";

const UserSchema = new mongoose.Schema({
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: "Company", required: true },
  name: String,
  email: { type: String, required: true, unique: true },
  passwordHash: String,
  role: { type: String, enum: ["owner", "admin", "user"], default: "owner" },
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("User", UserSchema);
