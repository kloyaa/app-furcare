"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isAuthenticated = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const api_statuses_1 = require("../const/api.statuses");
const env_config_1 = require("../config/env.config");
const encryption_util_1 = require("../utils/security/encryption.util");
/**
 * Middleware function that checks if the user is authenticated by verifying the JWT token in the request headers.
 *
 * @param {TRequest} req - The request object.
 * @param {any} res - The response object.
 * @param {any} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
const isAuthenticated = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization'];
        if (!authHeader) {
            return res.status(401).json(api_statuses_1.statuses['10020']);
        }
        const token = authHeader.split(' ')[1];
        if (!token) {
            return res.status(401).json(api_statuses_1.statuses['10020']);
        }
        const env = await (0, env_config_1.getEnv)();
        jsonwebtoken_1.default.verify(token, env?.JWT_SECRET_KEY, (err, decoded) => {
            if (err) {
                console.log('@isAuthenticated jwt.verify error', err);
                return res.status(401).json(api_statuses_1.statuses['10020']);
            }
            else if (decoded) {
                const decryptedData = (0, encryption_util_1.decrypt)(decoded.value, env.NODEX_CRYPTO_KEY ?? '123_cryptoKey');
                if (!decryptedData) {
                    return res.status(401).json(api_statuses_1.statuses['10020']);
                }
                else if (decryptedData?.origin !== req.headers['nodex-user-origin']) {
                    return res.status(403).json(api_statuses_1.statuses['0059']);
                }
                req.user = decryptedData;
                next();
            }
        });
    }
    catch (error) {
        console.log('@isAuthenticated error', error);
        return res.status(401).json(api_statuses_1.statuses['10020']);
    }
};
exports.isAuthenticated = isAuthenticated;
