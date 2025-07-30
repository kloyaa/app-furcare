import Joi from "joi";
import { isValidObjectId } from "mongoose";

export const validateUpdatePetCages = (body: any) => {
    const schema = Joi.object({
        id: Joi.string().trim().custom(isValidObjectId, 'ObjectId validation').required(),
        action: Joi.string().required().valid('add', 'remove'),
    });

    const { error } = schema.validate(body);
    return error;
};