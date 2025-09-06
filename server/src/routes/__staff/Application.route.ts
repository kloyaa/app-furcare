import { Router } from 'express';
import { getAllApplicationsByStatus, updateApplicationStatus } from '../../controllers/__staff/application.controller';
import { isAuthenticated } from '../../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [isAuthenticated];

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
