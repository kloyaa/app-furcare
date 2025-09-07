import { statuses } from '../../_core/const/api.statuses';
import { EventName, ActivityType } from '../../_core/enum/activity.enum';
import { emitter } from '../../_core/events/activity.event';
import { IActivity } from '../../_core/interfaces/activity.interface';
import {
  TRequest,
  TResponse,
} from '../../_core/interfaces/overrides.interface';
import { handleMongooseError } from '../../_core/utils/db/error.util';
import { isEmpty } from '../../_core/utils/utils';
import {
  validateCreateBoardingApplication,
  validateCreateBoardingApplicationExtension,
} from '../../_core/validators/application.validator';
import { BoardingApplication } from '../../schema/application/boarding-application.schema';

import Branch from '../../schema/branch.schema';
import Pet from '../../schema/pet.schema';
import PetCage from '../../schema/pet-services.schema';

export const createBoardingApplication = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  const error = validateCreateBoardingApplication(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { pet, branch, cage, schedule } = req.body;

    const [findPet, findBranch, findCage] = await Promise.all([
      Pet.findById(pet),
      Branch.findById(branch),
      PetCage.findById(cage),
    ]);

    if (!findBranch) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Branch not found.',
      });
    }

    if (!findPet) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Pet not found.',
      });
    }

    if (!findCage) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Cage not found.',
      });
    }

    await BoardingApplication.create({
      ...req.body,
      user: req.user.id,
      branch,
      pet,
      schedule,
      totalPrice: findCage.price * schedule.days,
      status: 'pending',
    });

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.APPLICATION_BOARDING_SUBMITTED,
    } as IActivity);

    return res.status(201).json(statuses['00']);
  } catch (err) {
    console.log('@createBoardingApplication error', err);
    return handleMongooseError(err, res);
  }
};

export const createBoardingApplicationExtension = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  const error = validateCreateBoardingApplicationExtension(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { application: id, count, type } = req.body;

    // Validate count parameter
    if (typeof count !== 'number' || count < 0) {
      return res.status(400).json({
        ...statuses['501'],
        message: 'Count must be a non-negative number.',
      });
    }

    const application = await BoardingApplication.findById(id);

    if (!application) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Boarding application not found.',
      });
    }

    const cage = await PetCage.findById(application.cage);
    if (!cage) {
      return res.status(404).json({
        ...statuses['02'],
        message: 'Associated cage not found.',
      });
    }

    // Initialize original values if this is the first extension
    const originalDays =
      application.schedule.originalDays || application.schedule.days;
    const originalPrice = application.originalPrice || application.totalPrice;

    let daysToChange = 0;
    let priceChange = 0;
    let activityDescription = '';
    let newTotalDays = application.schedule.days;

    switch (type) {
      case 'add':
        daysToChange = count;
        priceChange = cage.price * count;
        newTotalDays = application.schedule.days + count;
        activityDescription = `Extended boarding by ${count} day(s)`;
        break;

      case 'minus':
        // Use virtual field to get current extension days
        const currentExtensionDays = application.extensionDays;

        if (count > currentExtensionDays) {
          return res.status(400).json({
            ...statuses['501'],
            message: `Cannot reduce by ${count} days. Current extension is only ${currentExtensionDays} day(s).`,
          });
        }

        daysToChange = -count;
        priceChange = -(cage.price * count);
        newTotalDays = application.schedule.days - count;
        activityDescription = `Reduced boarding by ${count} day(s)`;
        break;

      case 'set':
        // Use virtual field to get current extension
        const currentExtension = application.extensionDays;

        daysToChange = count - currentExtension;
        priceChange = cage.price * daysToChange;
        newTotalDays = originalDays + count;

        if (count > currentExtension) {
          activityDescription = `Extended boarding to ${count} additional day(s)`;
        } else if (count < currentExtension) {
          activityDescription = `Reduced boarding to ${count} additional day(s)`;
        } else {
          activityDescription = `Boarding extension unchanged at ${count} day(s)`;
        }
        break;
    }

    // Validate that we don't go below the original booking days
    if (newTotalDays < originalDays) {
      return res.status(400).json({
        ...statuses['501'],
        message: `Cannot reduce below original booking of ${originalDays} day(s).`,
      });
    }

    // Prepare the extension record
    const extensionRecord = {
      type,
      days: type === 'set' ? count : Math.abs(daysToChange),
      priceChange,
      timestamp: new Date(),
      user: req.user.id,
    };

    // Update the application with the changes
    const updateData: any = {
      $inc: {
        'schedule.days': daysToChange,
        totalPrice: priceChange,
      },
      $push: {
        extensions: extensionRecord,
      },
    };

    // Set original values if this is the first extension
    if (!application.schedule.originalDays) {
      updateData['schedule.originalDays'] = originalDays;
    }
    if (!application.originalPrice) {
      updateData['originalPrice'] = originalPrice;
    }

    const updatedApplication = await BoardingApplication.findByIdAndUpdate(
      id,
      updateData,
      { new: true }
    ).populate(['user', 'pet', 'cage', 'branch']);

    console.log(
      '@createBoardingApplicationExtension updatedApplication',
      updatedApplication
    );

    // Emit activity with descriptive message
    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: activityDescription,
    } as IActivity);

    return res.status(201).json({
      ...statuses['00'],
      data: {
        daysChanged: daysToChange,
        priceChanged: priceChange,
        newTotalDays: updatedApplication.schedule.days,
        newTotalPrice: updatedApplication.totalPrice,
        // Use virtual fields here instead of manual calculation
        extensionDays: updatedApplication.extensionDays,
        extensionPrice: updatedApplication.extensionPrice,
        originalDays: updatedApplication.schedule.originalDays || originalDays,
        application: updatedApplication,
      },
    });
  } catch (err) {
    console.log('@createBoardingApplicationExtension error', err);
    return handleMongooseError(err, res);
  }
};

export const getBoardingApplications = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  try {
    const status = req.query.status as string;
    let query: any = {
      user: req.user.id,
    };
    if (!isEmpty(status)) {
      query = {
        ...query,
        status,
      };
    }
    const boardingApplications = await BoardingApplication.find(query)
      .sort({ createdAt: -1 })
      .populate('pet')
      .populate('branch')
      .populate('cage');

    console.log('boardingApplications', boardingApplications.length);
    return res.status(200).json(boardingApplications);
  } catch (error) {
    console.log('@getBoardingApplications error', error);
    return handleMongooseError(error, res);
  }
};
