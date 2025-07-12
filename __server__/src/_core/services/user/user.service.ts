import bcrypt from 'bcrypt';
import { Types } from 'mongoose';
import Profile from '../../../schema/profile.schema';
import { Password, User } from '../../../schema/user.schema';
import Activity from '../../../schema/activity.schema';
import { ActivityType } from '../../enum/activity.enum';
import { Role } from '../../../schema/role.schema';
import { UserRole } from '../../../schema/user_role.schema';

export const isUserActive = async (user: Types.ObjectId) => {
  try {
    const profile = await Profile.findOne({ user });
    if (profile) {
      if (!profile.isActive) {
        return false;
      }
    }

    return true;
  } catch (error) {
    return false;
  }
};

export const isPasswordAlreadyUsed = async (user: Types.ObjectId, password: string) => {
  try {
    const passwords = await Password.find({ user }).select(['password']);

    for (const hash of passwords) {
      const passwordMatched: any = await bcrypt.compare(password, hash.password);
      if (passwordMatched) {
        return true;
      }
    }

    return false;
  } catch (error) {
    console.log('@isPasswordAlreadyUsed error', error);
    return false;
  }
};

export const findLastChangePassActivityByUser = async (user: Types.ObjectId) => {
  try {
    const activity: any = await Password.findOne({ user }).sort({ createdAt: 'desc' });

    return activity?.createdAt ?? null;
  } catch (error) {
    console.log('@findLastChangePassActivityByUser error', error);
    return null;
  }
};

export const findLastLoginByUser = async (user: Types.ObjectId) => {
  try {
    const activity: any = await Activity.findOne()
      .or([
        { user, description: ActivityType.LOGIN },
        { user, description: ActivityType.REGISTRATION_SUCCESS },
      ])
      .sort({ createdAt: 'desc' });

    return activity?.createdAt ?? null;
  } catch (error) {
    console.log('@findLastLoginByUser error', isPasswordAlreadyUsed);
    return null;
  }
};

export const assignRoleToUser = async (userId: string, roleId: string) => {
  return await UserRole.create({ user: userId, role: roleId });
};

export const removeRoleFromUser = async (userId: string, roleId: string) => {
  return await UserRole.findOneAndDelete({ user: userId, role: roleId });
};
