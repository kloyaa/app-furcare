"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateBulkUpdatePayments = exports.validatePaymentAmount = exports.validatePaymentStatistics = exports.validateGetPayments = exports.validateRefundPayment = exports.validateProcessPayment = exports.validateUpdatePaymentStatus = exports.validateCreatePayment = void 0;
// _core/validators/payment.validator.ts
const joi_1 = __importDefault(require("joi"));
const joi_utils_1 = require("../utils/joi/joi.utils");
const application_const_1 = require("../const/application.const");
const validateCreatePayment = (body) => {
    const schema = joi_1.default.object({
        application: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        applicationModel: joi_1.default.string()
            .trim()
            .required()
            .valid(...application_const_1.applicationModelEnum),
        amount: joi_1.default.number()
            .min(0.01)
            .max(999999)
            .precision(2)
            .required(),
        paymentMethod: joi_1.default.string()
            .trim()
            .required()
            .valid(...application_const_1.paymentMethodEnum),
        paymentType: joi_1.default.string()
            .trim()
            .valid(...application_const_1.paymentTypeEnum)
            .default('full_payment'),
        notes: joi_1.default.string()
            .trim()
            .max(500)
            .allow('')
            .optional()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreatePayment = validateCreatePayment;
const validateUpdatePaymentStatus = (body) => {
    const schema = joi_1.default.object({
        status: joi_1.default.string()
            .trim()
            .required()
            .valid(...application_const_1.paymentStatusEnum),
        transactionId: joi_1.default.string()
            .trim()
            .min(1)
            .max(100)
            .when('status', {
            is: 'completed',
            then: joi_1.default.required(),
            otherwise: joi_1.default.optional()
        }),
        gatewayResponse: joi_1.default.object()
            .optional(),
        notes: joi_1.default.string()
            .trim()
            .max(500)
            .allow('')
            .optional()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateUpdatePaymentStatus = validateUpdatePaymentStatus;
const validateProcessPayment = (body) => {
    const schema = joi_1.default.object({
        gatewayData: joi_1.default.object({
            reference: joi_1.default.string().trim().optional(),
            merchant: joi_1.default.string().trim().optional(),
            customerDetails: joi_1.default.object().optional(),
            additionalInfo: joi_1.default.object().optional()
        }).optional().default({})
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateProcessPayment = validateProcessPayment;
const validateRefundPayment = (body) => {
    const schema = joi_1.default.object({
        refundAmount: joi_1.default.number()
            .min(0.01)
            .max(999999)
            .precision(2)
            .optional(),
        reason: joi_1.default.string()
            .trim()
            .min(1)
            .max(500)
            .required()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateRefundPayment = validateRefundPayment;
const validateGetPayments = (query) => {
    const schema = joi_1.default.object({
        status: joi_1.default.string()
            .trim()
            .valid(...application_const_1.paymentStatusEnum)
            .optional(),
        paymentMethod: joi_1.default.string()
            .trim()
            .valid(...application_const_1.paymentMethodEnum)
            .optional(),
        page: joi_1.default.number()
            .integer()
            .min(1)
            .max(1000)
            .default(1),
        limit: joi_1.default.number()
            .integer()
            .min(1)
            .max(100)
            .default(50),
        startDate: joi_1.default.date()
            .iso()
            .optional(),
        endDate: joi_1.default.date()
            .iso()
            .min(joi_1.default.ref('startDate'))
            .optional()
    });
    const { error } = schema.validate(query);
    return error;
};
exports.validateGetPayments = validateGetPayments;
const validatePaymentStatistics = (query) => {
    const schema = joi_1.default.object({
        userId: joi_1.default.string()
            .trim()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation')
            .optional(),
        branchId: joi_1.default.string()
            .trim()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation')
            .optional(),
        startDate: joi_1.default.date()
            .iso()
            .optional(),
        endDate: joi_1.default.date()
            .iso()
            .min(joi_1.default.ref('startDate'))
            .optional(),
        groupBy: joi_1.default.string()
            .trim()
            .valid('day', 'week', 'month', 'year', 'status', 'method')
            .default('status')
    });
    const { error } = schema.validate(query);
    return error;
};
exports.validatePaymentStatistics = validatePaymentStatistics;
// Additional helper validation for payment amounts
const validatePaymentAmount = (body) => {
    const schema = joi_1.default.object({
        amount: joi_1.default.number()
            .min(0.01)
            .max(999999)
            .precision(2)
            .required(),
        currency: joi_1.default.string()
            .trim()
            .valid('PHP', 'USD')
            .default('PHP')
            .optional()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validatePaymentAmount = validatePaymentAmount;
// Validation for bulk payment operations
const validateBulkUpdatePayments = (body) => {
    const schema = joi_1.default.object({
        paymentIds: joi_1.default.array()
            .items(joi_1.default.string().custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'))
            .min(1)
            .max(50)
            .unique()
            .required(),
        status: joi_1.default.string()
            .trim()
            .required()
            .valid(...application_const_1.paymentStatusEnum),
        notes: joi_1.default.string()
            .trim()
            .max(500)
            .allow('')
            .optional()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateBulkUpdatePayments = validateBulkUpdatePayments;
