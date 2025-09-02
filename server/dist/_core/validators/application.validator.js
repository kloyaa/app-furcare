"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateCreateHomeServiceApplication = exports.validateCreateBoardingApplicationExtension = exports.validateCreateBoardingApplication = exports.validateCreateGroomingApplication = void 0;
const joi_1 = __importDefault(require("joi"));
const application_enum_1 = require("../enum/application.enum");
const joi_utils_1 = require("../utils/joi/joi.utils");
const pet_srvices_const_1 = require("../const/pet_srvices.const");
const validateCreateGroomingApplication = (body) => {
    const schema = joi_1.default.object({
        pet: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        branch: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        scheduleCode: joi_1.default.string()
            .trim()
            .required()
            .valid(...application_enum_1.groomingScheduleEnum),
        groomingOptions: joi_1.default.array()
            .items(joi_1.default.string().valid(...application_enum_1.groomingOptionsEnum))
            .required(),
        groomingPreferences: joi_1.default.array()
            .items(joi_1.default.string().valid(...application_enum_1.groomingPreferencesEnum))
            .required(),
        hasAllergy: joi_1.default.boolean().required(),
        isOnMedication: joi_1.default.boolean().required(),
        hasAntiRabbiesVaccination: joi_1.default.boolean().required(),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateGroomingApplication = validateCreateGroomingApplication;
const validateCreateBoardingApplication = (body) => {
    const schema = joi_1.default.object({
        pet: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        cage: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        branch: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        schedule: joi_1.default.object({
            date: joi_1.default.date().required(),
            time: joi_1.default.string()
                .required()
                .valid(...pet_srvices_const_1.boardingHours),
            days: joi_1.default.number().required(),
        }).required(),
        instructions: joi_1.default.string().trim().required(),
        requestAntiRabiesVaccination: joi_1.default.boolean().required(),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateBoardingApplication = validateCreateBoardingApplication;
const validateCreateBoardingApplicationExtension = (body) => {
    const schema = joi_1.default.object({
        application: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        type: joi_1.default
            .string()
            .required()
            .valid('add', 'minus', 'set'),
        count: joi_1.default
            .number()
            .required()
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateBoardingApplicationExtension = validateCreateBoardingApplicationExtension;
const validateCreateHomeServiceApplication = (body) => {
    const schema = joi_1.default.object({
        pet: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        branch: joi_1.default.string()
            .trim()
            .required()
            .custom(joi_utils_1.CustomJoiHelpers.isValidObjectId, 'ObjectId validation'),
        schedule: joi_1.default.object({
            date: joi_1.default.date().required(),
            time: joi_1.default.string().required(),
        }).required(),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateHomeServiceApplication = validateCreateHomeServiceApplication;
