import { Schema } from 'mongoose';
import { ApplicationStatusEnum } from '../../_core/enum/application.enum';

export const baseApplicationFields = {
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        index: true,
    },
    pet: {
        type: Schema.Types.ObjectId,
        ref: 'Pet',
        required: true,
        index: true,
    },
    branch: {
        type: Schema.Types.ObjectId,
        ref: 'Branch',
        required: true,
        index: true,
    },
    totalPrice: {
        type: Number,
        required: true,
        min: 0,
    },
    status: {
        type: String,
        required: true,
        enum: {
            values: Object.values(ApplicationStatusEnum),
            message: 'Invalid status value'
        },
        default: ApplicationStatusEnum.PENDING,
        index: true,
    },
};

// Base schema options
export const baseSchemaOptions = {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
};