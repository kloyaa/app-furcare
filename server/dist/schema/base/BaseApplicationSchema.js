"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.baseSchemaOptions = exports.baseApplicationFields = void 0;
const mongoose_1 = require("mongoose");
const application_enum_1 = require("../../_core/enum/application.enum");
exports.baseApplicationFields = {
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        index: true,
    },
    pet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Pet',
        required: true,
        index: true,
    },
    branch: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Branch',
        required: true,
        index: true,
    },
    totalPrice: {
        type: Number,
        required: true,
        min: 0,
    },
    status: {
        type: String,
        required: true,
        enum: {
            values: Object.values(application_enum_1.ApplicationStatusEnum),
            message: 'Invalid status value'
        },
        default: application_enum_1.ApplicationStatusEnum.PENDING,
        index: true,
    },
};
// Base schema options
exports.baseSchemaOptions = {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
};
