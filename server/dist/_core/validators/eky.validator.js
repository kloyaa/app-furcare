"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateEKYCUpdate = exports.validateEKYCRegistration = void 0;
const joi_1 = __importDefault(require("joi"));
const joi_utils_1 = require("../utils/joi/joi.utils");
/**
 * Validates basic eKYC registration data (simplified version).
 *
 * @param {any} body - The request body containing basic registration data.
 * @return {Joi.ValidationError | null} Validation error if any, null if valid.
 */
const validateEKYCRegistration = (body) => {
    const schema = joi_1.default.object({
        username: joi_1.default.string().required(),
        email: joi_1.default.string()
            .email({ tlds: { allow: false } })
            .trim()
            .lowercase()
            .required()
            .messages({
            'string.email': 'Please provide a valid email address',
        }),
        password: joi_1.default.string()
            .required()
            .min(6)
            .max(255)
            .pattern(new RegExp(/^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/))
            .messages({
            'string.pattern.base': 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
        }),
        fullName: joi_1.default.string().trim().min(2).max(100).required(),
        address: joi_1.default.string().trim().min(5).max(255).required(),
        contact: joi_1.default.object({
            facebookDisplayName: joi_1.default
                .string()
                .optional()
                .allow(''),
            phoneNumber: joi_1.default
                .string()
                .trim()
                .pattern(/^09\d{9}$/) // Philippine mobile format
                .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
                .required(),
        }).required(),
    });
    const { error } = schema.validate(body, {
        abortEarly: false,
        allowUnknown: false
    });
    return error;
};
exports.validateEKYCRegistration = validateEKYCRegistration;
/**
 * Validates eKYC update data.
 *
 * @param {any} body - The request body containing eKYC update data.
 * @return {Joi.ValidationError | null} Validation error if any, null if valid.
 */
const validateEKYCUpdate = (body) => {
    const schema = joi_1.default.object({
        user: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        email: joi_1.default.string()
            .email({ tlds: { allow: false } })
            .trim()
            .lowercase()
            .required()
            .messages({
            'string.email': 'Please provide a valid email address',
        }),
        password: joi_1.default.optional(),
        fullName: joi_1.default.string().trim().min(2).max(100).required(),
        address: joi_1.default.string().trim().min(5).max(255).required(),
        contact: joi_1.default.object({
            facebookDisplayName: joi_1.default
                .string()
                .optional()
                .allow(''),
            phoneNumber: joi_1.default
                .string()
                .trim()
                .pattern(/^09\d{9}$/) // Philippine mobile format
                .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
                .required(),
        }).required(),
    });
    const { error } = schema.validate(body, {
        abortEarly: false,
        allowUnknown: false
    });
    return error;
};
exports.validateEKYCUpdate = validateEKYCUpdate;
