import { Router } from 'express';
import {
  getAllApplicationsByStatus,
  updateApplicationStatus,
} from '../../controllers/staff/application.controller';
import { isAuthenticated } from '../../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../../_core/middlewares/maintenance-mode.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.get(
  '/staff/v1/application',
  commonMiddlewares,
  getAllApplicationsByStatus as any
);

router.patch(
  '/staff/v1/application/status',
  commonMiddlewares,
  updateApplicationStatus as any
);

export default router;
