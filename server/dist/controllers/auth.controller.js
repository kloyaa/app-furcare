"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.changeUserPassword = exports.register = exports.login = void 0;
const bcrypt_1 = __importDefault(require("bcrypt"));
const api_statuses_1 = require("../_core/const/api.statuses");
const auth_validator_1 = require("../_core/validators/auth.validator");
const activity_event_1 = require("../_core/events/activity.event");
const activity_enum_1 = require("../_core/enum/activity.enum");
const jwt_util_1 = require("../_core/utils/jwt/jwt.util");
const env_config_1 = require("../_core/config/env.config");
const user_schema_1 = require("../schema/user.schema");
const encryption_util_1 = require("../_core/utils/security/encryption.util");
const user_service_1 = require("../_core/services/user/user.service");
const odm_1 = require("../_core/utils/odm");
const role_schema_1 = require("../schema/role.schema");
const user_role_schema_1 = require("../schema/user_role.schema");
const mongoose_1 = require("mongoose");
const login = async (req, res) => {
    const error = (0, auth_validator_1.validateLogin)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { username, password } = req.body;
        const user = await user_schema_1.User.findOne()
            .or([{ username }, { email: username }])
            .exec();
        if (!user) {
            return res.status(401).json(api_statuses_1.statuses['0051']);
        }
        const passwordMatched = await bcrypt_1.default.compare(password, user.password);
        if (!passwordMatched) {
            return res.status(401).json(api_statuses_1.statuses['0051']);
        }
        const env = await (0, env_config_1.getEnv)();
        const payload = { origin: req.headers['nodex-user-origin'], id: user.id };
        const encryptedPayload = (0, encryption_util_1.encrypt)(payload, env.NODEX_CRYPTO_KEY ?? '123_cryptoKey');
        const generatedToken = await (0, jwt_util_1.generateJwt)(encryptedPayload, env.JWT_SECRET_KEY || '123_secretKey');
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: user.id,
            description: activity_enum_1.ActivityType.LOGIN,
        });
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            accessToken: generatedToken,
        });
    }
    catch (error) {
        console.log('@login error', error);
        return res.status(401).json(api_statuses_1.statuses['0900']);
    }
};
exports.login = login;
/**
 * Registers a new user with the provided credentials.
 *
 * @param {TRequest} req - The request object containing the user's registration data.
 * @param {Response} res - The response object used to send the registration result.
 * @return {Promise<any>} - A promise that resolves with the registration result.
 */
const register = async (req, res) => {
    const error = (0, auth_validator_1.validateRegister)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { username, email, password } = req.body;
        const existingUser = await user_schema_1.User.findOne().or([{ username }, { email }]).exec();
        if (existingUser) {
            return res.status(401).json(api_statuses_1.statuses['0052']);
        }
        // Check if default role exist in DB
        const userRole = await role_schema_1.Role.findOne({ name: 'user' });
        if (!userRole) {
            return res.status(401).json(api_statuses_1.statuses['0072']);
        }
        const saltRounds = 10;
        const salt = await bcrypt_1.default.genSalt(saltRounds);
        const hashedPassword = await bcrypt_1.default.hash(password, salt);
        const newUser = new user_schema_1.User({
            username,
            email,
            password: hashedPassword,
            salt,
        });
        const createdUser = await newUser.save({
            session: await (0, mongoose_1.startSession)(),
        });
        await user_role_schema_1.UserRole.create({
            user: createdUser._id,
            role: userRole._id,
        });
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: createdUser.id,
            description: activity_enum_1.ActivityType.REGISTRATION_SUCCESS,
        });
        const env = await (0, env_config_1.getEnv)();
        const payload = { origin: req.headers['nodex-user-origin'], id: createdUser.id };
        const encryptedPayload = (0, encryption_util_1.encrypt)(payload, env.NODEX_CRYPTO_KEY ?? '123_cryptoKey');
        return res.status(201).json({
            ...api_statuses_1.statuses['0050'],
            accessToken: await (0, jwt_util_1.generateJwt)(encryptedPayload, env.JWT_SECRET_KEY || '123_secretkey'),
        });
    }
    catch (error) {
        console.log('@register error', error);
        return res.status(401).json(api_statuses_1.statuses['0900']);
    }
};
exports.register = register;
/**
 * Changes the user's password.
 *
 * @param {TRequest} req - The request object containing the user's current password and new password.
 * @param {Response} res - The response object used to send the result of the password change.
 * @return {Promise<void>} - A promise that resolves with the result of the password change.
 */
const changeUserPassword = async (req, res) => {
    const error = (0, auth_validator_1.validateChangePassword)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { currentPassword, newPassword } = req.body;
        const user = await user_schema_1.User.findById(req.user.id);
        if (!user) {
            return res.status(404).json(api_statuses_1.statuses['0056']);
        }
        const passwordMatched = await bcrypt_1.default.compare(currentPassword, user.password);
        if (!passwordMatched) {
            return res.status(403).json(api_statuses_1.statuses['0063']);
        }
        if (currentPassword === newPassword) {
            return res.status(403).json(api_statuses_1.statuses['0064']);
        }
        const _isPasswordAlreadyUsed = await (0, user_service_1.isPasswordAlreadyUsed)((0, odm_1.toObjectId)(req.user.id), newPassword);
        if (_isPasswordAlreadyUsed) {
            return res.status(403).json(api_statuses_1.statuses['0065']);
        }
        const saltRounds = 10;
        const salt = await bcrypt_1.default.genSalt(saltRounds);
        const hashedPassword = await bcrypt_1.default.hash(newPassword, salt);
        const savePassword = new user_schema_1.Password({
            user: req.user.id,
            password: hashedPassword,
        });
        await Promise.all([
            user_schema_1.User.findByIdAndUpdate(req.user.id, { password: hashedPassword }, { new: true }),
            savePassword.save(),
        ]);
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: user.id,
            description: activity_enum_1.ActivityType.CHANGE_PASSWORD,
        });
        return res.status(200).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@updateUserPassword error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
};
exports.changeUserPassword = changeUserPassword;
