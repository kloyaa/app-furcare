import { Router } from 'express';
import { getApplicationPayments } from '../../controllers/admin/payments.controller';
import { maintenanceModeMiddleware } from '../../_core/middlewares/maintenance-mode.middleware';
import { isAuthenticated } from '../../_core/middlewares/jwt.middleware';

const router = Router();
const commonMiddlewares = [maintenanceModeMiddleware, isAuthenticated];

/**
 * @route GET /api/admin/applications/:applicationId/payments
 * @description Get all payment details for a specific application
 * @param applicationId - The ID of the application
 * @access Admin only
 */
router.get('/admin/v1/payments', commonMiddlewares, getApplicationPayments);

export default router;
