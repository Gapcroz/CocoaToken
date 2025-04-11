import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User from '../models/user';

const JWT_SECRET = process.env.JWT_SECRET || "mi_clave_secreta_super_segura";

export const isAuthenticated = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'No hay token de autenticación' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, JWT_SECRET) as { userId: number };
    
    const user = await User.findByPk(decoded.userId);
    if (!user) {
      return res.status(401).json({ message: 'Usuario no encontrado' });
    }

    (req as any).user = user;
    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({ message: 'Token inválido' });
    }
    console.error('Error en autenticación:', error);
    return res.status(500).json({ message: 'Error en la autenticación' });
  }
}; 