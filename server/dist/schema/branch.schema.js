"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const branchSchema = new mongoose_1.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    address: {
        type: String,
        required: true,
        trim: true,
    },
    phone: {
        type: String,
        required: true,
        trim: true,
    },
    open: {
        type: Boolean,
        required: true,
        default: false,
    },
}, {
    timestamps: true,
});
const Branch = (0, mongoose_1.model)('Branch', branchSchema);
exports.default = Branch;
