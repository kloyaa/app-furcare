"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.handleMongooseError = handleMongooseError;
const mongoose_1 = require("mongoose");
const api_statuses_1 = require("../../const/api.statuses");
function handleMongooseError(error, res) {
    if (error instanceof mongoose_1.Error &&
        'message' in error &&
        typeof error.message === 'string' &&
        error.message.includes('buffering timed out')) {
        return res.status(500).json({
            ...api_statuses_1.statuses['0900'],
            message: 'Database connection error. Please try again shortly.',
        });
    }
    if (error instanceof mongoose_1.Error.CastError ||
        error instanceof mongoose_1.Error.ValidationError) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.message,
        });
    }
    return res.status(400).json(api_statuses_1.statuses['0900']);
}
