import { Router } from 'express';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import {
  generatePassword,
  generateUsername,
} from '../controllers/auxiliary.controller';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';
const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.get('/aux/v1/generate/password', generatePassword as any);
router.get('/aux/v1/generate/username', generateUsername as any);

export default router;
