import Joi from 'joi';
import { passwordRegexp } from '../const/patterns.const';

export const validateLogin = (body: any) => {
  const { error } = Joi.object({
    username: Joi.string().required(),
    password: Joi.string().required(),
  }).validate(body);

  return error;
};

export const validateRegister = (body: any) => {
  const { error } = Joi.object({
    username: Joi.string().required(),
    email: Joi.string().email().required(),
    password: Joi.string()
      .required()
      .required()
      .min(6)
      .max(255)
      .pattern(new RegExp(/^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/))
      .messages({
        'string.pattern.base': 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
      }),
  }).validate(body);

  return error;
};

export const validateChangePassword = (body: any) => {
  const { error } = Joi.object({
    newPassword: Joi.string().required().min(6).max(255).pattern(passwordRegexp).messages({
      'string.pattern.base': 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
    }),
    currentPassword: Joi.string().required(),
  }).validate(body);

  return error;
};
