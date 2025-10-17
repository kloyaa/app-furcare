import Joi from 'joi';
import { CustomJoiHelpers } from '../utils/joi/joi.utils';
import { applicationModelEnum } from '../const/application.const';

export const uploadPaymentValidator = (body: any) => {
    const schema = Joi.object({
        application: Joi.string()
            .custom(CustomJoiHelpers.isValidObjectId, 'ObjectId validation')
            .required(),
        applicationModel: Joi.string()
            .trim()
            .required()
            .valid(...applicationModelEnum),
    });

    const { error } = schema.validate(body);
    return error;
};