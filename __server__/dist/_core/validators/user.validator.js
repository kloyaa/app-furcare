"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateUpdateProfile = exports.validateCreateProfile = void 0;
const joi_1 = __importDefault(require("joi"));
const validateCreateProfile = (body) => {
    const schema = joi_1.default.object({
        firstName: joi_1.default.string().trim().min(2).max(50).required(),
        lastName: joi_1.default.string().trim().min(2).max(50).required(),
        middleName: joi_1.default.string().trim().min(2).max(50).required(),
        birthdate: joi_1.default.date().iso().required(),
        address: joi_1.default.object({
            present: joi_1.default.string().trim().min(5).max(255).required(),
            permanent: joi_1.default.string().trim().min(5).max(255).optional().allow(null),
        }).required(),
        contact: joi_1.default.object({
            email: joi_1.default.string().trim().email().required(),
            number: joi_1.default.string()
                .trim()
                .pattern(/^09\d{9}$/) // Pattern for a valid Philippine mobile number starting with '09'
                .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
                .required(),
        }).required(),
        gender: joi_1.default.string().valid('male', 'female', 'other').required(),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateProfile = validateCreateProfile;
const validateUpdateProfile = (body) => {
    const allowedKeys = ['firstName', 'lastName', 'birthdate', 'address', 'contact', 'gender'];
    const schema = joi_1.default.object({
        keys: joi_1.default.array()
            .items(joi_1.default.string().valid(...allowedKeys))
            .required(),
        values: joi_1.default.array().required(),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateUpdateProfile = validateUpdateProfile;
