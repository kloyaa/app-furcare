import Joi from 'joi';
import { CustomJoiHelpers } from '../../utils/joi/joi.utils';

export const validateUserManagement = (body: any) => {
    const schema = Joi.object({
        user: Joi.string()
            .trim()
            .required()
            .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    });

    const { error } = schema.validate(body);
    return error;
};

export const validateApplicationFilters = (query: any) => {
    const schema = Joi.object({
        status: Joi.string()
            .trim()
            .optional()
            .valid('pending', 'approved', 'rejected', 'completed', 'cancelled'),
        serviceType: Joi.string()
            .trim()
            .optional()
            .valid('grooming', 'boarding', 'home_service'),
        page: Joi.number()
            .integer()
            .min(1)
            .optional()
            .default(1),
        limit: Joi.number()
            .integer()
            .min(1)
            .max(100)
            .optional()
            .default(50),
    });

    const { error } = schema.validate(query);
    return error;
};

export const validateApplicationPayments = (params: any) => {
    const schema = Joi.object({
        application: Joi.string()
            .trim()
            .required()
            .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    });

    const { error } = schema.validate(params);
    return error;
};