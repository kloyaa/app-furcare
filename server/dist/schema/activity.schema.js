"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
// Define the Activity Schema
const activitySchema = new mongoose_1.Schema({
    user: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    }, // Reference to the User model
    description: {
        type: String,
        required: true,
    },
}, { timestamps: true });
// Create the Activity model
const Activity = (0, mongoose_1.model)('Activity', activitySchema);
exports.default = Activity;
