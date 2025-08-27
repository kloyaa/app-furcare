"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = exports.Password = void 0;
const mongoose_1 = require("mongoose");
const userSchema = new mongoose_1.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
    },
    roles: [
        {
            type: mongoose_1.Schema.Types.ObjectId,
            ref: 'Role',
        },
    ],
}, { timestamps: true });
const passwordSchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    password: {
        type: String,
        required: true,
    },
}, { timestamps: true });
const Password = (0, mongoose_1.model)('Password', passwordSchema);
exports.Password = Password;
const User = (0, mongoose_1.model)('User', userSchema);
exports.User = User;
