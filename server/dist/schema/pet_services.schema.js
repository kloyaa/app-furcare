"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const petCageSchema = new mongoose_1.Schema({
    price: {
        type: Number,
        required: true,
    },
    size: {
        type: String,
        enum: ['Small', 'Medium', 'Large'],
        required: true,
    },
    occupant: {
        type: Number,
        default: 0,
    },
    max: {
        type: Number,
        required: true,
    },
}, { timestamps: true });
const PetCage = (0, mongoose_1.model)('PetCage', petCageSchema);
exports.default = PetCage;
