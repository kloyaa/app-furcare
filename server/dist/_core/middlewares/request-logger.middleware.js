"use strict";
// request-logger.middleware.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.requestLoggerMiddleware = void 0;
const activity_event_1 = require("../events/activity.event");
const activity_enum_1 = require("../enum/activity.enum");
/**
 * Middleware function that logs request and response data and emits an event with the data.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @param {NextFunction} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
const requestLoggerMiddleware = async (req, res, next) => {
    const start = Date.now();
    // Get client IP address from headers (use a more accurate method if needed)
    const clientIp = req.headers['x-forwarded-for'] || req.socket.remoteAddress;
    const timestamp = new Date().toISOString();
    const requestMethod = req.method;
    const requestUrl = req.url;
    const userAgent = req.headers['user-agent'];
    // Capture response data
    let responseStatus;
    let responseStatusMessage;
    // Create a function to handle response data capture
    const captureResponseData = () => {
        const elapsed = Date.now() - start;
        responseStatus = res.statusCode || 500;
        responseStatusMessage = res.statusMessage || 'Unknown';
        // Emit the event with request and response data
        activity_event_1.emitter.emit(activity_enum_1.EventName.NETWORK_ACTIVITY, {
            clientIp,
            timestamp,
            requestMethod,
            requestUrl,
            userAgent,
            requestBody: req.body,
            responseStatus,
            responseStatusMessage,
            elapsed,
        });
    };
    // Continue processing the request
    next();
    // Hook into the response's finish event to capture the response status
    res.on('finish', captureResponseData);
    // // Hook into the response's close event to capture the response status if it ends abruptly
    // res.on('close', captureResponseData);
};
exports.requestLoggerMiddleware = requestLoggerMiddleware;
