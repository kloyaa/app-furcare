"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkUserOrigin = void 0;
const api_statuses_1 = require("../const/api.statuses");
/**
 * Middleware function that checks the 'from' header in the request to determine the user's origin.
 *
 * @param {any} req - The request object.
 * @param {Response} res - The response object.
 * @param {NextFunction} next - The next function to be called.
 * @return {void | Response} - This function does not return anything.
 */
const checkUserOrigin = (req, res, next) => {
    const from = req.headers['from'];
    if (from === 'mobile' || from === 'web') {
        req.from = from;
        next();
    }
    else {
        return res.status(403).json(api_statuses_1.statuses['0059']);
    }
};
exports.checkUserOrigin = checkUserOrigin;
