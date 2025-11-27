import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import morgan from "morgan";
import { connectDB } from "./config/db.js";

import authRoutes from "./controllers/authController.js";
import clientRoutes from "./controllers/clientsController.js";
import itemRoutes from "./controllers/itemsController.js";
import invoiceRoutes from "./controllers/invoicesController.js";
import companyRoutes from "./controllers/companyController.js";

import { errorHandler } from "./middlewares/errorHandler.js";

dotenv.config();

// Validate required environment variables
const requiredEnvVars = ["MONGO_URI", "JWT_SECRET"];
const missingEnvVars = requiredEnvVars.filter(
  (envVar) => !process.env[envVar]
);

if (missingEnvVars.length > 0) {
  console.error(
    "🔴 Missing required environment variables:",
    missingEnvVars.join(", ")
  );
  console.error("Please check your .env file");
  process.exit(1);
}

const app = express();

// middleware
app.use(cors());
app.use(express.json({ limit: "10mb" }));
app.use(morgan("dev"));

// connect database
connectDB();

// health check endpoint
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "🚀 Invoice API is running",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development"
  });
});

// routes
app.use("/api/auth", authRoutes);
app.use("/api/clients", clientRoutes);
app.use("/api/items", itemRoutes);
app.use("/api/invoices", invoiceRoutes);
app.use("/api/company", companyRoutes);

// error handler
app.use(errorHandler);

const PORT = process.env.PORT || 4000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
