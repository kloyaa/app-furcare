import Joi from 'joi';
import { isValidObjectId } from 'mongoose';
import { groomingOptionsEnum, groomingPreferencesEnum, groomingScheduleEnum } from '../enum/application.enum';

export const validateCreateGroomingApplication = (body: any) => {
    const schema = Joi.object({
        pet: Joi.string().trim().required().custom(isValidObjectId, 'ObjectId validation'),
        branch: Joi.string().trim().required().custom(isValidObjectId, 'ObjectId validation'),
        scheduleCode: Joi.string().trim().required().valid(...groomingScheduleEnum),
        groomingOptions: Joi.array()
            .items(Joi.string().valid(...groomingOptionsEnum)
            )
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
