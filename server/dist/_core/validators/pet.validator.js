"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateCreatePet = void 0;
const joi_1 = __importDefault(require("joi"));
const validateCreatePet = (body) => {
    const schema = joi_1.default.object({
        name: joi_1.default.string().trim().min(1).max(100).required(),
        specie: joi_1.default.string().trim().min(1).max(100).required(),
        gender: joi_1.default.string().trim().valid('Male', 'Female', 'Other').required(),
        // Optional: add timestamps if you ever allow manual entry (not needed if auto-generated)
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateCreatePet = validateCreatePet;
