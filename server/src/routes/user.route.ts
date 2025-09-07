import { Router } from 'express';
import {
  createProfile,
  editProfile,
  getProfileByAccessToken,
} from '../controllers/user.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { authorize } from '../_core/middlewares/authorization.middleware';
import { RoleName } from '../_core/enum/roles.enum';
import { maintenanceModeMiddleware } from '../_core/middlewares/maintenance-mode.middleware';

const router = Router();

const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

router.post(
  '/user/v1/profile',
  [...commonMiddlewares, authorize(RoleName.User)] as any,
  createProfile as any
);
router.get(
  '/user/v1/profile',
  commonMiddlewares,
  getProfileByAccessToken as any
);
router.put('/user/v1/profile', commonMiddlewares, editProfile as any);

export default router;
