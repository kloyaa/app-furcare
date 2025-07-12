import { Router } from 'express';
import { uploadImage } from '../controllers/upload.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
const router = Router();

const commonMiddlewares = [isAuthenticated];

router.post('/upload/v1/image', uploadImage as any);

export default router;
