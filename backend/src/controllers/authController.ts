// src/controllers/authController.ts
import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user";
import moment from "moment";
import admin from "../utils/firebase"; 

const JWT_SECRET = process.env.JWT_SECRET || "mi_clave_secreta_super_segura";

export const register = async (req: Request, res: Response) => {
  const { name, address, birthDate, email, password, isStore } = req.body;

  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser)
      return res.status(409).json({ message: "El usuario ya existe." });

    const hashedPassword = await bcrypt.hash(password, 10);

    let parsedDate: Date | null = null;
    if (!isStore) {
      const formattedDate = moment(
        birthDate,
        ["DD/MM/YYYY", "YYYY-MM-DD"],
        true
      );
      if (!formattedDate.isValid()) {
        return res
          .status(400)
          .json({ message: "Fecha de nacimiento inválida" });
      }
      parsedDate = formattedDate.toDate();
    }

    const newUser = await User.create({
      name,
      address,
      birthDate: parsedDate,
      email,
      password: hashedPassword,
      isStore: isStore || false,
    });

    res.status(201).json({
      message: "Usuario creado correctamente",
      id: newUser.get("id"),
      name: newUser.get("name"),
      email: newUser.get("email"),
      address: newUser.get("address"),
      birthDate: newUser.get("birthDate"),
      isStore: newUser.get("isStore"),
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

export const googleLogin = async (req: Request, res: Response) => {
  const { idToken } = req.body;
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { uid, email, name, picture } = decodedToken;

    // Busca si ya existe el usuario
    let user = await User.findOne({ where: { email } });

    if (!user) {
      user = await User.create({
        name,
        email,
        address: "", // Por defecto vacío
        password: "", // No aplica en Google
        birthDate: null,
        isStore: false,
      });
    }

    const token = jwt.sign({ userId: user.get("id") }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.json({
      message: "Login con Google exitoso",
      token,
      userId: user.get("id"),
      user,
    });
  } catch (error) {
    console.error("Error en login con Google:", error);
    res.status(401).json({ message: "Token de Google inválido o expirado" });
  }
};

export const completeGoogleUser = async (req: Request, res: Response) => {
  const { userId, password, isStore, birthDate } = req.body;

  if (!userId || !password || typeof isStore === "undefined") {
    return res.status(400).json({ message: "Faltan campos obligatorios" });
  }

  try {
    const user = await User.findByPk(userId);

    if (!user) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    // Verifica si ya fue completado antes
    if (user.get("password")) {
      return res.status(400).json({ message: "El perfil ya fue completado" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const parsedDate =
      !isStore && birthDate
        ? moment(birthDate, ["YYYY-MM-DD", "DD/MM/YYYY"]).toDate()
        : null;

    await user.update({
      password: hashedPassword,
      isStore,
      birthDate: parsedDate,
    });

    return res.status(200).json({ message: "Perfil completado correctamente" });
  } catch (err) {
    console.error("Error en completeGoogleUser:", err);
    return res.status(500).json({ message: "Error del servidor" });
  }
};