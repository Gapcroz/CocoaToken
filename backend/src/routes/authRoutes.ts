// src/routes/authRoutes.ts
import express from "express";
import { login, register } from "../controllers/authController";
import { googleLogin } from "../controllers/authController";


const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/google-login", googleLogin);

export default router;
