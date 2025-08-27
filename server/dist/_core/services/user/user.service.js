"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.removeRoleFromUser = exports.assignRoleToUser = exports.findLastLoginByUser = exports.findLastChangePassActivityByUser = exports.isPasswordAlreadyUsed = exports.isUserActive = void 0;
const bcrypt_1 = __importDefault(require("bcrypt"));
const profile_schema_1 = __importDefault(require("../../../schema/profile.schema"));
const user_schema_1 = require("../../../schema/user.schema");
const activity_schema_1 = __importDefault(require("../../../schema/activity.schema"));
const activity_enum_1 = require("../../enum/activity.enum");
const user_role_schema_1 = require("../../../schema/user_role.schema");
const isUserActive = async (user) => {
    try {
        const profile = await profile_schema_1.default.findOne({ user });
        if (profile) {
            if (!profile.isActive) {
                return false;
            }
        }
        return true;
    }
    catch (error) {
        return false;
    }
};
exports.isUserActive = isUserActive;
const isPasswordAlreadyUsed = async (user, password) => {
    try {
        const passwords = await user_schema_1.Password.find({ user }).select(['password']);
        for (const hash of passwords) {
            const passwordMatched = await bcrypt_1.default.compare(password, hash.password);
            if (passwordMatched) {
                return true;
            }
        }
        return false;
    }
    catch (error) {
        console.log('@isPasswordAlreadyUsed error', error);
        return false;
    }
};
exports.isPasswordAlreadyUsed = isPasswordAlreadyUsed;
const findLastChangePassActivityByUser = async (user) => {
    try {
        const activity = await user_schema_1.Password.findOne({ user }).sort({ createdAt: 'desc' });
        return activity?.createdAt ?? null;
    }
    catch (error) {
        console.log('@findLastChangePassActivityByUser error', error);
        return null;
    }
};
exports.findLastChangePassActivityByUser = findLastChangePassActivityByUser;
const findLastLoginByUser = async (user) => {
    try {
        const activity = await activity_schema_1.default.findOne()
            .or([
            { user, description: activity_enum_1.ActivityType.LOGIN },
            { user, description: activity_enum_1.ActivityType.REGISTRATION_SUCCESS },
        ])
            .sort({ createdAt: 'desc' });
        return activity?.createdAt ?? null;
    }
    catch (error) {
        console.log('@findLastLoginByUser error', exports.isPasswordAlreadyUsed);
        return null;
    }
};
exports.findLastLoginByUser = findLastLoginByUser;
const assignRoleToUser = async (userId, roleId) => {
    return await user_role_schema_1.UserRole.create({ user: userId, role: roleId });
};
exports.assignRoleToUser = assignRoleToUser;
const removeRoleFromUser = async (userId, roleId) => {
    return await user_role_schema_1.UserRole.findOneAndDelete({ user: userId, role: roleId });
};
exports.removeRoleFromUser = removeRoleFromUser;
