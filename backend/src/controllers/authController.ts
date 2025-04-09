// src/controllers/authController.ts
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user";

const JWT_SECRET = process.env.JWT_SECRET || "mi_clave_secreta_super_segura";

export const register = async (req: Request, res: Response) => {
  const { name, address, birthDate, email, password, isStore } = req.body;

  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser)
      return res.status(409).json({ message: "El usuario ya existe." });

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({
      name,
      address,
      birthDate,
      email,
      password: hashedPassword,
      isStore: isStore || false,
    });

    res.status(201).json({
      message: "Usuario creado correctamente",
      user: newUser,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error del servidor" });
  }
};

export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user)
      return res.status(404).json({ message: "Usuario no encontrado" });

    const isMatch = await bcrypt.compare(
      password,
      user.get("password") as string
    );
    if (!isMatch)
      return res.status(401).json({ message: "Contraseña incorrecta" });

    const token = jwt.sign({ userId: user.get("id") }, JWT_SECRET, {
      expiresIn: "1h",
    });

    res.json({
      message: "Login exitoso",
      token,
      userId: user.get("id"),
      user,
    });
  } catch (err) {
    res.status(500).json({ error: "Error del servidor" });
  }
};
