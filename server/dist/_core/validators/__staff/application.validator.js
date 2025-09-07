"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateGetApplicationDetails = exports.validateGetApplicationsByStatus = exports.validateUpdateApplicationStatus = void 0;
const joi_1 = __importDefault(require("joi"));
const joi_utils_1 = require("../../utils/joi/joi.utils");
const application_enum_1 = require("../../enum/application.enum");
/**
 * Validates the request body for updating application status
 */
const validateUpdateApplicationStatus = (body) => {
    const schema = joi_1.default.object({
        application: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        applicationType: joi_1.default.string()
            .valid(...Object.values(application_enum_1.ApplicationTypeEnum))
            .required()
            .messages({
            'any.only': `Application type must be one of: ${Object.values(application_enum_1.ApplicationTypeEnum)}`,
        }),
        status: joi_1.default.string()
            .valid(...Object.values(application_enum_1.ApplicationStatusEnum))
            .optional()
            .messages({
            'any.only': `Status must be one of: ${Object.values(application_enum_1.ApplicationStatusEnum).join(', ')}`,
        }),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateUpdateApplicationStatus = validateUpdateApplicationStatus;
/**
 * Validates query parameters for getting applications by status
 */
const validateGetApplicationsByStatus = (query) => {
    const schema = joi_1.default.object({
        status: joi_1.default.string()
            .valid(...Object.values(application_enum_1.ApplicationStatusEnum))
            .optional()
            .messages({
            'any.only': `Status must be one of: ${Object.values(application_enum_1.ApplicationStatusEnum).join(', ')}`,
        }),
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
            .default(20),
        applicationType: joi_1.default.string()
            .valid('grooming', 'boarding', 'homeService', 'all')
            .optional()
            .default('all')
            .messages({
            'any.only': 'Application type must be one of: grooming, boarding, homeService, all',
        }),
    });
    const { error } = schema.validate(query);
    return error;
};
exports.validateGetApplicationsByStatus = validateGetApplicationsByStatus;
/**
 * Validates parameters for getting application details
 */
const validateGetApplicationDetails = (params) => {
    const schema = joi_1.default.object({
        applicationId: joi_1.default.string()
            .required()
            .pattern(/^[0-9a-fA-F]{24}$/)
            .messages({
            'string.pattern.base': 'Invalid application ID format',
        }),
        applicationType: joi_1.default.string()
            .valid('grooming', 'boarding', 'homeService')
            .required()
            .messages({
            'any.only': 'Application type must be one of: grooming, boarding, homeService',
        }),
    });
    const { error } = schema.validate(params);
    return error;
};
exports.validateGetApplicationDetails = validateGetApplicationDetails;
