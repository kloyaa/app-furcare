import { model, Schema } from "mongoose";
import { IPayment } from "../_core/interfaces/schema/schema.interface";

const paymentSchema = new Schema<IPayment>(
    {
        application: {
            type: Schema.Types.ObjectId,
            required: true,
            index: true,
        },
        applicationModel: {
            type: String,
            required: true,
            enum: ['GroomingApplication', 'BoardingApplication', 'HomeServiceApplication'],
            default: 'GroomingApplication'
        },
        user: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            required: true,
            index: true,
        },
        amount: {
            type: Number,
            required: true,
            min: 0,
        },
        paymentMethod: {
            type: String,
            required: true,
            enum: ['credit_card', 'debit_card', 'cash', 'gcash', 'paymaya', 'bank_transfer'],
            index: true,
        },
        paymentStatus: {
            type: String,
            required: true,
            enum: ['pending', 'completed', 'failed', 'refunded', 'cancelled'],
            default: 'pending',
            index: true,
        },
        transactionId: {
            type: String,
            unique: true,
            sparse: true, // Allows multiple null values
            index: true,
        },
        paymentGatewayResponse: {
            type: Schema.Types.Mixed,
            default: null,
        },
        paymentType: {
            type: String,
            required: true,
            enum: ['full_payment', 'partial_payment', 'deposit', 'refund'],
            default: 'full_payment',
        },
        notes: {
            type: String,
            default: '',
            maxlength: 500,
        },
    },
    { timestamps: true }
);

// Compound indexes for better query performance
paymentSchema.index({ user: 1, paymentStatus: 1 });
paymentSchema.index({ application: 1, paymentStatus: 1 });
paymentSchema.index({ createdAt: -1 });

export const Payment = model<IPayment>('Payment', paymentSchema);