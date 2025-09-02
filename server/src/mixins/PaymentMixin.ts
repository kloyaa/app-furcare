// mixins/PaymentMixin.ts
import { Schema } from 'mongoose';
import { Payment } from '../schema/payment.schema';

export const paymentFields = {
    paidAmount: {
        type: Number,
        default: 0,
        min: 0,
    },
    paymentStatus: {
        type: String,
        required: true,
        enum: {
            values: ['unpaid', 'partially_paid', 'fully_paid', 'overpaid'],
            message: 'Invalid payment status'
        },
        default: 'unpaid',
        index: true,
    },
};

// Add computed field for remaining balance
export const addPaymentVirtuals = (schema: Schema) => {
    schema.virtual('remainingBalance').get(function (this: any) {
        return Math.max(0, this.totalPrice - this.paidAmount);
    });
};

export const addPaymentMethods = (schema: Schema) => {
    // Instance method to update payment status
    schema.methods.updatePaymentStatus = function (this: any) {
        const { paidAmount, totalPrice } = this;

        if (paidAmount <= 0) {
            this.paymentStatus = 'unpaid';
        } else if (paidAmount < totalPrice) {
            this.paymentStatus = 'partially_paid';
        } else if (paidAmount === totalPrice) {
            this.paymentStatus = 'fully_paid';
        } else {
            this.paymentStatus = 'overpaid';
        }
    };

    // Instance method to get total paid amount from Payment collection
    schema.methods.getTotalPaidAmount = async function (this: any) {
        try {
            const payments = await Payment.find({
                application: this._id,
                paymentStatus: 'completed'
            }).select('amount');

            return payments.reduce((sum, payment) => sum + payment.amount, 0);
        } catch (error) {
            console.error('Error fetching paid amount:', error);
            return 0;
        }
    };

    // Pre-save hook to auto-update payment status when paidAmount changes
    schema.pre('save', function (this: any, next) {
        if (this.isModified('paidAmount') || this.isModified('totalPrice')) {
            this.updatePaymentStatus();
        }
        next();
    });
};