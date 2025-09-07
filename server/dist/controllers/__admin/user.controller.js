"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.disableUser = exports.activateUser = exports.getAllUsers = void 0;
const api_statuses_1 = require("../../_core/const/api.statuses");
const error_util_1 = require("../../_core/utils/db/error.util");
const __admin_1 = require("../../_core/validators/__admin");
const profile_schema_1 = __importDefault(require("../../schema/profile.schema"));
const user_schema_1 = require("../../schema/user.schema");
const getAllUsers = async (req, res) => {
    try {
        const { search, isActive } = req.query;
        // Base query for users
        const userQuery = {};
        if (search) {
            userQuery.$or = [
                { username: { $regex: search, $options: "i" } },
                { email: { $regex: search, $options: "i" } },
            ];
        }
        // Fetch users
        const users = await user_schema_1.User.find(userQuery)
            .populate("roles", "name description")
            .sort({ createdAt: -1 })
            .select("_id username email createdAt updatedAt roles")
            .lean();
        if (!users.length) {
            return res.status(200).json([]);
        }
        // Get related profiles
        const userIds = users.map((user) => user._id);
        const profileQuery = { user: { $in: userIds } };
        if (typeof isActive !== "undefined" && isActive !== "") {
            profileQuery.isActive = isActive === "true";
        }
        if (search) {
            profileQuery.$or = [
                { fullName: { $regex: search, $options: "i" } },
                { "contact.phoneNumber": { $regex: search, $options: "i" } },
                { "contact.facebookDisplayName": { $regex: search, $options: "i" } },
            ];
        }
        const profiles = await profile_schema_1.default.find(profileQuery)
            .select("user fullName contact address isActive")
            .lean();
        const profileMap = profiles.reduce((acc, profile) => {
            acc[profile.user.toString()] = profile;
            return acc;
        }, {});
        // Merge user + profile
        const usersWithProfiles = users
            .map((user) => {
            const profile = profileMap[user._id.toString()];
            return {
                _id: user._id,
                username: user.username,
                email: user.email,
                fullName: profile?.fullName || "N/A",
                address: profile?.address || "N/A",
                contact: profile?.contact || "N/A",
                roles: user.roles,
                isActive: profile?.isActive ?? true,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt,
            };
        })
            // If isActive filter is applied but some users don’t have profiles, remove them
            .filter((u) => typeof isActive !== "undefined" && isActive !== ""
            ? u.isActive === (isActive === "true")
            : true);
        return res.status(200).json(usersWithProfiles);
    }
    catch (error) {
        console.log("@getAllUsers error", error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getAllUsers = getAllUsers;
const activateUser = async (req, res) => {
    const error = (0, __admin_1.validateUserManagement)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { user: userId } = req.body;
        const user = await user_schema_1.User.findById(userId);
        if (!user) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'User not found.'
            });
        }
        const profile = await profile_schema_1.default.findOne({ user: userId });
        if (!profile) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'User profile not found.'
            });
        }
        if (profile.isActive) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'User is already active.'
            });
        }
        profile.isActive = true;
        await profile.save();
        return res.status(200).json({
            username: user.username,
            email: user.email,
            isActive: profile.isActive,
            updatedAt: profile.updatedAt
        });
    }
    catch (error) {
        console.log('@activateUser error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.activateUser = activateUser;
const disableUser = async (req, res) => {
    const error = (0, __admin_1.validateUserManagement)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { user: userId } = req.body;
        const user = await user_schema_1.User.findById(userId);
        if (!user) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'User not found.'
            });
        }
        const profile = await profile_schema_1.default.findOne({ user: userId });
        if (!profile) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'User profile not found.'
            });
        }
        if (!profile.isActive) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'User is already disabled.'
            });
        }
        profile.isActive = false;
        await profile.save();
        return res.status(200).json({
            username: user.username,
            email: user.email,
            isActive: profile.isActive,
            updatedAt: profile.updatedAt
        });
    }
    catch (error) {
        console.log('@disableUser error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.disableUser = disableUser;
