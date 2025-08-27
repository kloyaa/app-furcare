"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateChangePassword = exports.validateRegister = exports.validateLogin = void 0;
const joi_1 = __importDefault(require("joi"));
const patterns_const_1 = require("../const/patterns.const");
const validateLogin = (body) => {
    const { error } = joi_1.default.object({
        username: joi_1.default.string().required(),
        password: joi_1.default.string().required(),
    }).validate(body);
    return error;
};
exports.validateLogin = validateLogin;
const validateRegister = (body) => {
    const { error } = joi_1.default.object({
        username: joi_1.default.string().required(),
        email: joi_1.default.string().email().required(),
        password: joi_1.default.string()
            .required()
            .required()
            .min(6)
            .max(255)
            .pattern(new RegExp(/^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/))
            .messages({
            'string.pattern.base': 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
        }),
    }).validate(body);
    return error;
};
exports.validateRegister = validateRegister;
const validateChangePassword = (body) => {
    const { error } = joi_1.default.object({
        newPassword: joi_1.default.string().required().min(6).max(255).pattern(patterns_const_1.passwordRegexp).messages({
            'string.pattern.base': 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character.',
        }),
        currentPassword: joi_1.default.string().required(),
    }).validate(body);
    return error;
};
exports.validateChangePassword = validateChangePassword;
