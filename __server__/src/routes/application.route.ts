import { Router } from 'express';
import { createGroomingApplication, getGroomingApplications } from '../controllers/application.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [isAuthenticated];

// Grooming Applications
router.post('/application/v1/grooming', commonMiddlewares, createGroomingApplication as any);
router.get('/application/v1/grooming', commonMiddlewares, getGroomingApplications as any);

export default router;