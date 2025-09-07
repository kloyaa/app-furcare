import { statuses } from '../../_core/const/api.statuses';
import {
    TRequest,
    TResponse,
} from '../../_core/interfaces/overrides.interface';
import { handleMongooseError } from '../../_core/utils/db/error.util';
import { validateUserManagement } from '../../_core/validators/admin';
import Profile from '../../schema/Profile.schema';
import { User } from '../../schema/User.schema';

export const getAllUsers = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    try {
        const { search, isActive } = req.query;

        // Base query for users
        const userQuery: any = {};
        if (search) {
            userQuery.$or = [
                { username: { $regex: search, $options: 'i' } },
                { email: { $regex: search, $options: 'i' } },
            ];
        }

        // Fetch users
        const users = await User.find(userQuery)
            .populate('roles', 'name description')
            .sort({ createdAt: -1 })
            .select('_id username email createdAt updatedAt roles')
            .lean();

        if (!users.length) {
            return res.status(200).json([]);
        }

        // Get related profiles
        const userIds = users.map(user => user._id);
        const profileQuery: any = { user: { $in: userIds } };

        if (typeof isActive !== 'undefined' && isActive !== '') {
            profileQuery.isActive = isActive === 'true';
        }

        if (search) {
            profileQuery.$or = [
                { fullName: { $regex: search, $options: 'i' } },
                { 'contact.phoneNumber': { $regex: search, $options: 'i' } },
                { 'contact.facebookDisplayName': { $regex: search, $options: 'i' } },
            ];
        }

        const profiles = await Profile.find(profileQuery)
            .select('user fullName contact address isActive')
            .lean();

        const profileMap = profiles.reduce((acc, profile) => {
            acc[profile.user.toString()] = profile;
            return acc;
        }, {} as any);

        // Merge user + profile
        const usersWithProfiles = users
            .map(user => {
                const profile = profileMap[user._id.toString()];
                return {
                    _id: user._id,
                    username: user.username,
                    email: user.email,
                    fullName: profile?.fullName || 'N/A',
                    address: profile?.address || 'N/A',
                    contact: profile?.contact || 'N/A',
                    roles: user.roles,
                    isActive: profile?.isActive ?? true,
                    createdAt: user.createdAt,
                    updatedAt: user.updatedAt,
                };
            })
            // If isActive filter is applied but some users don’t have profiles, remove them
            .filter(u =>
                typeof isActive !== 'undefined' && isActive !== ''
                    ? u.isActive === (isActive === 'true')
                    : true
            );

        return res.status(200).json(usersWithProfiles);
    } catch (error) {
        console.log('@getAllUsers error', error);
        return handleMongooseError(error, res);
    }
};

export const activateUser = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    const error = validateUserManagement(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }

    try {
        const { user: userId } = req.body;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'User not found.',
            });
        }

        const profile = await Profile.findOne({ user: userId });
        if (!profile) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'User profile not found.',
            });
        }

        if (profile.isActive) {
            return res.status(400).json({
                ...statuses['501'],
                message: 'User is already active.',
            });
        }

        profile.isActive = true;
        await profile.save();

        return res.status(200).json({
            username: user.username,
            email: user.email,
            isActive: profile.isActive,
            updatedAt: profile.updatedAt,
        });
    } catch (error) {
        console.log('@activateUser error', error);
        return handleMongooseError(error, res);
    }
};

export const disableUser = async (
    req: TRequest,
    res: TResponse
): Promise<any> => {
    const error = validateUserManagement(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }

    try {
        const { user: userId } = req.body;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'User not found.',
            });
        }

        const profile = await Profile.findOne({ user: userId });
        if (!profile) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'User profile not found.',
            });
        }

        if (!profile.isActive) {
            return res.status(400).json({
                ...statuses['501'],
                message: 'User is already disabled.',
            });
        }

        profile.isActive = false;
        await profile.save();

        return res.status(200).json({
            username: user.username,
            email: user.email,
            isActive: profile.isActive,
            updatedAt: profile.updatedAt,
        });
    } catch (error) {
        console.log('@disableUser error', error);
        return handleMongooseError(error, res);
    }
};
