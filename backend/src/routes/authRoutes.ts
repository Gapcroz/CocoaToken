import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user";

const router = express.Router();

// Secret para el token
const JWT_SECRET = "mi_clave_secreta_super_segura"; // puedes mover esto al .env

// 📌 Registro
router.post("/register", async (req, res) => {
  const { email, password } = req.body;

  try {
    // Verificar si el usuario ya existe
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser)
      return res.status(409).json({ message: "El usuario ya existe." });

    // Encriptar contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Crear usuario
    const newUser = await User.create({ email, password: hashedPassword });
    res
      .status(201)
      .json({ message: "Usuario creado correctamente", user: newUser });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// 🔐 Login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    // Buscar usuario
    const user = await User.findOne({ where: { email } });
    if (!user)
      return res.status(404).json({ message: "Usuario no encontrado" });

    // Comparar contraseñas
    const isMatch = await bcrypt.compare(
      password,
      user.get("password") as string
    );
    if (!isMatch)
      return res.status(401).json({ message: "Contraseña incorrecta" });

    // Generar token
    const token = jwt.sign({ userId: user.get("id") }, JWT_SECRET, {
      expiresIn: "1h",
    });

    res.json({ message: "Login exitoso", token });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

export default router;
