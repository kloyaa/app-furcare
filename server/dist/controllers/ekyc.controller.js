"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateEKYCAccount = exports.createEKYCAccount = void 0;
const bcrypt_1 = __importDefault(require("bcrypt"));
const mongoose_1 = require("mongoose");
const api_statuses_1 = require("../_core/const/api.statuses");
const activity_event_1 = require("../_core/events/activity.event");
const activity_enum_1 = require("../_core/enum/activity.enum");
const user_schema_1 = require("../schema/user.schema");
const profile_schema_1 = __importDefault(require("../schema/profile.schema"));
const role_schema_1 = require("../schema/role.schema");
const user_role_schema_1 = require("../schema/user_role.schema");
const eky_validator_1 = require("../_core/validators/eky.validator");
/**
 * Creates a new user and profile through eKYC process in a single transaction.
 *
 * @param {TRequest} req - The request object containing the eKYC registration data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the user and profile are created successfully or rejects with an error.
 */
const createEKYCAccount = async (req, res) => {
    const error = (0, eky_validator_1.validateEKYCRegistration)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    const session = await (0, mongoose_1.startSession)();
    session.startTransaction();
    try {
        const { 
        // User credentials
        username, email, password, 
        // Profile information
        fullName, address, contact, } = req.body;
        // Check if user already exists
        const existingUser = await user_schema_1.User.findOne()
            .or([{ username }, { email }])
            .session(session)
            .exec();
        if (existingUser) {
            await session.abortTransaction();
            return res.status(409).json(api_statuses_1.statuses['0052']);
        }
        // Check if phone number already exists
        const existingPhoneProfile = await profile_schema_1.default.findOne({
            'contact.phoneNumber': contact.phoneNumber,
        }).session(session);
        if (existingPhoneProfile) {
            await session.abortTransaction();
            return res.status(409).json({
                ...api_statuses_1.statuses['0052'],
                message: 'Phone number already registered',
            });
        }
        const userRole = await role_schema_1.Role
            .findOne({ name: 'user' })
            .session(session);
        if (!userRole) {
            await session.abortTransaction();
            return res.status(500).json(api_statuses_1.statuses['0072']);
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
        const createdUser = await newUser.save({ session });
        await user_role_schema_1.UserRole.create([{
                user: createdUser._id,
                role: userRole._id,
            }], { session });
        // Create profile with eKYC data
        const newProfile = new profile_schema_1.default({
            user: createdUser._id,
            fullName,
            address,
            contact: {
                facebookDisplayName: contact.facebookDisplayName || '',
                phoneNumber: contact.phoneNumber,
            },
            isActive: true,
        });
        await newProfile.save({ session });
        // Commit transaction
        await session.commitTransaction();
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: createdUser._id,
            description: activity_enum_1.ActivityType.REGISTRATION_SUCCESS,
        });
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        await session.abortTransaction();
        console.log('@createEKYCAccount error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
    finally {
        session.endSession();
    }
};
exports.createEKYCAccount = createEKYCAccount;
/**
 * Updates an existing user and profile through eKYC process in a single transaction.
 *
 * @param {TRequest} req - The request object containing the updated eKYC data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the user and profile are updated successfully or rejects with an error.
 */
const updateEKYCAccount = async (req, res) => {
    const error = (0, eky_validator_1.validateEKYCUpdate)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    const session = await (0, mongoose_1.startSession)();
    session.startTransaction();
    try {
        const { user: userId, // must be passed in request
        email, password, fullName, address, contact, } = req.body;
        const user = await user_schema_1.User.findById(userId).session(session);
        if (!user) {
            await session.abortTransaction();
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'User not found',
            });
        }
        // ✅ Email uniqueness check
        if (email && email !== user.email) {
            const duplicateEmail = await user_schema_1.User.findOne({
                email,
                _id: { $ne: userId },
            }).session(session);
            if (duplicateEmail) {
                await session.abortTransaction();
                return res.status(409).json({
                    ...api_statuses_1.statuses['0052'],
                    message: 'Email already registered',
                });
            }
            user.email = email;
        }
        // ✅ Mobile uniqueness check
        if (contact?.phoneNumber) {
            const duplicatePhoneProfile = await profile_schema_1.default.findOne({
                'contact.phoneNumber': contact.phoneNumber,
                user: { $ne: userId },
            }).session(session);
            if (duplicatePhoneProfile) {
                await session.abortTransaction();
                return res.status(409).json({
                    ...api_statuses_1.statuses['0052'],
                    message: 'Phone number already registered',
                });
            }
        }
        // ✅ Update password if provided
        if (password) {
            const saltRounds = 10;
            const salt = await bcrypt_1.default.genSalt(saltRounds);
            user.password = await bcrypt_1.default.hash(password, salt);
        }
        await user.save({ session });
        // ✅ Update profile
        const profile = await profile_schema_1.default.findOne({ user: userId }).session(session);
        if (!profile) {
            await session.abortTransaction();
            return res.status(404).json({
                ...api_statuses_1.statuses['0051'],
                message: 'Profile not found',
            });
        }
        if (fullName)
            profile.fullName = fullName;
        if (address)
            profile.address = address;
        if (contact?.facebookDisplayName !== undefined)
            profile.contact.facebookDisplayName = contact.facebookDisplayName;
        if (contact?.phoneNumber)
            profile.contact.phoneNumber = contact.phoneNumber;
        await profile.save({ session });
        await session.commitTransaction();
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: userId,
            description: activity_enum_1.ActivityType.PROFILE_UPDATED,
        });
        return res.status(200).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        await session.abortTransaction();
        console.log('@updateEKYCAccount error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
    finally {
        session.endSession();
    }
};
exports.updateEKYCAccount = updateEKYCAccount;
