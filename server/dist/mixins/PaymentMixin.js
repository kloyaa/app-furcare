"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addPaymentMethods = exports.addPaymentVirtuals = exports.paymentFields = void 0;
const payment_schema_1 = require("../schema/payment.schema");
exports.paymentFields = {
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
const addPaymentVirtuals = (schema) => {
    schema.virtual('remainingBalance').get(function () {
        return Math.max(0, this.totalPrice - this.paidAmount);
    });
};
exports.addPaymentVirtuals = addPaymentVirtuals;
const addPaymentMethods = (schema) => {
    // Instance method to update payment status
    schema.methods.updatePaymentStatus = function () {
        const { paidAmount, totalPrice } = this;
        if (paidAmount <= 0) {
            this.paymentStatus = 'unpaid';
        }
        else if (paidAmount < totalPrice) {
            this.paymentStatus = 'partially_paid';
        }
        else if (paidAmount === totalPrice) {
            this.paymentStatus = 'fully_paid';
        }
        else {
            this.paymentStatus = 'overpaid';
        }
    };
    // Instance method to get total paid amount from Payment collection
    schema.methods.getTotalPaidAmount = async function () {
        try {
            const payments = await payment_schema_1.Payment.find({
                application: this._id,
                paymentStatus: 'completed'
            }).select('amount');
            return payments.reduce((sum, payment) => sum + payment.amount, 0);
        }
        catch (error) {
            console.error('Error fetching paid amount:', error);
            return 0;
        }
    };
    // Pre-save hook to auto-update payment status when paidAmount changes
    schema.pre('save', function (next) {
        if (this.isModified('paidAmount') || this.isModified('totalPrice')) {
            this.updatePaymentStatus();
        }
        next();
    });
};
exports.addPaymentMethods = addPaymentMethods;
