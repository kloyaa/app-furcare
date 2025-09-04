import bcrypt from 'bcrypt';
import { type Response } from 'express';
import { startSession } from 'mongoose';
import { statuses } from '../_core/const/api.statuses';
import { emitter } from '../_core/events/activity.event';
import { ActivityType, EventName } from '../_core/enum/activity.enum';
import { IActivity } from '../_core/interfaces/activity.interface';
import { TRequest } from '../_core/interfaces/overrides.interface';

import { User } from '../schema/user.schema';
import Profile from '../schema/profile.schema';
import { Role } from '../schema/role.schema';
import { UserRole } from '../schema/user_role.schema';
import { validateEKYCRegistration } from '../_core/validators/eky.validator';

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

    const userRole = await Role
      .findOne({ name: 'user' })
      .session(session);

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

    await UserRole.create([{
      user: createdUser._id,
      role: userRole._id,
    }], { session });

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