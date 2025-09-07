import { Router } from 'express';
import { getActivity } from '../controllers/activity.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.get('/activity/v1', commonMiddlewares, getActivity as any);

export default router;
