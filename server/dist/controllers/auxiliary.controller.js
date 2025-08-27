"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateUsername = exports.generatePassword = void 0;
const utils_1 = require("../_core/utils/utils");
const api_statuses_1 = require("../_core/const/api.statuses");
const generatePassword = (req, res) => {
    return res.status(200).json({
        ...api_statuses_1.statuses['00'],
        password: (0, utils_1.generatePassword)(Number(req.query.length) || 8),
    });
};
exports.generatePassword = generatePassword;
const generateUsername = (req, res) => {
    return res.status(200).json({
        ...api_statuses_1.statuses['00'],
        username: (0, utils_1.generateUsername)(),
    });
};
exports.generateUsername = generateUsername;
