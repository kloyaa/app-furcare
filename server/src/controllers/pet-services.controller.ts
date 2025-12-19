import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';
import {
  groomingOptions,
  groomingPreferences,
  groomingServiceSchedules,
  petCages,
  petServices,
} from '../_core/const/pet_srvices.const';
import PetCage from '../schema/pet-services.schema';
import { statuses } from '../_core/const/api.statuses';
import { handleMongooseError } from '../_core/utils/db/error.util';
import { isObjectIdOrHexString } from 'mongoose';

/**
 * @description Get all pet services
 * @route GET /pet/services
 * @header Authorization: Bearer [token]
 * @response 200 PetService[]
 * @responseProperty {string} code - Unique code for the pet service
 * @responseProperty {string} name - Name of the pet service
 * @responseProperty {string} description - Description of the pet service
 * @responseProperty {boolean} available - Whether the pet service is available or not
 */
export const getPetServices = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  return res.status(200).json(petServices);
};

/**
 * @description Get all available grooming schedules
 * @route GET /pet/grooming/schedules
 * @header Authorization: Bearer [token]
 * @response 200 GroomingSchedule[]
 * @responseProperty {string} schedule - Schedule of the grooming service in 12-hour format
 * @responseProperty {number} price - Price of the grooming service
 * @responseProperty {boolean} available - Whether the grooming service is available or not
 */
export const getGroomingSchedules = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  return res.status(200).json(groomingServiceSchedules);
};

/**
 * @description Get all available grooming preferences
 * @route GET /pet/grooming/preferences
 * @header Authorization: Bearer [token]
 * @response 200 GroomingPreference[]
 * @responseProperty {string} code - Unique code for the grooming preference
 * @responseProperty {string} name - Name of the grooming preference
 * @responseProperty {number} price - Price of the grooming preference
 * @responseProperty {boolean} available - Whether the grooming preference is available or not
 */
export const getGroomingPreferences = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  return res.status(200).json(groomingPreferences);
};

/**
 * @description Get all extra grooming services
 * @route GET /pet/grooming/extra
 * @header Authorization: Bearer [token]
 * @response 200 GroomingExtra[]
 * @responseProperty {string} code - Unique code for the extra grooming service
 * @responseProperty {string} name - Name of the extra grooming service
 * @responseProperty {number} price - Price of the extra grooming service
 * @responseProperty {boolean} available - Whether the extra grooming service is available or not
 */
export const getGroomingExtra = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  return res.status(200).json(groomingOptions);
};

export const insertCages = async (req: Request, res: Response) => {
  try {
    const cages = await PetCage.find();
    if (cages.length > 0) {
      return res.status(400).json(statuses['03']);
    }
    await PetCage.insertMany(petCages);
    return res.status(201).json(statuses['00']);
  } catch (error) {
    console.log('@insertCages error', error);
    return handleMongooseError(error, res);
  }
};

export const getAllCages = async (req: TRequest, res: Response) => {
  try {
    const cages = await PetCage.find();
    return res.status(200).json(cages);
  } catch (error) {
    console.log('@getAllCages error', error);
    return handleMongooseError(error, res);
  }
};

export const updateCageOccupant = async (payload: any): Promise<boolean> => {
  const { action, cage: cageId } = payload;
  if (
    !isObjectIdOrHexString(cageId) ||
    (action !== 'add' && action !== 'remove')
  ) {
    console.log('@updateCageOccupant error', 'Invalid payload');
    return false;
  }
  try {
    const cage = await PetCage.findById(cageId);
    if (!cage) {
      console.log('@updateCageOccupant error', 'Cage not found');
      return false;
    }

    if (action === 'add') {
      if (cage.occupant >= cage.max) {
        return false;
      }
      cage.occupant += 1;
    } else if (action === 'remove') {
      if (cage.occupant <= 0) {
        return false;
      }
      cage.occupant -= 1;
    }

    await cage.save();
    return true;
  } catch (error) {
    console.log('@updateCageOccupant error', error);
    return false;
  }
};

export const updateCageData = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  const { action, cage: cageId } = req.body;

  if (
    !isObjectIdOrHexString(cageId) ||
    (action !== 'add' && action !== 'remove')
  ) {
    return res.status(400).json(statuses['03']);
  }

  try {
    const cage = await PetCage.findById(cageId);
    if (!cage) {
      return res.status(404).json(statuses['04']); // not found
    }

    if (action === 'add') {
      if (cage.occupant >= cage.max) {
        return res.status(409).json({
          ...statuses['03'],
          message: 'Cage is already full',
        });
      }
      cage.occupant += 1;
    }

    if (action === 'remove') {
      if (cage.occupant <= 0) {
        return res.status(409).json({
          ...statuses['03'],
          message: 'Cage is already empty',
        });
      }
      cage.occupant -= 1;
    }

    await cage.save();
    return res.status(200).json(statuses['00']);
  } catch (error) {
    console.log('@updateCageData error', error);
    return res.status(400).json(statuses['03']);
  }
};


export const validateCageAvailability = async (
  cageId: any
): Promise<boolean> => {
  try {
    if (!isObjectIdOrHexString(cageId)) {
      console.log('@updateCageOccupant error', 'Invalid cageId');
      return false;
    }
    const cage = await PetCage.findById(cageId);
    if (!cage) {
      console.log('@updateCageOccupant error', 'Cage not found');
      return false;
    }

    if (cage.occupant >= cage.max) {
      console.log('@updateCageOccupant error', 'Cage is full');
      return false;
    }

    return true;
  } catch (error) {
    console.log('@validateCageCapacity error', error);
    return false;
  }
};
