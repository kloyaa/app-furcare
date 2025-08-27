"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Role = void 0;
const mongoose_1 = require("mongoose");
const roles_enum_1 = require("../_core/enum/roles.enum");
const roleSchema = new mongoose_1.Schema({
    name: {
        type: String,
        required: true,
        enum: Object.values(roles_enum_1.RoleName),
        unique: true,
    },
    description: {
        type: String,
        default: '',
        required: false,
    },
});
exports.Role = (0, mongoose_1.model)('Role', roleSchema);
