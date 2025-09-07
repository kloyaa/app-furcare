"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const payments_controller_1 = require("../../controllers/__admin/payments.controller");
const router = (0, express_1.Router)();
/**
 * @route GET /api/admin/applications/:applicationId/payments
 * @description Get all payment details for a specific application
 * @param applicationId - The ID of the application
 * @access Admin only
 */
router.get('/admin/v1/payments', payments_controller_1.getApplicationPayments);
exports.default = router;
