import { Router } from 'express';
import { isAuthenticated } from '../../../_core/middlewares/jwt.middleware';
import { createGroomingApplication, getGroomingApplications } from '../../../controllers/application/Grooming';

const router = Router();
const commonMiddlewares = [isAuthenticated];

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
