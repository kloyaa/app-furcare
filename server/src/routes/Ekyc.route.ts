import { Router } from 'express';
import { createEKYCAccount } from '../controllers/ekyc.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [isAuthenticated];

router.post(
    '/ekyc/v1',
    commonMiddlewares,
    createEKYCAccount as any
);

export default router;
