"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateUpdateProfile = exports.validateCreateProfile = void 0;
const joi_1 = __importDefault(require("joi"));
const validateCreateProfile = (body) => {
    const schema = joi_1.default.object({
        fullName: joi_1.default.string().trim().min(2).max(100).required(),
        address: joi_1.default.string().trim().min(5).max(255).required(),
        contact: joi_1.default.object({
            facebookDisplayName: joi_1.default.string().optional().allow(''),
            phoneNumber: joi_1.default.string()
                .trim()
                .pattern(/^09\d{9}$/) // Philippine mobile format
                .messages({ 'string.pattern.base': 'Invalid Mobile No. format' })
                .required(),
        }).required(),
        isActive: joi_1.default.boolean().optional(), // optional since defaults in schema
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreateProfile = validateCreateProfile;
const validateUpdateProfile = (body) => {
    const allowedKeys = [
        'firstName',
        'lastName',
        'birthdate',
        'address',
        'contact',
        'gender',
    ];
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
