import { Router } from 'express';
import { getActivity } from '../controllers/activity.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
const router = Router();

const commonMiddlewares = [isAuthenticated];

router.get('/activity/v1', commonMiddlewares, getActivity as any);

export default router;
