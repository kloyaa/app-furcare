import { Router } from 'express';
import { createProfile, getProfileByAccessToken } from '../controllers/user.controller';
import { isAuthenticated } from '../_core/middlewares/jwt.middleware';
import { authorize } from '../_core/middlewares/authorization.middleware';
import { RoleName } from '../_core/enum/roles.enum';

const router = Router();

const commonMiddlewares = [isAuthenticated];

router.post('/user/v1/profile', [...commonMiddlewares, authorize(RoleName.User)] as any, createProfile as any);
router.get('/user/v1/profile', commonMiddlewares, getProfileByAccessToken as any);

export default router;
