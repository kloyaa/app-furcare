import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';

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
    const petServices = [
        {
            "code": "PET_GROOMING",
            "name": "Grooming",
            "description":
                "Professional grooming services for your pets including bathing, haircut, and nail trimming.",
            "available": true,
        },
        {
            "code": "PET_BOARDING",
            "name": "Boarding",
            "description":
                "Safe and comfortable boarding facilities for your pets while you are away.",
            "available": true,
        },
        {
            "code": "HOME_SERVICE",
            "name": "Home Service",
            "description":
                "Pet care services delivered right at your doorstep for convenience.",
            "available": true,
        },
        {
            "code": "PET_TRAINING",
            "name": "Training",
            "description":
                "Basic obedience and advanced training programs for dogs and cats.",
            "available": false,
        },
    ];

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
    const petServices = [
        {
            "code": "SCHEDULE_1",
            "schedule": "08:00 AM - 09:00 AM",
            "price": 30,
            "available": true,
        },
        {
            "code": "SCHEDULE_2",
            "schedule": "10:00 AM - 11:00 AM",
            "price": 30,
            "available": true,
        },
        {
            "code": "SCHEDULE_3",
            "schedule": "12:00 PM - 01:00 PM",
            "price": 30,
            "available": false,
        },
        {
            "code": "SCHEDULE_4",
            "schedule": "02:00 PM - 03:00 PM",
            "price": 30,
            "available": false,
        },
        {
            "code": "SCHEDULE_5",
            "schedule": "04:00 PM - 05:00 PM",
            "price": 30,
            "available": false,
        },
    ];

    return res.status(200).json(petServices);
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
    const petServices = [
        {
            "code": "SHORT_TRIM",
            "name": "Short Trim",
            "price": 0,
            "available": true,
        },
        {
            "code": "LONG_TRIM",
            "name": "Long Trim",
            "price": 0,
            "available": true,
        },
        {
            "code": "FULL_TRIM",
            "name": "Full Trim (Complete Shave)",
            "price": 0,
            "available": true,
        },
        {
            "code": "SPECIFIC_REQUEST",
            "name": "Specfic request",
            "price": 0,
            "available": true,
        },
    ];

    return res.status(200).json(petServices);
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
    const petServices = [
        {
            "code": "FULL_BATH",
            "name": "Full bath (Shampoo, Conditioning and Drying)",
            "price": 100,
            "available": true,
        },
        {
            "code": "HAIRCUT",
            "name": "Haircut/Trimming",
            "price": 100,
            "available": true,
        },
        {
            "code": "NAIL_TRIM",
            "name": "Nail trimming",
            "price": 100,
            "available": true,
        },
        {
            "code": "EAR_CLEANING",
            "name": "Ear cleaning",
            "price": 100,
            "available": true,
        },
        {
            "code": "TEETH_BRUSHING",
            "name": "Teeth brushing",
            "price": 100,
            "available": true,
        },
        {
            "code": "FLEA_AND_TICK_TREATMENT",
            "name": "Flea and tick treatment",
            "price": 100,
            "available": true,
        },
        {
            "code": "SPECIFIC_REQUEST",
            "name": "Specfic request",
            "price": 100,
            "available": true,
        },
    ];

    return res.status(200).json(petServices);
};

