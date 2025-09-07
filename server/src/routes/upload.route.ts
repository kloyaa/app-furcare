import { Router } from 'express';
import { uploadImage } from '../controllers/upload.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';
const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post('/upload/v1/image', uploadImage as any);

export default router;
