"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPaymentStatistics = exports.refundPayment = exports.processPayment = exports.updatePaymentStatus = exports.getPaymentsByUser = exports.getPaymentsByApplication = exports.getPaymentById = exports.createPayment = void 0;
const mongoose_1 = require("mongoose");
const api_statuses_1 = require("../../_core/const/api.statuses");
const activity_enum_1 = require("../../_core/enum/activity.enum");
const activity_event_1 = require("../../_core/events/activity.event");
const error_util_1 = require("../../_core/utils/db/error.util");
const Payment_validator_1 = require("../../_core/validators/Payment.validator");
const application_1 = require("../../schema/application");
const payment_schema_1 = require("../../schema/payment.schema");
const createPayment = async (req, res) => {
    const error = (0, Payment_validator_1.validateCreatePayment)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { application: applicationId, applicationModel, amount, paymentMethod, paymentType, notes } = req.body;
        // Get the correct model
        const models = {
            GroomingApplication: application_1.GroomingApplication,
            BoardingApplication: application_1.BoardingApplication,
            HomeServiceApplication: application_1.HomeServiceApplication,
        };
        const ApplicationModel = models[applicationModel];
        if (!ApplicationModel) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'Invalid application model.',
            });
        }
        // Find application
        const application = await ApplicationModel.findById(applicationId);
        if (!application) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Application not found.',
            });
        }
        // Create payment
        const payment = await payment_schema_1.Payment.create({
            application: applicationId,
            applicationModel,
            user: application.user,
            amount,
            paymentMethod,
            paymentType: paymentType || 'full_payment',
            notes,
            paymentStatus: 'pending'
        });
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PAYMENT_CREATED,
        });
        return res.status(201).json({
            ...api_statuses_1.statuses['00'],
            data: payment
        });
    }
    catch (err) {
        console.log('@createPayment error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.createPayment = createPayment;
const getPaymentById = async (req, res) => {
    try {
        if (!(0, mongoose_1.isObjectIdOrHexString)(req.params.payment)) {
            return res.status(400).json({
                ...api_statuses_1.statuses['0901'],
                message: `${req.params.application} value is not a valid ObjectId`,
            });
        }
        const { payment: paymentId } = req.params;
        const payment = await payment_schema_1.Payment.findById(paymentId)
            .populate('user', 'name email')
            .populate('application', 'totalPrice status');
        if (!payment) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Payment not found.',
            });
        }
        return res.status(200).json(payment);
    }
    catch (err) {
        console.log('@getPaymentById error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.getPaymentById = getPaymentById;
const getPaymentsByApplication = async (req, res) => {
    try {
        const { application } = req.params;
        const { status, page = 1, limit = 50 } = req.query;
        const filter = { application };
        if (status)
            filter.paymentStatus = status;
        const skip = (Number(page) - 1) * Number(limit);
        const [payments, total] = await Promise.all([
            payment_schema_1.Payment.find(filter)
                .populate('user', 'name email')
                .sort({ createdAt: -1 })
                .limit(Number(limit))
                .skip(skip),
            payment_schema_1.Payment.countDocuments(filter)
        ]);
        return res.status(200).json({
            payments,
            pagination: {
                current: Number(page),
                total: Math.ceil(total / Number(limit)),
                count: payments.length,
                totalRecords: total,
            }
        });
    }
    catch (err) {
        console.log('@getPaymentsByApplication error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.getPaymentsByApplication = getPaymentsByApplication;
const getPaymentsByUser = async (req, res) => {
    try {
        const { userId } = req.params;
        const { status, paymentMethod, page = 1, limit = 50 } = req.query;
        const filter = { user: userId };
        if (status)
            filter.paymentStatus = status;
        if (paymentMethod)
            filter.paymentMethod = paymentMethod;
        const skip = (Number(page) - 1) * Number(limit);
        const [payments, total] = await Promise.all([
            payment_schema_1.Payment.find(filter)
                .populate('user', 'name email')
                .populate('application', 'totalPrice status')
                .sort({ createdAt: -1 })
                .limit(Number(limit))
                .skip(skip),
            payment_schema_1.Payment.countDocuments(filter)
        ]);
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            data: {
                payments,
                pagination: {
                    current: Number(page),
                    total: Math.ceil(total / Number(limit)),
                    count: payments.length,
                    totalRecords: total,
                }
            }
        });
    }
    catch (err) {
        console.log('@getPaymentsByUser error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.getPaymentsByUser = getPaymentsByUser;
const updatePaymentStatus = async (req, res) => {
    const error = (0, Payment_validator_1.validateUpdatePaymentStatus)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { id } = req.params;
        const { status, transactionId, gatewayResponse, notes } = req.body;
        const payment = await payment_schema_1.Payment.findById(id);
        if (!payment) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Payment not found.',
            });
        }
        // Update payment
        payment.paymentStatus = status;
        if (transactionId)
            payment.transactionId = transactionId;
        if (gatewayResponse)
            payment.paymentGatewayResponse = gatewayResponse;
        if (notes)
            payment.notes = notes;
        await payment.save();
        if (status === 'completed' && payment.applicationModel) {
            const ApplicationModel = (0, mongoose_1.model)(payment.applicationModel); // dynamically get the model
            const application = await ApplicationModel.findById(payment.application);
            if (application) {
                application.paidAmount += payment.amount;
                await application.save();
            }
        }
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PAYMENT_STATUS_UPDATED,
        });
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            data: payment
        });
    }
    catch (err) {
        console.log('@updatePaymentStatus error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.updatePaymentStatus = updatePaymentStatus;
const processPayment = async (req, res) => {
    const error = (0, Payment_validator_1.validateProcessPayment)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        if (!(0, mongoose_1.isObjectIdOrHexString)(req.params.application)) {
            return res.status(400).json({
                ...api_statuses_1.statuses['0901'],
                message: `${req.params.application} value is not a valid ObjectId`,
            });
        }
        const { application } = req.params;
        const { gatewayData } = req.body;
        const payment = await payment_schema_1.Payment.findById(application);
        if (!payment) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Payment not found.',
            });
        }
        if (payment.paymentStatus !== 'pending') {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'Only pending payments can be processed.',
            });
        }
        // Simulate payment processing
        const mockTransactionId = `TXN_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        // const isSuccess = Math.random() > 0.1; // 90% success rate
        const isSuccess = true;
        if (isSuccess) {
            payment.paymentStatus = 'completed';
            payment.transactionId = mockTransactionId;
            payment.paymentGatewayResponse = {
                gateway: payment.paymentMethod,
                processedAt: new Date(),
                ...gatewayData
            };
            if (payment.applicationModel) {
                const ApplicationModel = (0, mongoose_1.model)(payment.applicationModel);
                const application = await ApplicationModel.findById(payment.application);
                if (application) {
                    application.paidAmount += payment.amount;
                    await application.save();
                }
            }
        }
        else {
            payment.paymentStatus = 'failed';
            payment.notes = 'Payment processing failed';
        }
        await payment.save();
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: isSuccess ? activity_enum_1.ActivityType.PAYMENT_COMPLETED : activity_enum_1.ActivityType.PAYMENT_FAILED,
        });
        const message = isSuccess ? 'Payment processed successfully' : 'Payment processing failed';
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            message,
            data: payment
        });
    }
    catch (err) {
        console.log('@processPayment error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.processPayment = processPayment;
const refundPayment = async (req, res) => {
    try {
        const { id } = req.params;
        const { refundAmount, reason } = req.body;
        const payment = await payment_schema_1.Payment.findById(id);
        if (!payment) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Payment not found.',
            });
        }
        if (payment.paymentStatus !== 'completed') {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'Only completed payments can be refunded.',
            });
        }
        const refundAmountNum = refundAmount || payment.amount;
        if (refundAmountNum > payment.amount) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'Refund amount cannot exceed payment amount.',
            });
        }
        // Create refund payment record
        const refundPayment = await payment_schema_1.Payment.create({
            application: payment.application,
            applicationModel: payment.applicationModel,
            user: payment.user,
            amount: -refundAmountNum, // Negative for refund
            paymentMethod: payment.paymentMethod,
            paymentType: 'refund',
            paymentStatus: 'completed',
            notes: reason || 'Payment refund',
            transactionId: `REFUND_${payment.transactionId}_${Date.now()}`
        });
        // Update original payment if full refund
        if (refundAmountNum === payment.amount) {
            payment.paymentStatus = 'refunded';
            payment.notes = `Refunded: ${reason || 'Full refund processed'}`;
            await payment.save();
        }
        // Update application payment amount if HomeService
        if (payment.applicationModel === 'HomeServiceApplication') {
            const application = await application_1.HomeServiceApplication.findById(payment.application);
            if (application) {
                application.paidAmount = Math.max(0, application.paidAmount - refundAmountNum);
                await application.save();
            }
        }
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PAYMENT_REFUNDED,
        });
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            message: 'Refund processed successfully',
            data: refundPayment
        });
    }
    catch (err) {
        console.log('@refundPayment error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.refundPayment = refundPayment;
const getPaymentStatistics = async (req, res) => {
    try {
        const { startDate, endDate } = req.query;
        const matchFilter = {};
        if (startDate || endDate) {
            matchFilter.createdAt = {};
            if (startDate)
                matchFilter.createdAt.$gte = new Date(startDate);
            if (endDate)
                matchFilter.createdAt.$lte = new Date(endDate);
        }
        const statistics = await payment_schema_1.Payment.aggregate([
            { $match: matchFilter },
            {
                $group: {
                    _id: { status: '$paymentStatus', method: '$paymentMethod' },
                    count: { $sum: 1 },
                    totalAmount: { $sum: '$amount' }
                }
            }
        ]);
        return res.status(200).json(statistics);
    }
    catch (err) {
        console.log('@getPaymentStatistics error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.getPaymentStatistics = getPaymentStatistics;
