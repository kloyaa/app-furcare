"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getProfileByAccessToken = exports.editProfile = exports.createProfile = void 0;
const profile_schema_1 = __importDefault(require("../schema/profile.schema"));
const user_validator_1 = require("../_core/validators/user.validator");
const api_statuses_1 = require("../_core/const/api.statuses");
const activity_event_1 = require("../_core/events/activity.event");
const activity_enum_1 = require("../_core/enum/activity.enum");
const utils_1 = require("../_core/utils/utils");
const user_service_1 = require("../_core/services/user/user.service");
const odm_1 = require("../_core/utils/odm");
/**
 * Creates a new profile for a user.
 *
 * @param {TRequest} req - The request object containing the user's profile data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the profile is created successfully or rejects with an error.
 */
const createProfile = async (req, res) => {
    const error = (0, user_validator_1.validateCreateProfile)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { fullName, address, contact } = req.body;
        const profile = await profile_schema_1.default.findOne({ user: req.user.id });
        if (profile) {
            return res.status(400).json(api_statuses_1.statuses['0103']);
        }
        const newProfile = new profile_schema_1.default({
            user: req.user.id,
            fullName,
            address,
            contact,
        });
        const savedProfile = await newProfile.save();
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PROFILE_CREATED,
        });
        // Return the saved profile as a response
        return res.status(201).json(savedProfile);
    }
    catch (error) {
        console.log('@createProfile error', error);
        return res.status(401).json(api_statuses_1.statuses['0900']);
    }
};
exports.createProfile = createProfile;
/**
 * Updates an existing profile for a user.
 *
 * @param {TRequest} req - The request object containing the updated profile data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the profile is updated successfully or rejects with an error.
 */
const editProfile = async (req, res) => {
    const error = (0, user_validator_1.validateCreateProfile)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { fullName, address, contact } = req.body;
        const profile = await profile_schema_1.default.findOne({ user: req.user.id });
        if (!profile) {
            return res.status(404).json(api_statuses_1.statuses['0104']); // Not Found
        }
        profile.fullName = fullName;
        profile.address = address;
        profile.contact = contact;
        const updatedProfile = await profile.save();
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PROFILE_UPDATED,
        });
        return res.status(200).json(updatedProfile);
    }
    catch (error) {
        console.log('@editProfile error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
};
exports.editProfile = editProfile;
/**
 * Retrieves the user profile associated with the access token provided in the request.
 *
 * @param {TRequest} req - The request object containing the access token.
 * @param {Response} res - The response object used to send the user profile.
 * @return {Promise<void>} A promise that resolves when the user profile is successfully retrieved and sent in the response.
 *                         If the user profile is not found, a 404 status is returned with the corresponding error message.
 *                         If there is an error retrieving the user profile, a 401 status is returned with the corresponding error message.
 */
const getProfileByAccessToken = async (req, res) => {
    try {
        const user = req.user.id;
        const result = await profile_schema_1.default.findOne({ user }).exec();
        if (!result) {
            return res.status(404).json(api_statuses_1.statuses['02']);
        }
        const _findLastChangePassActivityByUser = await (0, user_service_1.findLastChangePassActivityByUser)((0, odm_1.toObjectId)(user));
        const _findLastLoginByUser = await (0, user_service_1.findLastLoginByUser)((0, odm_1.toObjectId)(user));
        return res.status(200).json({
            ...result._doc,
            others: {
                lastLogin: _findLastLoginByUser ? (0, utils_1.formatDate)(_findLastLoginByUser) : 'N/A',
                lastChangePassword: _findLastChangePassActivityByUser ? (0, utils_1.formatDate)(_findLastChangePassActivityByUser) : 'N/A',
            },
        });
    }
    catch (error) {
        console.log('@getProfileByAccessToken error', error);
        return res.status(401).json(api_statuses_1.statuses['0900']);
    }
};
exports.getProfileByAccessToken = getProfileByAccessToken;
