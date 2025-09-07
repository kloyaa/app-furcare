"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.HomeServiceApplication = void 0;
const mongoose_1 = require("mongoose");
const payment_mixin_1 = require("../../mixins/payment-mixin");
const BaseApplicationSchema_1 = require("../base/BaseApplicationSchema");
const homeServiceApplicationSchema = new mongoose_1.Schema({
    ...BaseApplicationSchema_1.baseApplicationFields,
    schedule: {
        date: {
            type: Date,
            required: [, 'Service date is required'],
            index: true,
            validate: {
                validator: (date) => date > new Date(),
                message: 'Service date must be in the future',
            },
        },
        time: {
            type: String,
            required: [true, 'Service time is required'],
            validate: {
                validator: (time) => /^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$/i.test(time),
                message: 'Invalid time format (HH:MM expected)',
            },
        },
    },
    totalPrice: {
        type: Number,
        default: 390,
        min: 0,
        validate: {
            validator: (value) => value >= 0,
            message: 'Price cannot be negative',
        },
    },
    ...payment_mixin_1.paymentFields,
}, BaseApplicationSchema_1.baseSchemaOptions);
// Add payment functionality
(0, payment_mixin_1.addPaymentVirtuals)(homeServiceApplicationSchema);
(0, payment_mixin_1.addPaymentMethods)(homeServiceApplicationSchema);
// Indexes
homeServiceApplicationSchema.index({ user: 1, paymentStatus: 1 });
homeServiceApplicationSchema.index({ branch: 1, 'schedule.date': 1 });
exports.HomeServiceApplication = (0, mongoose_1.model)('HomeServiceApplication', homeServiceApplicationSchema);
