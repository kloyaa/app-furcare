"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateApplicationPayments = exports.validateApplicationFilters = exports.validateUserManagement = void 0;
const joi_1 = __importDefault(require("joi"));
const joi_utils_1 = require("../../utils/joi/joi.utils");
const validateUserManagement = (body) => {
    const schema = joi_1.default.object({
        user: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateUserManagement = validateUserManagement;
const validateApplicationFilters = (query) => {
    const schema = joi_1.default.object({
        status: joi_1.default.string()
            .trim()
            .optional()
            .valid('pending', 'approved', 'rejected', 'completed', 'cancelled'),
        serviceType: joi_1.default.string()
            .trim()
            .optional()
            .valid('grooming', 'boarding', 'home_service'),
        page: joi_1.default.number()
            .integer()
            .min(1)
            .optional()
            .default(1),
        limit: joi_1.default.number()
            .integer()
            .min(1)
            .max(100)
            .optional()
            .default(50),
    });
    const { error } = schema.validate(query);
    return error;
};
exports.validateApplicationFilters = validateApplicationFilters;
const validateApplicationPayments = (params) => {
    const schema = joi_1.default.object({
        application: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    });
    const { error } = schema.validate(params);
    return error;
};
exports.validateApplicationPayments = validateApplicationPayments;
