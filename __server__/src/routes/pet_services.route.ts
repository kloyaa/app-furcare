import { Router } from 'express';
import { getGroomingSchedules, getPetServices, getGroomingExtra, getGroomingPreferences } from '../controllers/pet_services.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
const router = Router();

const commonMiddlewares = [isAuthenticated];

router.get('/pet-services/v1', commonMiddlewares, getPetServices as any);

// Grooming
router.get('/pet-services/v1/grooming-options', commonMiddlewares, getGroomingExtra as any);
router.get('/pet-services/v1/grooming-schedules', commonMiddlewares, getGroomingSchedules as any);
router.get('/pet-services/v1/grooming-preferences', commonMiddlewares, getGroomingPreferences as any);

export default router;