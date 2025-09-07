import { type Response } from 'express';
import { formatDate } from 'date-fns';
import { statuses } from '../../_core/const/api.statuses';
import {
  TRequest,
  TResponse,
} from '../../_core/interfaces/overrides.interface';
import { formatRelativeTime } from '../../_core/utils/Date.util';
import {
  GroomingApplication,
  BoardingApplication,
  HomeServiceApplication,
} from '../../schema/application';
import {
  validateGetApplicationsByStatus,
  validateUpdateApplicationStatus,
  validateGetApplicationDetails,
} from '../../_core/validators/staff/application.validator';
import Profile from '../../schema/Profile.schema';
import { Document, Types } from 'mongoose';
import {
  IGroomingApplication,
  IBoardingApplication,
  IHomeServiceApplication,
} from '../../_core/interfaces/schema/schema.interface';
import {
  updateCageOccupant,
  validateCageAvailability,
} from '../pet-services.controller';
import {
  ApplicationStatusEnum,
  ApplicationTypeEnum,
} from '../../_core/enum/application.enum';
import { emitter } from '../../_core/events/activity.event';
import { ActivityType, EventName } from '../../_core/enum/activity.enum';
import { IActivity } from '../../_core/interfaces/activity.interface';
/**
 * Retrieves all applications based on status with formatted data for staff review
 *
 * @param {TRequest} req - The request object containing query parameters
 * @param {TResponse} res - The response object used to send the applications data
 * @return {Promise<void>} A promise that resolves when the applications are successfully retrieved
 */
export const getAllApplicationsByStatus = async (
  req: TRequest,
  res: TResponse
): Promise<void | Response> => {
  // Validate query parameters
  const error = validateGetApplicationsByStatus(req.query);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { status = 'pending', applicationType = 'all' } = req.query;

    // Define population options for consistent data structure
    const populateOptions = [
      {
        path: 'user',
        select: 'username email',
      },
      {
        path: 'pet',
        select: 'name specie gender',
      },
      {
        path: 'branch',
        select: 'name location',
      },
    ];

    let applications: any[] = [];

    // Fetch based on application type filter
    if (applicationType === 'all' || applicationType === 'grooming') {
      const groomingApps = await GroomingApplication.find({ status })
        .populate(populateOptions)
        .sort({ createdAt: -1 })
        .lean()
        .exec();
      applications.push(
        ...groomingApps.map(app => ({ ...app, applicationType: 'grooming' }))
      );
    }

    if (applicationType === 'all' || applicationType === 'boarding') {
      const boardingApps = await BoardingApplication.find({ status })
        .populate(populateOptions)
        .sort({ createdAt: -1 })
        .lean()
        .exec();
      applications.push(
        ...boardingApps.map(app => ({ ...app, applicationType: 'boarding' }))
      );
    }

    if (applicationType === 'all' || applicationType === 'homeService') {
      const homeServiceApps = await HomeServiceApplication.find({ status })
        .populate(populateOptions)
        .sort({ createdAt: -1 })
        .lean()
        .exec();
      applications.push(
        ...homeServiceApps.map(app => ({
          ...app,
          applicationType: 'homeService',
        }))
      );
    }

    // Fetch user profiles for all applications
    const userIds = applications.map(app => app.user?._id).filter(Boolean);
    const userProfiles = await Profile.find({ user: { $in: userIds } })
      .select('user fullName address contact')
      .lean()
      .exec();

    // Create a map for quick profile lookup
    const profileMap = new Map();
    userProfiles.forEach(profile =>
      profileMap.set(profile.user.toString(), profile)
    );

    // Format applications with consistent structure
    const formatApplications = (applications: any[]) => {
      return applications.map(app => {
        // Get user profile from the map
        const userProfile = profileMap.get(app.user?._id?.toString());

        return {
          _id: app._id,
          user: app.user?._id || null,
          applicationType: app.applicationType,
          userInfo: {
            username: app.user?.username || 'N/A',
            email: app.user?.email || 'N/A',
            fullName: userProfile?.fullName || 'N/A',
            address: userProfile?.address || 'N/A',
            phoneNumber: userProfile?.contact?.phoneNumber || 'N/A',
            facebookDisplayName:
              userProfile?.contact?.facebookDisplayName || 'N/A',
          },
          petInfo: {
            name: app.pet?.name || 'N/A',
            breed: app.pet?.specie || 'N/A',
            gender: app.pet?.gender || 'N/A',
          },
          totalPrice: app.totalPrice || 0,
          paidAmount: app.paidAmount || 0,
          paymentStatus: app.paymentStatus || 'unpaid',
          submittedAt: formatRelativeTime(app.createdAt),
          branchName: app.branch?.name || 'N/A',
          status: app.status || 'pending',
        };
      });
    };

    // Format and sort all applications by creation date
    const formattedApplications = formatApplications(applications).sort(
      (a, b) => {
        const aApp = applications.find(
          app => app._id.toString() === a._id.toString()
        );
        const bApp = applications.find(
          app => app._id.toString() === b._id.toString()
        );

        const aDate = aApp?.createdAt ? new Date(aApp.createdAt).getTime() : 0;
        const bDate = bApp?.createdAt ? new Date(bApp.createdAt).getTime() : 0;

        return bDate - aDate; // Most recent first
      }
    );

    // Count by type
    const typeCount = {
      grooming: applications.filter(app => app.applicationType === 'grooming')
        .length,
      boarding: applications.filter(app => app.applicationType === 'boarding')
        .length,
      homeService: applications.filter(
        app => app.applicationType === 'homeService'
      ).length,
    };

    return res.status(200).json({
      applications: formattedApplications,
      statistics: {
        total: formattedApplications.length,
        ...typeCount,
      },
      filter: {
        status,
        applicationType,
      },
    });
  } catch (error) {
    console.log('@getAllApplicationsByStatus error', error);
    return res.status(500).json(statuses['0900']);
  }
};

/**
 * Updates the status of an application by ID and type
 *
 * @param {TRequest} req - The request object containing application ID, type, and new status
 * @param {TResponse} res - The response object used to send the update result
 * @return {Promise<void>} A promise that resolves when the application status is updated
 */
export const updateApplicationStatus = async (
  req: TRequest,
  res: TResponse
): Promise<void | Response> => {
  const error = validateUpdateApplicationStatus(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { application, applicationType, status: newStatus } = req.body;

    let updatedApplication: any;

    // Update based on application type
    switch (applicationType) {
      case ApplicationTypeEnum.GroomingApplication:
        updatedApplication = await GroomingApplication.findByIdAndUpdate(
          application,
          { status: newStatus, updatedAt: new Date() },
          { new: true }
        ).populate([
          { path: 'user', select: 'username email' },
          { path: 'pet', select: 'name specie gender' },
          { path: 'branch', select: 'name' },
        ]);

        emitter.emit(EventName.ACTIVITY, {
          user: req.user.id as any,
          description:
            applicationType + ' application status updated to ' + newStatus,
        } as IActivity);
        break;

      case ApplicationTypeEnum.BoardingApplication:
        {
          updatedApplication = await BoardingApplication.findById(application);
          if (!updatedApplication) {
            return res.status(404).json({
              ...statuses['02'],
              message: 'Application not found',
            });
          }

          const isRejected = newStatus === ApplicationStatusEnum.REJECTED;
          const isCompleted = newStatus === ApplicationStatusEnum.COMPLETED;
          const isApproved = newStatus === ApplicationStatusEnum.APPROVED;

          if (isApproved) {
            const isCageAvailable = await validateCageAvailability(
              updatedApplication.cage
            );
            if (!isCageAvailable) {
              return res.status(400).json({
                ...statuses['501'],
                message: 'Cage is full',
              });
            }
          }

          updatedApplication = await BoardingApplication.findByIdAndUpdate(
            application,
            { status: newStatus, updatedAt: new Date() },
            { new: true }
          ).populate([
            { path: 'user', select: 'username email' },
            { path: 'pet', select: 'name specie gender' },
            { path: 'branch', select: 'name' },
          ]);

          if (isApproved) {
            const isCageUpdated = await updateCageOccupant({
              action: 'add',
              cage: updatedApplication.cage,
            });
            if (!isCageUpdated) {
              console.log('cage not updated');
            }
          }

          if (isCompleted) {
            const isCageUpdated = await updateCageOccupant({
              action: 'remove',
              cage: updatedApplication.cage,
            });
            if (!isCageUpdated) {
              console.log('cage not updated');
            }
          }

          emitter.emit(EventName.ACTIVITY, {
            user: req.user.id as any,
            description:
              applicationType + ' application status updated to ' + newStatus,
          } as IActivity);
        }
        break;

      case ApplicationTypeEnum.HomeServiceApplication:
        updatedApplication = await HomeServiceApplication.findByIdAndUpdate(
          application,
          { status: newStatus, updatedAt: new Date() },
          { new: true }
        ).populate([
          { path: 'user', select: 'username email' },
          { path: 'pet', select: 'name specie gender' },
          { path: 'branch', select: 'name' },
        ]);

        emitter.emit(EventName.ACTIVITY, {
          user: req.user.id as any,
          description:
            applicationType + ' application status updated to ' + newStatus,
        } as IActivity);
        break;

      default:
        return res.status(400).json({
          ...statuses['501'],
          message: 'Invalid application type',
        });
    }

    if (!updatedApplication) {
      return res.status(404).json({
        ...statuses['404'],
        message: 'Application not found',
      });
    }

    return res.status(200).json({
      application: updatedApplication,
      message: `${applicationType} application status updated to ${newStatus}`,
    });
  } catch (error) {
    console.log('@updateApplicationStatus error', error);
    return res.status(500).json(statuses['0900']);
  }
};

/**
 * Gets application details by ID and type for detailed view
 *
 * @param {TRequest} req - The request object containing application ID and type
 * @param {TResponse} res - The response object used to send the application details
 * @return {Promise<void>} A promise that resolves when the application details are retrieved
 */
export const getApplicationDetails = async (
  req: TRequest,
  res: TResponse
): Promise<void | Response> => {
  // Validate parameters
  const error = validateGetApplicationDetails(req.params);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { applicationId, applicationType } = req.params;

    const populateOptions = [
      { path: 'user', select: 'username email' },
      { path: 'pet', select: 'name specie gender age color' },
      { path: 'branch', select: 'name location address contact' },
    ];

    let application;

    switch (applicationType) {
      case 'grooming':
        application = await GroomingApplication.findById(applicationId)
          .populate(populateOptions)
          .lean()
          .exec();
        break;

      case 'boarding':
        application = await BoardingApplication.findById(applicationId)
          .populate([
            ...populateOptions,
            { path: 'cage', select: 'name size pricePerDay' },
          ])
          .lean()
          .exec();
        break;

      case 'homeService':
        application = await HomeServiceApplication.findById(applicationId)
          .populate(populateOptions)
          .lean()
          .exec();
        break;

      default:
        return res.status(400).json({
          ...statuses['501'],
          message: 'Invalid application type',
        });
    }

    if (!application) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Application not found',
      });
    }

    // Fetch user profile separately
    let userProfile = null;
    if (application.user?._id) {
      userProfile = await Profile.findOne({ user: application.user._id })
        .select('fullName address contact')
        .lean()
        .exec();
    }

    return res.status(200).json({
      ...statuses['00'],
      data: {
        application: {
          ...application,
          // Enhanced user info with profile data
          userInfo: {
            username: application.user?.username || 'N/A',
            email: application.user?.email || 'N/A',
            fullName: userProfile?.fullName || 'N/A',
            address: userProfile?.address || 'N/A',
            phoneNumber: userProfile?.contact?.phoneNumber || 'N/A',
            facebookDisplayName:
              userProfile?.contact?.facebookDisplayName || 'N/A',
          },
          createdAtFormatted: formatRelativeTime(application.createdAt),
          createdAtFull: formatDate(application.createdAt, 'dd/MM/yyyy'),
          applicationType,
        },
      },
    });
  } catch (error) {
    console.log('@getApplicationDetails error', error);
    return res.status(500).json(statuses['0900']);
  }
};
