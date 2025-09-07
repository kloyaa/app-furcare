"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GroomingApplication = void 0;
const mongoose_1 = require("mongoose");
const BaseApplicationSchema_1 = require("../base/BaseApplicationSchema");
const payment_mixin_1 = require("../../mixins/payment-mixin");
const groomingApplicationSchema = new mongoose_1.Schema({
    ...BaseApplicationSchema_1.baseApplicationFields,
    scheduleCode: {
        type: String,
        required: [true, 'Schedule code is required'],
        index: true,
    },
    groomingOptions: {
        type: [String],
        required: [true, 'At least one grooming option is required'],
        validate: {
            validator: (arr) => arr && arr.length > 0,
            message: 'At least one grooming option must be selected',
        },
    },
    groomingPreferences: {
        type: [String],
        default: [],
    },
    hasAllergy: {
        type: Boolean,
        required: true,
        default: false,
    },
    isOnMedication: {
        type: Boolean,
        required: true,
        default: false,
    },
    hasAntiRabbiesVaccination: {
        type: Boolean,
        required: true,
        default: false,
    },
    ...payment_mixin_1.paymentFields,
}, BaseApplicationSchema_1.baseSchemaOptions);
// Add payment functionality
(0, payment_mixin_1.addPaymentVirtuals)(groomingApplicationSchema);
(0, payment_mixin_1.addPaymentMethods)(groomingApplicationSchema);
// Add indexes
groomingApplicationSchema.index({ user: 1, status: 1 });
groomingApplicationSchema.index({ branch: 1, createdAt: -1 });
groomingApplicationSchema.index({ scheduleCode: 1 });
exports.GroomingApplication = (0, mongoose_1.model)('GroomingApplication', groomingApplicationSchema);
