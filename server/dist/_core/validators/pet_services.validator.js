"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateUpdatePetCages = void 0;
const joi_1 = __importDefault(require("joi"));
const mongoose_1 = require("mongoose");
const validateUpdatePetCages = (body) => {
    const schema = joi_1.default.object({
        id: joi_1.default.string()
            .trim()
            .custom(mongoose_1.isValidObjectId, 'ObjectId validation')
            .required(),
        action: joi_1.default.string().required().valid('add', 'remove'),
    });
    const { error } = schema.validate(body);
    return error;
};
exports.validateUpdatePetCages = validateUpdatePetCages;
