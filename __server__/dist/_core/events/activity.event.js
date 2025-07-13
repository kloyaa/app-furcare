"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.emitter = void 0;
const eventemitter3_1 = __importDefault(require("eventemitter3"));
const activity_enum_1 = require("../enum/activity.enum");
const activity_schema_1 = __importDefault(require("../../schema/activity.schema"));
const request_log_schema_1 = __importDefault(require("../../schema/request_log.schema"));
// Create an EventEmitter instance
exports.emitter = new eventemitter3_1.default();
// Event listener for 'login-activity' event
exports.emitter.on(activity_enum_1.EventName.ACTIVITY, async (payload) => {
    try {
        // Create a new Activity document
        const newActivity = new activity_schema_1.default({
            user: payload.user,
            description: payload.description,
        });
        // Save the new activity log to the database
        await newActivity.save();
    }
    catch (error) {
        console.error(`@${activity_enum_1.EventName.ACTIVITY} error`, error);
    }
});
// Event listener for 'network-activity' event
exports.emitter.on(activity_enum_1.EventName.NETWORK_ACTIVITY, async (payload) => {
    const { clientIp, requestMethod, requestUrl, userAgent, requestBody, responseStatus, responseStatusMessage, elapsed, } = payload;
    try {
        // Create a new RequestLog document
        const requestLog = new request_log_schema_1.default({
            timestamp: new Date(),
            clientIp,
            requestMethod,
            requestUrl,
            userAgent,
            requestBody,
            responseStatus,
            responseStatusMessage,
            elapsed,
        });
        // Save the new activity log to the database
        await requestLog.save();
    }
    catch (error) {
        console.error(`@${activity_enum_1.EventName.NETWORK_ACTIVITY} error`, error);
    }
});
