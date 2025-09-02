"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.allowApiAccessMiddleware = void 0;
const utils_1 = require("../utils/utils");
const api_statuses_1 = require("../const/api.statuses");
const env_config_1 = require("../config/env.config");
/**
 * Middleware function that allows API access based on the provided access key, secret key, and user origin.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @param {NextFunction} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
const allowApiAccessMiddleware = async (req, res, next) => {
    const accessKey = req.headers['nodex-access-key'];
    const secretKey = req.headers['nodex-secret-key'];
    const userOrigin = req.headers['nodex-user-origin'];
    if (req.path.includes('api-docs')) {
        return next();
    }
    if ((0, utils_1.isEmpty)(accessKey) || (0, utils_1.isEmpty)(secretKey) || (0, utils_1.isEmpty)(userOrigin)) {
        return res.status(403).json(api_statuses_1.statuses['0060']);
    }
    const env = await (0, env_config_1.getEnv)();
    if (accessKey?.toString().trim() === env.NODEX_ACCESS_KEY &&
        secretKey?.toString().trim() === env.NODEX_SECRET_KEY) {
        next();
    }
    else {
        return res.status(403).json(api_statuses_1.statuses['0070']);
    }
};
exports.allowApiAccessMiddleware = allowApiAccessMiddleware;
