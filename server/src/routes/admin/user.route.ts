import { Router } from 'express';
import {
  activateUser,
  disableUser,
  getAllUsers,
} from '../../controllers/admin/user.controller';
import { maintenanceModeMiddleware } from '../../_core/middlewares/maintenance-mode.middleware';
import { isAuthenticated } from '../../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];
/**
 * @route GET /api/admin/users
 * @description Get all users (staff and customers) sorted by latest created date
 * @access Admin only
 */
router.get('/admin/v1/users', commonMiddlewares, getAllUsers);

/**
 * @route PATCH /api/admin/users/activate
 * @description Activate a user account
 * @body userId - The ID of the user to activate
 * @access Admin only
 */
router.patch('/admin/v1/users/activate', commonMiddlewares, activateUser);

/**
 * @route PATCH /api/admin/users/disable
 * @description Disable a user account
 * @body userId - The ID of the user to disable
 * @access Admin only
 */
router.patch('/admin/v1/users/deactivate', commonMiddlewares, disableUser);

export default router;
