import { Router } from 'express';
import {
  createEKYCAccount,
  updateEKYCAccount,
} from '../controllers/ekyc.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];
const router = Router();

router.post('/ekyc/v1', commonMiddlewares, createEKYCAccount as any);

router.put('/ekyc/v1', commonMiddlewares, updateEKYCAccount as any);

export default router;
