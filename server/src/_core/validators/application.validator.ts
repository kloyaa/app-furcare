import Joi from 'joi';
import { groomingOptionsEnum, groomingPreferencesEnum, groomingScheduleEnum } from '../enum/application.enum';
import { CustomJoiHelpers } from '../utils/joi/joi.utils';
import { boardingHours } from '../const/pet_srvices.const';

export const validateCreateGroomingApplication = (body: any) => {
  const schema = Joi.object({
    pet: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    branch: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    scheduleCode: Joi.string()
      .trim()
      .required()
      .valid(...groomingScheduleEnum),
    groomingOptions: Joi.array()
      .items(Joi.string().valid(...groomingOptionsEnum))
      .required(),
    groomingPreferences: Joi.array()
      .items(Joi.string().valid(...groomingPreferencesEnum))
      .required(),
    hasAllergy: Joi.boolean().required(),
    isOnMedication: Joi.boolean().required(),
    hasAntiRabbiesVaccination: Joi.boolean().required(),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateCreateBoardingApplication = (body: any) => {
  const schema = Joi.object({
    pet: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    cage: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    branch: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    schedule: Joi.object({
      date: Joi.date().required(),
      time: Joi.string()
        .required()
        .valid(...boardingHours),
      days: Joi.number().required(),
    }).required(),
    instructions: Joi.string().trim().required(),
    requestAntiRabiesVaccination: Joi.boolean().required(),
  });

  const { error } = schema.validate(body);
  return error;
};

export const validateCreateHomeServiceApplication = (body: any) => {
  const schema = Joi.object({
    pet: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    branch: Joi.string().trim().required().custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
    schedule: Joi.object({
      date: Joi.date().required(),
      time: Joi.string().required(),
    }).required(),
  });

  const { error } = schema.validate(body);
  return error;
};
