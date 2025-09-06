import { Router } from 'express';
import { getApplicationPayments } from '../../controllers/__admin/payments_controller';


const router = Router();


/**
 * @route GET /api/admin/applications/:applicationId/payments
 * @description Get all payment details for a specific application
 * @param applicationId - The ID of the application
 * @access Admin only
 */
router.get('/admin/v1/payments', getApplicationPayments);

export default router;