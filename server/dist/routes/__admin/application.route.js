"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const application_controller_1 = require("../../controllers/__admin/application.controller");
const router = (0, express_1.Router)();
/**
 * @route GET /api/admin/applications
 * @description Get all applications across all services with filtering options
 * @query status - Filter by application status (optional)
 * @query serviceType - Filter by service type: grooming, boarding, home_service (optional)
 * @query page - Page number for pagination (default: 1)
 * @query limit - Items per page (default: 50, max: 100)
 * @access Admin only
 */
router.get('/admin/v1/applications', application_controller_1.getAllApplications);
/**
 * @route GET /api/admin/applications/:applicationId/payments
 * @description Get all payment details for a specific application
 * @param applicationId - The ID of the application
 * @access Admin only
 */
// router.get('/applications/:applicationId/payments', getApplicationPayments);
/**
 * @route GET /api/admin/statistics
 * @description Get monthly application statistics by service type
 * @access Admin only
 */
router.get('/admin/v1/statistics', application_controller_1.getApplicationStatistics);
exports.default = router;
