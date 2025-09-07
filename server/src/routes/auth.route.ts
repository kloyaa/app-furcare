import { Router } from 'express';
import {
  login,
  register,
  changeUserPassword,
} from '../controllers/auth.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post('/auth/v1/login', maintenanceModeMiddleware, login as any);
router.post('/auth/v1/register', maintenanceModeMiddleware, register as any);
router.post(
  '/auth/v1/account/change-password',
  commonMiddlewares,
  changeUserPassword as any
);

export default router;
