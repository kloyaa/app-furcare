import { Schema, model, Types } from 'mongoose';

const paymentUploadSchema = new Schema(
    {
        application: {
            type: Schema.Types.ObjectId,
            required: true,
            index: true,
        },
        applicationModel: {
            type: String,
            required: true,
            enum: [
                'GroomingApplication',
                'BoardingApplication',
                'HomeServiceApplication',
            ],
            default: 'GroomingApplication',
        },
        url: {
            type: String,
            required: true,
        },
    },
    { timestamps: true }
);
paymentUploadSchema.index({ application: 1, applicationModel: 1 });
paymentUploadSchema.index({ createdAt: -1 });

export const PaymentUpload = model('PaymentUpload', paymentUploadSchema);