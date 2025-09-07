// _core/validators/payment.validator.ts
import Joi from 'joi';
import { CustomJoiHelpers } from '../utils/joi/joi.utils';
import {
  applicationModelEnum,
  paymentMethodEnum,
  paymentTypeEnum,
  paymentStatusEnum,
} from '../const/application.const';

export const validateCreatePayment = (body: any) => {
  const schema = Joi.object({
    application: Joi.string()
      .trim()
      .required()
      .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    applicationModel: Joi.string()
      .trim()
      .required()
      .valid(...applicationModelEnum),
    amount: Joi.number().min(0.01).max(999999).precision(2).required(),
    paymentMethod: Joi.string()
      .trim()
      .required()
      .valid(...paymentMethodEnum),
    paymentType: Joi.string()
      .trim()
      .valid(...paymentTypeEnum)
      .default('full_payment'),
    notes: Joi.string().trim().max(500).allow('').optional(),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateUpdatePaymentStatus = (body: any) => {
  const schema = Joi.object({
    status: Joi.string()
      .trim()
      .required()
      .valid(...paymentStatusEnum),
    transactionId: Joi.string().trim().min(1).max(100).when('status', {
      is: 'completed',
      then: Joi.required(),
      otherwise: Joi.optional(),
    }),
    gatewayResponse: Joi.object().optional(),
    notes: Joi.string().trim().max(500).allow('').optional(),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateProcessPayment = (body: any) => {
  const schema = Joi.object({
    gatewayData: Joi.object({
      reference: Joi.string().trim().optional(),
      merchant: Joi.string().trim().optional(),
      customerDetails: Joi.object().optional(),
      additionalInfo: Joi.object().optional(),
    })
      .optional()
      .default({}),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateRefundPayment = (body: any) => {
  const schema = Joi.object({
    refundAmount: Joi.number().min(0.01).max(999999).precision(2).optional(),
    reason: Joi.string().trim().min(1).max(500).required(),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateGetPayments = (query: any) => {
  const schema = Joi.object({
    status: Joi.string()
      .trim()
      .valid(...paymentStatusEnum)
      .optional(),
    paymentMethod: Joi.string()
      .trim()
      .valid(...paymentMethodEnum)
      .optional(),
    page: Joi.number().integer().min(1).max(1000).default(1),
    limit: Joi.number().integer().min(1).max(100).default(50),
    startDate: Joi.date().iso().optional(),
    endDate: Joi.date().iso().min(Joi.ref('startDate')).optional(),
  });

  const { error } = schema.validate(query);
  return error;
};

export const validatePaymentStatistics = (query: any) => {
  const schema = Joi.object({
    userId: Joi.string()
      .trim()
      .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation')
      .optional(),
    branchId: Joi.string()
      .trim()
      .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation')
      .optional(),
    startDate: Joi.date().iso().optional(),
    endDate: Joi.date().iso().min(Joi.ref('startDate')).optional(),
    groupBy: Joi.string()
      .trim()
      .valid('day', 'week', 'month', 'year', 'status', 'method')
      .default('status'),
  });

  const { error } = schema.validate(query);
  return error;
};

// Additional helper validation for payment amounts
export const validatePaymentAmount = (body: any) => {
  const schema = Joi.object({
    amount: Joi.number().min(0.01).max(999999).precision(2).required(),
    currency: Joi.string().trim().valid('PHP', 'USD').default('PHP').optional(),
  });

  const { error } = schema.validate(body);
  return error;
};

// Validation for bulk payment operations
export const validateBulkUpdatePayments = (body: any) => {
  const schema = Joi.object({
    paymentIds: Joi.array()
      .items(
        Joi.string().custom(
          CustomJoiHelpers.isValidObjectId,
          'ObjectId validation'
        )
      )
      .min(1)
      .max(50)
      .unique()
      .required(),
    status: Joi.string()
      .trim()
      .required()
      .valid(...paymentStatusEnum),
    notes: Joi.string().trim().max(500).allow('').optional(),
  });

  const { error } = schema.validate(body);
  return error;
};
