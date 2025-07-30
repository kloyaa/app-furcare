import { Router } from 'express';
import { createGroomingApplication, getGroomingApplications, createBoardingApplication, getBoardingApplications } from '../controllers/application.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [isAuthenticated];

// Grooming Applications
router.post('/application/v1/grooming', commonMiddlewares, createGroomingApplication as any);
router.post('/application/v1/boarding', commonMiddlewares, createBoardingApplication as any);

router.get('/application/v1/grooming', commonMiddlewares, getGroomingApplications as any);
router.get('/application/v1/boarding', commonMiddlewares, getBoardingApplications as any);

export default router;