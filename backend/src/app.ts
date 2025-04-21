import dotenv from "dotenv";
dotenv.config();

import express, { Express } from "express";
import cors from "cors";
import sequelize from "./config/database";
import authRoutes from "./routes/authRoutes";
import couponRoutes from "./routes/couponRoutes";

import "./models/user";
import "./models/coupon";

const app: Express = express();
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

// Routes
app.use("/api", authRoutes);
app.use("/api/coupons", couponRoutes);

// Sync database and start server
const PORT = parseInt(process.env.PORT || '3000', 10);

sequelize
  .sync({ force: false })
  .then(() => {
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Error connecting to database:", err);
  });
