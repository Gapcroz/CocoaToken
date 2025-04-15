import { Request, Response } from 'express';
import Coupon from '../models/coupon';
import User from '../models/user';
import { Op } from 'sequelize';

export const createCoupon = async (req: Request, res: Response) => {
  try {
    const { name, description, socialEvent, tokensRequired, expirationDate } = req.body;
    const storeId = (req as any).user?.get('id');

    // Validate required fields
    if (!name || !description || !tokensRequired || !expirationDate) {
      return res.status(400).json({ message: 'Faltan campos requeridos' });
    }

    // Verify that the user is a store
    const store = await User.findOne({ where: { id: storeId, isStore: true } });
    if (!store) {
      return res.status(403).json({ message: 'Solo las tiendas pueden crear cupones' });
    }

    const coupon = await Coupon.create({
      name,
      description,
      socialEvent,
      tokensRequired,
      expirationDate,
      storeId,
    });

    return res.status(201).json(coupon);
  } catch (error) {
    console.error('Error al crear cupón:', error);
    return res.status(500).json({ message: 'Error al crear el cupón' });
  }
};

export const getCouponsByStore = async (req: Request, res: Response) => {
  try {
    const storeId = (req as any).user?.get('id');
    
    if (!storeId) {
      return res.status(401).json({ message: 'No autorizado' });
    }

    // Verify that the user is a store
    const store = await User.findOne({ where: { id: storeId, isStore: true } });
    if (!store) {
      return res.status(403).json({ message: 'Solo las tiendas pueden ver sus cupones' });
    }

    const coupons = await Coupon.findAll({
      where: { storeId },
      include: [{
        model: User,
        as: 'store',
        attributes: ['name', 'email']
      }]
    });
    
    return res.json(coupons);
  } catch (error) {
    console.error('Error al obtener cupones:', error);
    return res.status(500).json({ message: 'Error al obtener los cupones' });
  }
};

export const updateCoupon = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const storeId = (req as any).user?.get('id');
    
    const coupon = await Coupon.findOne({
      where: { id, storeId }
    });

    if (!coupon) {
      return res.status(404).json({ message: 'Cupón no encontrado' });
    }

    await coupon.update(req.body);
    return res.json(coupon);
  } catch (error) {
    console.error('Error al actualizar cupón:', error);
    return res.status(500).json({ message: 'Error al actualizar el cupón' });
  }
};

export const deleteCoupon = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const storeId = (req as any).user?.get('id');
    
    const coupon = await Coupon.findOne({
      where: { id, storeId }
    });

    if (!coupon) {
      return res.status(404).json({ message: 'Cupón no encontrado' });
    }

    await coupon.destroy();
    return res.json({ message: 'Cupón eliminado correctamente' });
  } catch (error) {
    console.error('Error al eliminar cupón:', error);
    return res.status(500).json({ message: 'Error al eliminar el cupón' });
  }
};

export const getUserCoupons = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.get('id');
    
    if (!userId) {
      return res.status(401).json({ message: 'No autorizado' });
    }

    const coupons = await Coupon.findAll({
      where: {
        status: 'available',
        expirationDate: {
          [Op.gt]: new Date() // Solo cupones que no han expirado
        }
      },
      include: [{
        model: User,
        as: 'store',
        attributes: ['name', 'email']
      }]
    });
    
    return res.json(coupons);
  } catch (error) {
    console.error('Error al obtener cupones:', error);
    return res.status(500).json({ message: 'Error al obtener los cupones' });
  }
}; 