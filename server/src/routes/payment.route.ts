import { Router } from 'express';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import {
  createPayment,
  getPaymentById,
  getPaymentsByApplication,
  getPaymentStatistics,
  processPayment,
} from '../controllers/payment';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post('/payment/v1', commonMiddlewares, createPayment);
router.post(
  '/payment/v1/:application/process',
  commonMiddlewares,
  processPayment
);
router.get(
  '/payment/v1/application/:application',
  commonMiddlewares,
  getPaymentsByApplication
);
router.get('/payment/v1/statistics', commonMiddlewares, getPaymentStatistics);
router.get('/payment/v1/:payment', commonMiddlewares, getPaymentById);

// router.get('/payment/v1/user/:user', commonMiddlewares, getPaymentsByUser);
// router.patch('/payment/v1/:application/status', commonMiddlewares, updatePaymentStatus);
// router.post('/payment/v1/:application/refund', commonMiddlewares, refundPayment);

export default router;
