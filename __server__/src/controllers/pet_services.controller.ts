import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';
import { groomingOptions, groomingPreferences, groomingServiceSchedules, petCages, petServices } from '../_core/const/pet_srvices.const';
import PetCage from '../schema/pet_services.schema';
import { statuses } from '../_core/const/api.statuses';
import { handleMongooseError } from '../_core/utils/db/error.util';
import { validateUpdatePetCages } from '../_core/validators/pet_services.validator';
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
export const getPetServices = async (req: TRequest, res: Response): Promise<any> => {
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
export const getGroomingSchedules = async (req: TRequest, res: Response): Promise<any> => {
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
export const getGroomingPreferences = async (req: TRequest, res: Response): Promise<any> => {
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
export const getGroomingExtra = async (req: TRequest, res: Response): Promise<any> => {
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

export const updateCageOccupant = async (req: TRequest, res: Response) => {
    const error = validateUpdatePetCages(req.body);
    if (error) {
        return res.status(400).json({
            ...statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    const { action, id } = req.body;

    try {
        const cage = await PetCage.findById(id);
        if (!cage) {
            return res
                .status(404)
                .json(statuses['02']);
        }

        if (action === 'add') {
            if (cage.occupant >= cage.max) {
                return res
                    .status(400)
                    .json({
                        ...statuses['01'],
                        message: 'Cage is already full.'
                    });
            }
            cage.occupant += 1;
        } else if (action === 'remove') {
            if (cage.occupant <= 0) {
                return res
                    .status(400)
                    .json({
                        ...statuses['01'],
                        message: 'Cage is already empty.'
                    });
            }

            cage.occupant -= 1;
        }

        await cage.save();
        return res
            .status(200)
            .json({
                ...statuses['00'],
                message: 'Occupant updated successfully.'
            });
    } catch (error) {
        console.log('@updateCageOccupant error', error);
        return handleMongooseError(error, res);
    }
};

export const validateCageAvailability = async (req: TRequest, res: Response) => {
    try {
        const { id } = req.params;
        if (!isObjectIdOrHexString(id)) {
            return res
                .status(400)
                .json(statuses['0901']);
        }
        const cage = await PetCage.findById(id);
        if (!cage) {
            return res
                .status(404)
                .json(statuses['02']);
        }

        if (cage.occupant >= cage.max) {
            return res
                .status(400)
                .json({
                    ...statuses['01'],
                    message: 'Cage is already full.'
                });
        }

        return res
            .status(200)
            .json(statuses['00']);
    } catch (error) {
        console.log('@validateCageCapacity error', error);
        return handleMongooseError(error, res);
    }
}