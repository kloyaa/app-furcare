import { Router } from 'express';
import {
  getAllApplications,
  getApplicationStatistics,
} from '../../controllers/admin/application.controller';
import { maintenanceModeMiddleware } from '../../_core/middlewares/maintenance-mode.middleware';
import { isAuthenticated } from '../../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

/**
 * @route GET /api/admin/applications
 * @description Get all applications across all services with filtering options
 * @query status - Filter by application status (optional)
 * @query serviceType - Filter by service type: grooming, boarding, home_service (optional)
 * @query page - Page number for pagination (default: 1)
 * @query limit - Items per page (default: 50, max: 100)
 * @access Admin only
 */
router.get('/admin/v1/applications', commonMiddlewares, getAllApplications);

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
router.get('/admin/v1/statistics', commonMiddlewares, getApplicationStatistics);

export default router;
