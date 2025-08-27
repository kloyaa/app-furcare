"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const petSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    }, // Reference to the User model
    name: {
        type: String,
        required: true,
    },
    specie: {
        type: String,
        required: true,
    },
    gender: {
        type: String,
        required: true,
    },
}, { timestamps: true });
const Pet = (0, mongoose_1.model)('Pet', petSchema);
exports.default = Pet;
