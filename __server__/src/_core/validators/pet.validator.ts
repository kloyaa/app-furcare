import Joi from 'joi';
import mongoose from 'mongoose';

export const validateCreatePet = (body: any) => {
    const schema = Joi.object({
        name: Joi.string().trim().min(1).max(100).required(),
        specie: Joi.string().trim().min(1).max(100).required(),
        gender: Joi.string().trim().valid('Male', 'Female', 'Other').required(),

        // Optional: add timestamps if you ever allow manual entry (not needed if auto-generated)
    });

    const { error } = schema.validate(body);
    return error;
};
