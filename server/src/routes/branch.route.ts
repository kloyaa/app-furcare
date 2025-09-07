import { Router } from 'express';
import {
  createRandomBranches,
  getBranches,
  clearBranches,
} from '../controllers/branch.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post('/branch/v1', commonMiddlewares, createRandomBranches as any);
router.get('/branch/v1', commonMiddlewares, getBranches as any);
router.delete('/branch/v1', commonMiddlewares, clearBranches as any);

export default router;
