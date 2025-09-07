import { statuses } from '../../_core/const/api.statuses';
import {
  groomingOptions,
  groomingPreferences,
  groomingServiceSchedules,
} from '../../_core/const/pet_srvices.const';
import { EventName, ActivityType } from '../../_core/enum/activity.enum';
import { emitter } from '../../_core/events/activity.event';
import { IActivity } from '../../_core/interfaces/activity.interface';
import {
  TRequest,
  TResponse,
} from '../../_core/interfaces/overrides.interface';
import { handleMongooseError } from '../../_core/utils/db/error.util';
import { isEmpty } from '../../_core/utils/utils';
import { validateCreateGroomingApplication } from '../../_core/validators/application.validator';
import { GroomingApplication } from '../../schema/application/grooming-application.schema';
import Branch from '../../schema/branch.schema';
import Pet from '../../schema/pet.schema';

export const createGroomingApplication = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  const error = validateCreateGroomingApplication(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const {
      pet,
      branch,
      scheduleCode,
      groomingOptions: selectedOptions,
      groomingPreferences: selectedPreferences,
      hasAllergy,
      isOnMedication,
      hasAntiRabbiesVaccination,
    } = req.body;

    const [findPet, findBranch] = await Promise.all([
      Pet.findById(pet),
      Branch.findById(branch),
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

    // Calculate total price server-side
    let totalPrice = 0;

    // Add schedule price
    const schedule = groomingServiceSchedules.find(
      s => s.code === scheduleCode
    );
    if (schedule) {
      totalPrice += schedule.price;
    }

    // Add grooming options prices (from request body codes)
    if (selectedOptions && selectedOptions.length > 0) {
      selectedOptions.forEach((optionCode: string) => {
        const optionObj = groomingOptions.find(o => o.code === optionCode);
        if (optionObj) {
          totalPrice += optionObj.price;
        }
      });
    }

    // Add grooming preferences prices (from request body codes)
    if (selectedPreferences && selectedPreferences.length > 0) {
      selectedPreferences.forEach((preferenceCode: string) => {
        const preferenceObj = groomingPreferences.find(
          p => p.code === preferenceCode
        );
        if (preferenceObj) {
          totalPrice += preferenceObj.price;
        }
      });
    }

    await GroomingApplication.create({
      user: req.user.id,
      branch,
      pet,
      scheduleCode,
      groomingOptions: selectedOptions,
      groomingPreferences: selectedPreferences,
      hasAllergy,
      isOnMedication,
      hasAntiRabbiesVaccination,
      totalPrice, // Use calculated total price
      status: 'pending',
    });

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.APPLICATION_GROOMING_SUBMITTED,
    } as IActivity);

    return res.status(201).json(statuses['00']);
  } catch (err) {
    console.log('@createGroomingApplication error', err);
    return handleMongooseError(err, res);
  }
};

export const getGroomingApplications = async (
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
    const groomingApplications = await GroomingApplication.find(query)
      .sort({ createdAt: -1 })
      .populate('pet')
      .populate('branch');

    const mappedApplications = groomingApplications.map(application => {
      const applicationObj = application.toObject();
      const scheduleObj = groomingServiceSchedules.find(
        schedule => schedule.code === applicationObj.scheduleCode
      );
      const groomingOptionsObjects =
        applicationObj.groomingOptions
          ?.map(optionCode =>
            groomingOptions.find(option => option.code === optionCode)
          )
          .filter(Boolean) || [];
      const groomingPreferencesObjects =
        applicationObj.groomingPreferences
          ?.map(preferenceCode =>
            groomingPreferences.find(
              preference => preference.code === preferenceCode
            )
          )
          .filter(Boolean) || [];

      const { scheduleCode, ...restApplicationObj } = applicationObj;
      return {
        ...restApplicationObj,
        schedule: scheduleObj,
        groomingOptions: groomingOptionsObjects,
        groomingPreferences: groomingPreferencesObjects,
      };
    });

    return res.status(200).json(mappedApplications);
  } catch (error) {
    console.log('@getGroomingApplications error', error);
    return handleMongooseError(error, res);
  }
};
