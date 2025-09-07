"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getApplicationPayments = void 0;
const error_util_1 = require("../../_core/utils/db/error.util");
const payment_schema_1 = require("../../schema/payment.schema");
const getApplicationPayments = async (req, res) => {
    try {
        const payments = await payment_schema_1.Payment.find()
            .populate('user', 'username email')
            .sort({ createdAt: -1 })
            .lean();
        const formattedPayments = payments.map((payment) => ({
            _id: payment._id,
            applicationId: payment.application,
            applicationModel: payment.applicationModel,
            user: {
                _id: payment.user?._id || null,
                username: payment.user?.username || 'N/A',
                email: payment.user?.email || 'N/A'
            },
            amount: payment.amount,
            paymentMethod: payment.paymentMethod,
            paymentStatus: payment.paymentStatus,
            paymentType: payment.paymentType,
            transactionId: payment.transactionId || null,
            notes: payment.notes || '',
            createdAt: payment.createdAt,
            updatedAt: payment.updatedAt
        }));
        return res.status(200).json(formattedPayments);
    }
    catch (error) {
        console.log('@getApplicationPayments error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getApplicationPayments = getApplicationPayments;
