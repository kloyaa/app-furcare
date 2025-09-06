import Joi from 'joi';
import { CustomJoiHelpers } from '../utils/joi/joi.utils';

/**
 * Validates basic eKYC registration data (simplified version).
 *
 * @param {any} body - The request body containing basic registration data.
 * @return {Joi.ValidationError | null} Validation error if any, null if valid.
 */
export const validateEKYCRegistration = (body: any): Joi.ValidationError | null => {
    const schema = Joi.object({
        username: Joi.string().required(),
        email: Joi.string()
            .email({ tlds: { allow: false } })
            .trim()
            .lowercase()
            .required()
            .messages({
                'string.email': 'Please provide a valid email address',
            }),
        password: Joi.string()
            .required()
            .min(6)
            .max(255)
            .pattern(
                new RegExp(/^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)
            )
            .messages({
                'string.pattern.base':
                    'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
            }),
        fullName: Joi.string().trim().min(2).max(100).required(),
        address: Joi.string().trim().min(5).max(255).required(),
        contact: Joi.object({
            facebookDisplayName: Joi
                .string()
                .optional()
                .allow(''),
            phoneNumber: Joi
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

/**
 * Validates eKYC update data.
 *
 * @param {any} body - The request body containing eKYC update data.
 * @return {Joi.ValidationError | null} Validation error if any, null if valid.
 */
export const validateEKYCUpdate = (body: any): Joi.ValidationError | null => {
    const schema = Joi.object({
        user: Joi.string()
            .trim()
            .required()
            .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        email: Joi.string()
            .email({ tlds: { allow: false } })
            .trim()
            .lowercase()
            .required()
            .messages({
                'string.email': 'Please provide a valid email address',
            }),
        password: Joi.optional(),
        fullName: Joi.string().trim().min(2).max(100).required(),
        address: Joi.string().trim().min(5).max(255).required(),
        contact: Joi.object({
            facebookDisplayName: Joi
                .string()
                .optional()
                .allow(''),
            phoneNumber: Joi
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