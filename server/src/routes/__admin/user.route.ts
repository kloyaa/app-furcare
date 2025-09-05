import { Router } from 'express';
import { activateUser, disableUser, getAllUsers } from '../../controllers/__admin/user_controller';


const router = Router();

/**
 * @route GET /api/admin/users
 * @description Get all users (staff and customers) sorted by latest created date
 * @access Admin only
 */
router.get('/admin/v1/users', getAllUsers);

/**
 * @route PATCH /api/admin/users/activate
 * @description Activate a user account
 * @body userId - The ID of the user to activate
 * @access Admin only
 */
router.patch('/admin/v1/users/activate', activateUser);

/**
 * @route PATCH /api/admin/users/disable
 * @description Disable a user account
 * @body userId - The ID of the user to disable
 * @access Admin only
 */
router.patch('/admin/v1/users/disable', disableUser);

export default router;