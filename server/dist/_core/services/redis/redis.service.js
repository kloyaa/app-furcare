"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getLocalStorage = exports.setLocalStorage = void 0;
const redis_client_service_1 = __importDefault(require("./redis-client.service"));
const setLocalStorage = async (payload) => {
    const { key, value } = payload;
    try {
        await redis_client_service_1.default.set(key, JSON.stringify(value)); // Store value as JSON string
        return {
            success: true,
            message: `Value for ${key} set successfully.`,
        };
    }
    catch (err) {
        return {
            success: false,
            message: 'Error setting value in Redis',
        };
    }
};
exports.setLocalStorage = setLocalStorage;
const getLocalStorage = async (payload) => {
    const { key } = payload;
    try {
        const value = await redis_client_service_1.default.get(key);
        if (value !== null) {
            return {
                success: true,
                message: `Value for ${key} retrieved successfully.`,
                data: JSON.parse(value), // Parse JSON string to desired type
            };
        }
        else {
            return {
                success: false,
                message: `No value found for ${key}`,
            };
        }
    }
    catch (err) {
        return {
            success: false,
            message: 'Error retrieving value from Redis',
        };
    }
};
exports.getLocalStorage = getLocalStorage;
