import { Request, Response } from 'express';
import Coupon from '../models/coupon';
import { Op } from 'sequelize';

// Obtener cupones no expirados y bloqueados para el usuario
export const getAvailableCouponsForUser = async (req: Request, res: Response) => {
  try {
    const now = new Date();
    const coupons = await Coupon.findAll({
      where: {
        expirationDate: { [Op.gt]: now },
        status: 'locked'
      }
    });
    return res.json(coupons);
  } catch (error) {
    console.error('Error al obtener cupones para usuario:', error);
    return res.status(500).json({ message: 'Error al obtener los cupones' });
  }
}; 