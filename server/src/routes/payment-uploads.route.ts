import { Router } from 'express';
import multer from 'multer';
import { uploadPaymentReceipts } from '../controllers/payment/payment-uploads.controller';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { fileFilter, storage } from '../_core/services/upload/image_upload.service';

const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];
router.post('/upload/v1/payment/receipts', commonMiddlewares, uploadPaymentReceipts);

export default router;
