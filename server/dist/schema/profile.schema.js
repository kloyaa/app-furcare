"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const profileSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    fullName: {
        type: String,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    contact: {
        facebookUrl: {
            type: String,
            required: false,
        },
        messengerUrl: {
            type: String,
            required: false,
        },
        phoneNumber: {
            type: String,
            required: true,
        },
    },
    isActive: {
        type: Boolean,
        default: true,
    },
}, { timestamps: true });
const Profile = (0, mongoose_1.model)('Profile', profileSchema);
exports.default = Profile;
