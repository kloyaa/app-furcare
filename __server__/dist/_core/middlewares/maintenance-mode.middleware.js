"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.maintenanceModeMiddleware = void 0;
const env_config_1 = require("../config/env.config");
const api_statuses_1 = require("../const/api.statuses");
/**
 * Middleware function that checks if the application is in maintenance mode.
 *
 * @param {any} req - The request object.
 * @param {any} res - The response object.
 * @param {any} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
const maintenanceModeMiddleware = async (req, res, next) => {
    const env = await (0, env_config_1.getEnv)();
    if (env?.ENVIRONMENT_MAINTENANCE === 'true') {
        return res.status(500).json(api_statuses_1.statuses['500']);
    }
    next();
};
exports.maintenanceModeMiddleware = maintenanceModeMiddleware;
