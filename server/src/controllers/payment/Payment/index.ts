import { isObjectIdOrHexString, isValidObjectId, model, Types } from "mongoose";
import { statuses } from "../../../_core/const/api.statuses";
import { EventName, ActivityType } from "../../../_core/enum/activity.enum";
import { emitter } from "../../../_core/events/activity.event";
import { IActivity } from "../../../_core/interfaces/activity.interface";
import { TRequest, TResponse } from "../../../_core/interfaces/overrides.interface";
import { handleMongooseError } from "../../../_core/utils/db/error.util";
import { validateCreatePayment, validateProcessPayment, validateUpdatePaymentStatus } from "../../../_core/validators/Payment.validator";
import { GroomingApplication, BoardingApplication, HomeServiceApplication } from "../../../schema/application";
import { Payment } from "../../../schema/payment.schema";

export const createPayment = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    const error = validateCreatePayment(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }

    try {
        const {
            application: applicationId,
            applicationModel,
            amount,
            paymentMethod,
            paymentType,
            notes
        } = req.body;

        // Get the correct model
        const models = {
            GroomingApplication,
            BoardingApplication,
            HomeServiceApplication,
        };

        const ApplicationModel = models[applicationModel];
        if (!ApplicationModel) {
            return res.status(400).json({
                ...statuses['501'],
                message: 'Invalid application model.',
            });
        }

        // Find application
        const application = await ApplicationModel.findById(applicationId);
        if (!application) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Application not found.',
            });
        }

        // Create payment
        const payment = await Payment.create({
            application: applicationId,
            applicationModel,
            user: application.user,
            amount,
            paymentMethod,
            paymentType: paymentType || 'full_payment',
            notes,
            paymentStatus: 'pending'
        });

        emitter.emit(EventName.ACTIVITY, {
            user: req.user.id as any,
            description: ActivityType.PAYMENT_CREATED,
        } as IActivity);

        return res.status(201).json({
            ...statuses['00'],
            data: payment
        });
    } catch (err) {
        console.log('@createPayment error', err);
        return handleMongooseError(err, res);
    }
};

export const getPaymentById = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        if (!isObjectIdOrHexString(req.params.payment)) {
            return res.status(400).json({
                ...statuses['0901'],
                message: `${req.params.application} value is not a valid ObjectId`,
            });
        }

        const { payment: paymentId } = req.params;

        const payment = await Payment.findById(paymentId)
            .populate('user', 'name email')
            .populate('application', 'totalPrice status');

        if (!payment) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Payment not found.',
            });
        }

        return res.status(200).json(payment);
    } catch (err) {
        console.log('@getPaymentById error', err);
        return handleMongooseError(err, res);
    }
};

export const getPaymentsByApplication = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        const { application } = req.params;
        const { status, page = 1, limit = 50 } = req.query;

        const filter: any = { application };
        if (status) filter.paymentStatus = status;

        const skip = (Number(page) - 1) * Number(limit);

        const [payments, total] = await Promise.all([
            Payment.find(filter)
                .populate('user', 'name email')
                .sort({ createdAt: -1 })
                .limit(Number(limit))
                .skip(skip),
            Payment.countDocuments(filter)
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
    } catch (err) {
        console.log('@getPaymentsByApplication error', err);
        return handleMongooseError(err, res);
    }
};

export const getPaymentsByUser = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        const { userId } = req.params;
        const { status, paymentMethod, page = 1, limit = 50 } = req.query;

        const filter: any = { user: userId };
        if (status) filter.paymentStatus = status;
        if (paymentMethod) filter.paymentMethod = paymentMethod;

        const skip = (Number(page) - 1) * Number(limit);

        const [payments, total] = await Promise.all([
            Payment.find(filter)
                .populate('user', 'name email')
                .populate('application', 'totalPrice status')
                .sort({ createdAt: -1 })
                .limit(Number(limit))
                .skip(skip),
            Payment.countDocuments(filter)
        ]);

        return res.status(200).json({
            ...statuses['00'],
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
    } catch (err) {
        console.log('@getPaymentsByUser error', err);
        return handleMongooseError(err, res);
    }
};

export const updatePaymentStatus = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    const error = validateUpdatePaymentStatus(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }

    try {
        const { id } = req.params;
        const { status, transactionId, gatewayResponse, notes } = req.body;

        const payment = await Payment.findById(id);
        if (!payment) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Payment not found.',
            });
        }

        // Update payment
        payment.paymentStatus = status;
        if (transactionId) payment.transactionId = transactionId;
        if (gatewayResponse) payment.paymentGatewayResponse = gatewayResponse;
        if (notes) payment.notes = notes;

        await payment.save();

        if (status === 'completed' && payment.applicationModel) {
            const ApplicationModel = model(payment.applicationModel); // dynamically get the model
            const application = await ApplicationModel.findById(payment.application);

            if (application) {
                application.paidAmount += payment.amount;
                await application.save();
            }
        }
        emitter.emit(EventName.ACTIVITY, {
            user: req.user.id as any,
            description: ActivityType.PAYMENT_STATUS_UPDATED,
        } as IActivity);

        return res.status(200).json({
            ...statuses['00'],
            data: payment
        });
    } catch (err) {
        console.log('@updatePaymentStatus error', err);
        return handleMongooseError(err, res);
    }
};

export const processPayment = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    const error = validateProcessPayment(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        if (!isObjectIdOrHexString(req.params.application)) {
            return res.status(400).json({
                ...statuses['0901'],
                message: `${req.params.application} value is not a valid ObjectId`,
            });
        }

        const { application } = req.params;
        const { gatewayData } = req.body;

        const payment = await Payment.findById(application);
        if (!payment) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Payment not found.',
            });
        }

        if (payment.paymentStatus !== 'pending') {
            return res.status(400).json({
                ...statuses['501'],
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
                const ApplicationModel = model(payment.applicationModel);
                const application = await ApplicationModel.findById(payment.application);

                if (application) {
                    application.paidAmount += payment.amount;
                    await application.save();
                }
            }
        } else {
            payment.paymentStatus = 'failed';
            payment.notes = 'Payment processing failed';
        }

        await payment.save();

        emitter.emit(EventName.ACTIVITY, {
            user: req.user.id as any,
            description: isSuccess ? ActivityType.PAYMENT_COMPLETED : ActivityType.PAYMENT_FAILED,
        } as IActivity);

        const message = isSuccess ? 'Payment processed successfully' : 'Payment processing failed';

        return res.status(200).json({
            ...statuses['00'],
            message,
            data: payment
        });
    } catch (err) {
        console.log('@processPayment error', err);
        return handleMongooseError(err, res);
    }
};

export const refundPayment = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        const { id } = req.params;
        const { refundAmount, reason } = req.body;

        const payment = await Payment.findById(id);
        if (!payment) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Payment not found.',
            });
        }

        if (payment.paymentStatus !== 'completed') {
            return res.status(400).json({
                ...statuses['501'],
                message: 'Only completed payments can be refunded.',
            });
        }

        const refundAmountNum = refundAmount || payment.amount;

        if (refundAmountNum > payment.amount) {
            return res.status(400).json({
                ...statuses['501'],
                message: 'Refund amount cannot exceed payment amount.',
            });
        }

        // Create refund payment record
        const refundPayment = await Payment.create({
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
            const application = await HomeServiceApplication.findById(payment.application);
            if (application) {
                application.paidAmount = Math.max(0, application.paidAmount - refundAmountNum);
                await application.save();
            }
        }

        emitter.emit(EventName.ACTIVITY, {
            user: req.user.id as any,
            description: ActivityType.PAYMENT_REFUNDED,
        } as IActivity);

        return res.status(200).json({
            ...statuses['00'],
            message: 'Refund processed successfully',
            data: refundPayment
        });
    } catch (err) {
        console.log('@refundPayment error', err);
        return handleMongooseError(err, res);
    }
};

export const getPaymentStatistics = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        const { startDate, endDate } = req.query;

        const matchFilter: any = {};

        if (startDate || endDate) {
            matchFilter.createdAt = {};
            if (startDate) matchFilter.createdAt.$gte = new Date(startDate as string);
            if (endDate) matchFilter.createdAt.$lte = new Date(endDate as string);
        }

        const statistics = await Payment.aggregate([
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
    } catch (err) {
        console.log('@getPaymentStatistics error', err);
        return handleMongooseError(err, res);
    }
};