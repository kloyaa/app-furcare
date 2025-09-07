"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BoardingApplication = void 0;
const mongoose_1 = require("mongoose");
const BaseApplicationSchema_1 = require("../base/BaseApplicationSchema");
const payment_mixin_1 = require("../../mixins/payment-mixin");
const boardingApplicationSchema = new mongoose_1.Schema({
    ...BaseApplicationSchema_1.baseApplicationFields,
    cage: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'PetCage',
        required: [true, 'Cage selection is required'],
        index: true,
    },
    schedule: {
        date: {
            type: Date,
            required: [true, 'Schedule date is required'],
            index: true,
        },
        time: {
            type: String,
            required: [true, 'Schedule time is required'],
            validate: {
                validator: (time) => /^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$/i.test(time),
                message: 'Invalid time format (HH:MM expected)',
            },
        },
        days: {
            type: Number,
            required: [true, 'Number of days is required'],
            min: [1, 'Minimum 1 day required'],
            max: [365, 'Maximum 365 days allowed'],
        },
        originalDays: {
            type: Number,
            min: 1,
        },
    },
    instructions: {
        type: String,
        required: [true, 'Instructions are required'],
        maxlength: [1000, 'Instructions cannot exceed 1000 characters'],
        trim: true,
    },
    originalPrice: {
        type: Number,
        min: [0, 'Original price cannot be negative'],
    },
    requestAntiRabiesVaccination: {
        type: Boolean,
        required: true,
        default: false,
    },
    extensions: [{
            type: {
                type: String,
                enum: {
                    values: ['add', 'minus', 'set'],
                    message: 'Invalid extension type'
                },
                required: true,
            },
            days: {
                type: Number,
                required: true,
            },
            priceChange: {
                type: Number,
                required: true,
            },
            timestamp: {
                type: Date,
                default: Date.now,
            },
            user: {
                type: mongoose_1.Schema.Types.ObjectId,
                ref: 'User',
                required: true,
            },
        }],
    ...payment_mixin_1.paymentFields,
}, BaseApplicationSchema_1.baseSchemaOptions);
// Virtual fields
boardingApplicationSchema.virtual('extensionDays').get(function () {
    return this.schedule?.originalDays
        ? this.schedule.days - this.schedule.originalDays
        : 0;
});
boardingApplicationSchema.virtual('extensionPrice').get(function () {
    return this.originalPrice
        ? this.totalPrice - this.originalPrice
        : 0;
});
// Business logic method
boardingApplicationSchema.methods.addExtension = function (extensionData) {
    // Set original values on first extension
    if (!this.schedule.originalDays) {
        this.schedule.originalDays = this.schedule.days;
    }
    if (!this.originalPrice) {
        this.originalPrice = this.totalPrice;
    }
    // Apply extension logic
    switch (extensionData.type) {
        case 'add':
            this.schedule.days += extensionData.days;
            break;
        case 'minus':
            this.schedule.days = Math.max(1, this.schedule.days - extensionData.days);
            break;
        case 'set':
            this.schedule.days = Math.max(1, extensionData.days);
            break;
    }
    this.totalPrice += extensionData.priceChange;
    this.extensions.push({
        ...extensionData,
        timestamp: new Date(),
    });
};
// Add payment functionality
(0, payment_mixin_1.addPaymentVirtuals)(boardingApplicationSchema);
(0, payment_mixin_1.addPaymentMethods)(boardingApplicationSchema);
// Add indexes
boardingApplicationSchema.index({ user: 1, status: 1 });
boardingApplicationSchema.index({ branch: 1, 'schedule.date': 1 });
boardingApplicationSchema.index({ cage: 1, 'schedule.date': 1 });
exports.BoardingApplication = (0, mongoose_1.model)('BoardingApplication', boardingApplicationSchema);
