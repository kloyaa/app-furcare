import { statuses } from '../../../_core/const/api.statuses';
import { ActivityType, EventName } from '../../../_core/enum/activity.enum';
import { emitter } from '../../../_core/events/activity.event';
import { IActivity } from '../../../_core/interfaces/activity.interface';
import {
  TRequest,
  TResponse,
} from '../../../_core/interfaces/overrides.interface';
import { handleMongooseError } from '../../../_core/utils/db/error.util';
import { isEmpty } from '../../../_core/utils/utils';
import { validateCreateHomeServiceApplication } from '../../../_core/validators/application.validator';
import { HomeServiceApplication } from '../../../schema/application/HomeServiceApplication.schema';
import Branch from '../../../schema/branch.schema';
import Pet from '../../../schema/pet.schema';

export const createHomeServiceApplication = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  const error = validateCreateHomeServiceApplication(req.body);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { pet, branch, schedule } = req.body;

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

    await HomeServiceApplication.create({
      user: req.user.id,
      branch,
      pet,
      schedule,
      status: 'pending',
    });

    emitter.emit(EventName.ACTIVITY, {
      user: req.user.id as any,
      description: ActivityType.APPLICATION_HOME_SERVICE_SUBMITTED,
    } as IActivity);

    return res.status(201).json(statuses['00']);
  } catch (err) {
    console.log('@createHomeServiceApplication error', err);
    return handleMongooseError(err, res);
  }
};

export const getHomeServiceApplications = async (
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
    const homeServiceApplications = await HomeServiceApplication.find(query)
      .sort({ createdAt: -1 })
      .populate('pet')
      .populate('branch');

    return res.status(200).json(homeServiceApplications);
  } catch (error) {
    console.log('@getGroomingApplications error', error);
    return handleMongooseError(error, res);
  }
};
