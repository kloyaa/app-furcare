import Joi from 'joi';
import { CustomJoiHelpers } from '../../utils/joi/joi.utils';
import {
  ApplicationStatusEnum,
  ApplicationTypeEnum,
  groomingPreferencesEnum,
} from '../../enum/application.enum';
import { applicationModelEnum } from '../../const/application.const';

/**
 * Validates the request body for updating application status
 */
export const validateUpdateApplicationStatus = (body: any) => {
  const schema = Joi.object({
    application: Joi.string()
      .trim()
      .required()
      .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    applicationType: Joi.string()
      .valid(...Object.values(ApplicationTypeEnum))
      .required()
      .messages({
        'any.only': `Application type must be one of: ${Object.values(
          ApplicationTypeEnum
        )}`,
      }),
    status: Joi.string()
      .valid(...Object.values(ApplicationStatusEnum))
      .optional()
      .messages({
        'any.only': `Status must be one of: ${Object.values(
          ApplicationStatusEnum
        ).join(', ')}`,
      }),
  });

  const { error } = schema.validate(body);
  return error;
};

/**
 * Validates query parameters for getting applications by status
 */
export const validateGetApplicationsByStatus = (query: any) => {
  const schema = Joi.object({
    status: Joi.string()
      .valid(...Object.values(ApplicationStatusEnum))
      .optional()
      .messages({
        'any.only': `Status must be one of: ${Object.values(
          ApplicationStatusEnum
        ).join(', ')}`,
      }),
    page: Joi.number().integer().min(1).optional().default(1),
    limit: Joi.number().integer().min(1).max(100).optional().default(20),
    applicationType: Joi.string()
      .valid('grooming', 'boarding', 'homeService', 'all')
      .optional()
      .default('all')
      .messages({
        'any.only':
          'Application type must be one of: grooming, boarding, homeService, all',
      }),
  });

  const { error } = schema.validate(query);
  return error;
};

/**
 * Validates parameters for getting application details
 */
export const validateGetApplicationDetails = (params: any) => {
  const schema = Joi.object({
    applicationId: Joi.string()
      .required()
      .pattern(/^[0-9a-fA-F]{24}$/)
      .messages({
        'string.pattern.base': 'Invalid application ID format',
      }),
    applicationType: Joi.string()
      .valid('grooming', 'boarding', 'homeService')
      .required()
      .messages({
        'any.only':
          'Application type must be one of: grooming, boarding, homeService',
      }),
  });

  const { error } = schema.validate(params);
  return error;
};
