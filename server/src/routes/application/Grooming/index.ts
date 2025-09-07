import { Router } from 'express';
import { isAuthenticated } from '../../../_core/middlewares/jwt.middleware';
import {
  createGroomingApplication,
  getGroomingApplications,
} from '../../../controllers/application/grooming';
import { maintenanceModeMiddleware } from '../../../_core/middlewares/maintenance-mode.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post(
  '/application/v1/grooming',
  commonMiddlewares,
  createGroomingApplication as any
);
router.get(
  '/application/v1/grooming',
  commonMiddlewares,
  getGroomingApplications as any
);

export default router;
