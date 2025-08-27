"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GroomingApplication = exports.BoardingApplication = exports.HomeServiceApplication = void 0;
const mongoose_1 = require("mongoose");
const application_enum_1 = require("../_core/enum/application.enum");
const groomingApplicationSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    pet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Pet',
        required: true,
    },
    branch: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Branch',
        required: true,
    },
    scheduleCode: {
        type: String,
        required: true,
    },
    groomingOptions: {
        type: [String],
        required: true,
    },
    groomingPreferences: {
        type: [String],
        required: true,
    },
    hasAllergy: {
        type: Boolean,
        required: true,
    },
    isOnMedication: {
        type: Boolean,
        required: true,
    },
    hasAntiRabbiesVaccination: {
        type: Boolean,
        required: true,
    },
    totalPrice: {
        type: Number,
        required: true,
    },
    status: {
        type: String,
        required: true,
        enum: Object.values(application_enum_1.ApplicationStatusEnum),
        default: 'pending',
    }
}, { timestamps: true });
const boardingApplicationSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    pet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Pet',
        required: true,
    },
    cage: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'PetCage',
        required: true,
    },
    branch: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Branch',
        required: true,
    },
    schedule: {
        date: {
            type: Date,
            required: true,
        },
        time: {
            type: String,
            required: true,
        },
        days: {
            type: Number,
            required: true,
        },
    },
    instructions: {
        type: String,
        required: true,
    },
    totalPrice: {
        type: Number,
        required: true,
    },
    requestAntiRabiesVaccination: {
        type: Boolean,
        required: true,
    },
    status: {
        type: String,
        required: true,
        enum: Object.values(application_enum_1.ApplicationStatusEnum),
        default: 'pending',
    }
}, { timestamps: true });
const homeServiceApplicationSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    pet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Pet',
        required: true,
    },
    branch: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Branch',
        required: true,
    },
    schedule: {
        date: {
            type: Date,
            required: true,
        },
        time: {
            type: String,
            required: true,
        },
    },
    totalPrice: {
        type: Number,
        default: 390,
    },
    status: {
        type: String,
        required: true,
        enum: Object.values(application_enum_1.ApplicationStatusEnum),
        default: 'pending',
    }
}, { timestamps: true });
const HomeServiceApplication = (0, mongoose_1.model)('HomeServiceApplication', homeServiceApplicationSchema);
exports.HomeServiceApplication = HomeServiceApplication;
const BoardingApplication = (0, mongoose_1.model)('BoardingApplication', boardingApplicationSchema);
exports.BoardingApplication = BoardingApplication;
const GroomingApplication = (0, mongoose_1.model)('GroomingApplication', groomingApplicationSchema);
exports.GroomingApplication = GroomingApplication;
