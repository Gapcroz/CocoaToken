import { Router } from 'express';
import { createCoupon, getCouponsByStore, updateCoupon, deleteCoupon } from '../controllers/coupon.controller';
import { isAuthenticated } from '../middleware/auth.middleware';

const router = Router();

// All routes require authentication
router.use(isAuthenticated);

// Coupon routes
router.post('/', createCoupon);
router.get('/store', getCouponsByStore);
router.put('/:id', updateCoupon);
router.delete('/:id', deleteCoupon);

export default router; 