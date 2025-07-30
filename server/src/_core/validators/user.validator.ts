import Joi from 'joi';

export const validateCreateProfile = (body: any) => {
  const schema = Joi.object({
    fullName: Joi.string().trim().min(2).max(100).required(),
    address: Joi.string().trim().min(5).max(255).required(),
    contact: Joi.object({
      facebookUrl: Joi.string().uri().optional().allow(''),
      messengerUrl: Joi.string().uri().optional().allow(''),
      phoneNumber: Joi.string()
        .trim()
        .pattern(/^09\d{9}$/) // Philippine mobile format
        .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
        .required(),
    }).required(),
    isActive: Joi.boolean().optional(), // optional since defaults in schema
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateUpdateProfile = (body: any) => {
  const allowedKeys = ['firstName', 'lastName', 'birthdate', 'address', 'contact', 'gender'];

  const schema = Joi.object({
    keys: Joi.array()
      .items(Joi.string().valid(...allowedKeys))
      .required(),
    values: Joi.array().required(),
  });

  const { error } = schema.validate(body);
  return error;
};
