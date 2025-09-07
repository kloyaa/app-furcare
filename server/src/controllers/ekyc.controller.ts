import bcrypt from 'bcrypt';
import { type Response } from 'express';
import { startSession } from 'mongoose';
import { statuses } from '../_core/const/api.statuses';
import { emitter } from '../_core/events/activity.event';
import { ActivityType, EventName } from '../_core/enum/activity.enum';
import { IActivity } from '../_core/interfaces/activity.interface';
import { TRequest } from '../_core/interfaces/overrides.interface';

import { User } from '../schema/User.schema';
import Profile from '../schema/Profile.schema';
import { Role } from '../schema/Role.schema';
import { UserRole } from '../schema/UserRole.schema';
import {
  validateEKYCRegistration,
  validateEKYCUpdate,
} from '../_core/validators/eky.validator';

/**
 * Creates a new user and profile through eKYC process in a single transaction.
 *
 * @param {TRequest} req - The request object containing the eKYC registration data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the user and profile are created successfully or rejects with an error.
 */
export const createEKYCAccount = async (
  req: TRequest,
  res: Response
): Promise<void | Response> => {
  const error = validateEKYCRegistration(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  const session = await startSession();
  session.startTransaction();

  try {
    const {
      // User credentials
      username,
      email,
      password,
      // Profile information
      fullName,
      address,
      contact,
    } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne()
      .or([{ username }, { email }])
      .session(session)
      .exec();

    if (existingUser) {
      await session.abortTransaction();
      return res.status(409).json(statuses['0052']);
    }

    // Check if phone number already exists
    const existingPhoneProfile = await Profile.findOne({
      'contact.phoneNumber': contact.phoneNumber,
    }).session(session);

    if (existingPhoneProfile) {
      await session.abortTransaction();
      return res.status(409).json({
        ...statuses['0052'],
        message: 'Phone number already registered',
      });
    }

    const userRole = await Role.findOne({ name: 'user' }).session(session);

    if (!userRole) {
      await session.abortTransaction();
      return res.status(500).json(statuses['0072']);
    }

    const saltRounds = 10;
    const salt = await bcrypt.genSalt(saltRounds);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      salt,
    });

    const createdUser = await newUser.save({ session });

    await UserRole.create(
      [
        {
          user: createdUser._id,
          role: userRole._id,
        },
      ],
      { session }
    );

    // Create profile with eKYC data
    const newProfile = new Profile({
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

    emitter.emit(EventName.ACTIVITY, {
      user: createdUser._id,
      description: ActivityType.REGISTRATION_SUCCESS,
    } as IActivity);

    return res.status(201).json(statuses['00']);
  } catch (error) {
    await session.abortTransaction();
    console.log('@createEKYCAccount error', error);
    return res.status(500).json(statuses['0900']);
  } finally {
    session.endSession();
  }
};

/**
 * Updates an existing user and profile through eKYC process in a single transaction.
 *
 * @param {TRequest} req - The request object containing the updated eKYC data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<void>} A promise that resolves when the user and profile are updated successfully or rejects with an error.
 */
export const updateEKYCAccount = async (
  req: TRequest,
  res: Response
): Promise<void | Response> => {
  const error = validateEKYCUpdate(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  const session = await startSession();
  session.startTransaction();

  try {
    const {
      user: userId, // must be passed in request
      email,
      password,
      fullName,
      address,
      contact,
    } = req.body;

    const user = await User.findById(userId).session(session);
    if (!user) {
      await session.abortTransaction();
      return res.status(404).json({
        ...statuses['02'],
        message: 'User not found',
      });
    }

    // ✅ Email uniqueness check
    if (email && email !== user.email) {
      const duplicateEmail = await User.findOne({
        email,
        _id: { $ne: userId },
      }).session(session);
      if (duplicateEmail) {
        await session.abortTransaction();
        return res.status(409).json({
          ...statuses['0052'],
          message: 'Email already registered',
        });
      }
      user.email = email;
    }

    // ✅ Mobile uniqueness check
    if (contact?.phoneNumber) {
      const duplicatePhoneProfile = await Profile.findOne({
        'contact.phoneNumber': contact.phoneNumber,
        user: { $ne: userId },
      }).session(session);
      if (duplicatePhoneProfile) {
        await session.abortTransaction();
        return res.status(409).json({
          ...statuses['0052'],
          message: 'Phone number already registered',
        });
      }
    }

    // ✅ Update password if provided
    if (password) {
      const saltRounds = 10;
      const salt = await bcrypt.genSalt(saltRounds);
      user.password = await bcrypt.hash(password, salt);
    }

    await user.save({ session });

    // ✅ Update profile
    const profile = await Profile.findOne({ user: userId }).session(session);
    if (!profile) {
      await session.abortTransaction();
      return res.status(404).json({
        ...statuses['0051'],
        message: 'Profile not found',
      });
    }

    if (fullName) profile.fullName = fullName;
    if (address) profile.address = address;
    if (contact?.facebookDisplayName !== undefined)
      profile.contact.facebookDisplayName = contact.facebookDisplayName;
    if (contact?.phoneNumber) profile.contact.phoneNumber = contact.phoneNumber;

    await profile.save({ session });

    await session.commitTransaction();

    emitter.emit(EventName.ACTIVITY, {
      user: userId,
      description: ActivityType.PROFILE_UPDATED,
    } as IActivity);

    return res.status(200).json(statuses['00']);
  } catch (error) {
    await session.abortTransaction();
    console.log('@updateEKYCAccount error', error);
    return res.status(500).json(statuses['0900']);
  } finally {
    session.endSession();
  }
};
