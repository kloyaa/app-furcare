"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const user_controller_1 = require("../../controllers/__admin/user.controller");
const router = (0, express_1.Router)();
/**
 * @route GET /api/admin/users
 * @description Get all users (staff and customers) sorted by latest created date
 * @access Admin only
 */
router.get('/admin/v1/users', user_controller_1.getAllUsers);
/**
 * @route PATCH /api/admin/users/activate
 * @description Activate a user account
 * @body userId - The ID of the user to activate
 * @access Admin only
 */
router.patch('/admin/v1/users/activate', user_controller_1.activateUser);
/**
 * @route PATCH /api/admin/users/disable
 * @description Disable a user account
 * @body userId - The ID of the user to disable
 * @access Admin only
 */
router.patch('/admin/v1/users/deactivate', user_controller_1.disableUser);
exports.default = router;
