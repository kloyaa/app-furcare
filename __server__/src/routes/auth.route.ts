import { Router } from 'express';
import { login, register, changeUserPassword } from '../controllers/auth.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [isAuthenticated];

router.post('/auth/v1/login', login as any);
router.post('/auth/v1/register', register as any);
router.post('/auth/v1/account/change-password', commonMiddlewares, changeUserPassword as any);

export default router;
