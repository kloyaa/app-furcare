import { Router } from 'express';
import { isAuthenticated } from '../../../_core/middlewares/jwt.middleware';
import { createHomeServiceApplication, getHomeServiceApplications } from '../../../controllers/application/HomeService';

const router = Router();
const commonMiddlewares = [isAuthenticated];

router.post(
    '/application/v1/home-service',
    commonMiddlewares,
    createHomeServiceApplication as any
);

router.get(
    '/application/v1/home-service',
    commonMiddlewares,
    getHomeServiceApplications as any
);

export default router;
