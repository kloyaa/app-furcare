import { Router } from 'express';
import {
  getAllCages,
  insertCages,
  validateCageAvailability,
  updateCageOccupant,
  getGroomingSchedules,
  getPetServices,
  getGroomingExtra,
  getGroomingPreferences,
} from '../controllers/pet_services.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';
const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.get('/pet-services/v1', commonMiddlewares, getPetServices as any);

// Grooming
router.get(
  '/pet-services/v1/grooming-options',
  commonMiddlewares,
  getGroomingExtra as any
);
router.get(
  '/pet-services/v1/grooming-schedules',
  commonMiddlewares,
  getGroomingSchedules as any
);
router.get(
  '/pet-services/v1/grooming-preferences',
  commonMiddlewares,
  getGroomingPreferences as any
);

// Cages
router.get('/pet-services/v1/cages', commonMiddlewares, getAllCages as any);
router.post('/pet-services/v1/cages', commonMiddlewares, insertCages as any);
router.put(
  '/pet-services/v1/cages',
  commonMiddlewares,
  updateCageOccupant as any
);
router.get(
  '/pet-services/v1/cages/availability/:id',
  commonMiddlewares,
  validateCageAvailability as any
);

export default router;
