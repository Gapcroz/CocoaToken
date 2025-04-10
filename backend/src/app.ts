import dotenv from "dotenv";
dotenv.config();

import express, { Express } from "express";
import cors from "cors";
import sequelize from "./config/database";
import authRoutes from "./routes/authRoutes";

import "./models/user";

const app: Express = express();
app.use(cors());
app.use(express.json());
app.use("/api", authRoutes);
// Sync database and start server
const PORT = process.env.PORT || 3000;

sequelize
  .sync({ force: false })
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Error connecting to database:", err);
  });
