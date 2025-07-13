"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const profileSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    firstName: {
        type: String,
        required: true,
    },
    lastName: {
        type: String,
        required: true,
    },
    middleName: {
        type: String,
        required: false,
    },
    birthdate: {
        type: Date,
        required: true,
    },
    address: {
        present: {
            type: String,
            required: true,
        },
        permanent: {
            type: String,
            required: false,
        },
    },
    contact: {
        email: {
            type: String,
            required: true,
        },
        number: {
            type: String,
            required: true,
        },
    },
    gender: {
        type: String,
        enum: ['male', 'female', 'other'],
        required: true,
    },
    isActive: {
        type: Boolean,
        default: false,
    },
}, { timestamps: true });
const Profile = (0, mongoose_1.model)('Profile', profileSchema);
exports.default = Profile;
