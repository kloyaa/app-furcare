import Joi from 'joi';

export const validateCreateProfile = (body: any) => {
  const schema = Joi.object({
    firstName: Joi.string().trim().min(2).max(50).required(),
    lastName: Joi.string().trim().min(2).max(50).required(),
    middleName: Joi.string().trim().min(2).max(50).required(),
    birthdate: Joi.date().iso().required(),
    address: Joi.object({
      present: Joi.string().trim().min(5).max(255).required(),
      permanent: Joi.string().trim().min(5).max(255).optional().allow(null),
    }).required(),
    contact: Joi.object({
      email: Joi.string().trim().email().required(),
      number: Joi.string()
        .trim()
        .pattern(/^09\d{9}$/) // Pattern for a valid Philippine mobile number starting with '09'
        .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
        .required(),
    }).required(),
    gender: Joi.string().valid('male', 'female', 'other').required(),
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
