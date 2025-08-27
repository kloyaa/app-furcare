"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.logNetworBody = exports.logNetworkHeaders = exports.logNetworkRequests = exports.setDefaultDateTime = void 0;
const utils_1 = require("../utils/utils");
const common_const_1 = require("../const/common.const");
/**
 * Sets the 'x-nodex-datetime' header in the response to the current date and time in ISO format.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
const setDefaultDateTime = (req, res, next) => {
    res.setHeader('x-nodex-datetime', new Date().toISOString());
    next();
};
exports.setDefaultDateTime = setDefaultDateTime;
/**
 * Logs the network request details and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
const logNetworkRequests = (req, res, next) => {
    console.log(`${common_const_1.colors.fg.yellow}[endpoint] ${req.method} ${req.originalUrl} - ${(0, utils_1.formatDate)(new Date())} ${common_const_1.colors.fg.white}`);
    next();
};
exports.logNetworkRequests = logNetworkRequests;
/**
 * Logs the network request headers and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
const logNetworkHeaders = (req, res, next) => {
    console.log(`${common_const_1.colors.fg.green}--> headers ${common_const_1.colors.fg.white}`);
    console.log(req.headers);
    next();
};
exports.logNetworkHeaders = logNetworkHeaders;
/**
 * Logs the network request body and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
const logNetworBody = (req, res, next) => {
    console.log(`${common_const_1.colors.fg.green}--> body ${common_const_1.colors.fg.white}`);
    console.log(req.body);
    next();
};
exports.logNetworBody = logNetworBody;
