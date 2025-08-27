"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.closeDB = exports.connectDB = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const env_config_1 = require("../../config/env.config");
const common_const_1 = require("../../const/common.const");
const connectDB = async () => {
    try {
        const env = await (0, env_config_1.getEnv)();
        if (env?.DB_CONNECTION_STRING) {
            await mongoose_1.default.connect(env?.DB_CONNECTION_STRING);
            console.log(`${common_const_1.colors.fg.cyan}[application] @connectDB Database connection success.`);
            return;
        }
        throw new Error(`${common_const_1.colors.fg.red}[application] Missing connection string.`);
    }
    catch (error) {
        console.error(`${common_const_1.colors.fg.red}[application] @connectDB `, error);
        process.exit(1);
    }
};
exports.connectDB = connectDB;
const closeDB = async () => {
    try {
        await mongoose_1.default.disconnect();
        console.log(`${common_const_1.colors.fg.cyan}[application] @closeDB Database connection closed.`);
    }
    catch (error) {
        console.error(`${common_const_1.colors.fg.red}[application] @closeDB Error closing database connection:`, error);
        process.exit(1); // Optionally exit process if closing fails
    }
};
exports.closeDB = closeDB;
