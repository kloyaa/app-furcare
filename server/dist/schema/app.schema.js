"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const appSchema = new mongoose_1.Schema({
    maintenance: {
        type: Boolean,
        default: false,
    },
}, {
    timestamps: true,
});
const Application = (0, mongoose_1.model)('Application', appSchema);
exports.default = Application;
