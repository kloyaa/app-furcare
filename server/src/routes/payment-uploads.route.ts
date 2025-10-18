import { Router } from 'express';
import multer from 'multer';
import { uploadPaymentReceipts } from '../controllers/payment/payment-uploads.controller';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';

const router = Router();
const storage = multer.memoryStorage();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

const fileFilter = (req, file, callback) => {
    if (['image/png', 'image/jpg', 'image/jpeg', 'video/mp4'].includes(file.mimetype)) {
        callback(null, true);
    } else {
        callback(null, false);
    }
};

const upload = multer({ storage, fileFilter });

router.post(
    '/upload/v1/payment/receipts',
    [maintenanceModeMiddleware, isAuthenticated, upload.array('media')],
    uploadPaymentReceipts
);

export default router;
