import { Router } from 'express';
import { isAuthenticated } from '../../../_core/middlewares/jwt.middleware';
import {
    createBoardingApplication,
    createBoardingApplicationExtension,
    getBoardingApplications
} from '../../../controllers/application/Boarding';

const router = Router();
const commonMiddlewares = [isAuthenticated];

router.post(
    '/application/v1/boarding',
    commonMiddlewares,
    createBoardingApplication as any
);
router.post(
    '/application/v1/boarding/extension',
    commonMiddlewares,
    createBoardingApplicationExtension as any
);
router.get(
    '/application/v1/boarding',
    commonMiddlewares,
    getBoardingApplications as any
);

export default router;
