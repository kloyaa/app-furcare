import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';
import { groomingOptions, groomingPreferences, groomingServiceSchedules, petServices } from '../_core/const/pet_srvices.const';

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

