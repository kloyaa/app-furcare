import { statuses } from "../_core/const/api.statuses";
import { TRequest } from "../_core/interfaces/overrides.interface";
import { validateCreateGroomingApplication } from "../_core/validators/application.validator";
import { type Response } from 'express';
import { GroomingApplication } from "../schema/application.schema";
import { emitter } from "../_core/events/activity.event";
import { ActivityType, EventName } from "../_core/enum/activity.enum";
import { IActivity } from "../_core/interfaces/activity.interface";
import { Branch } from "../schema/branch.schema";
import Pet from "../schema/pet.schema";
import { handleMongooseError } from "../_core/utils/db/error.util";
import { groomingOptions, groomingPreferences, groomingServiceSchedules } from "../_core/const/pet_srvices.const";

export const createGroomingApplication = async (req: TRequest, res: Response): Promise<any> => {
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
        ])

        if (!findBranch) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Branch not found.'
            });
        }

        if (!findPet) {
            return res.status(404).json({
                ...statuses['02'],
                message: 'Pet not found.'
            });
        }

        // Calculate total price server-side
        let totalPrice = 0;

        // Add schedule price
        const schedule = groomingServiceSchedules.find(s => s.code === scheduleCode);
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
                const preferenceObj = groomingPreferences.find(p => p.code === preferenceCode);
                if (preferenceObj) {
                    totalPrice += preferenceObj.price;
                }
            });
        }

        const newApplication = await GroomingApplication.create({
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
        console.error(err);
        return res.status(500).json({
            ...statuses['500'],
            message: 'Something went wrong while creating the grooming application.',
        });
    }
};

export const getGroomingApplications = async (req: TRequest, res: Response): Promise<any> => {
    try {
        const status = req.query.status as string;
        const groomingApplications = await GroomingApplication.find({
            user: req.user.id,
            status: status || 'pending'
        })
            .sort({ createdAt: -1 })
            .populate('pet')
            .populate('branch');

        // Map the applications to include the full objects instead of just codes
        const mappedApplications = groomingApplications.map(application => {
            const applicationObj = application.toObject();

            // Map scheduleCode to schedule object
            const scheduleObj = groomingServiceSchedules.find(schedule =>
                schedule.code === applicationObj.scheduleCode
            );

            // Map groomingOptions codes to full objects
            const groomingOptionsObjects = applicationObj.groomingOptions?.map(optionCode =>
                groomingOptions.find(option => option.code === optionCode)
            ).filter(Boolean) || [];

            // Map groomingPreferences codes to full objects
            const groomingPreferencesObjects = applicationObj.groomingPreferences?.map(preferenceCode =>
                groomingPreferences.find(preference => preference.code === preferenceCode)
            ).filter(Boolean) || [];

            const { scheduleCode, ...restApplicationObj } = applicationObj;
            return {
                ...restApplicationObj,
                schedule: scheduleObj,
                groomingOptions: groomingOptionsObjects,
                groomingPreferences: groomingPreferencesObjects
            };
        });

        return res.status(200).json(mappedApplications);
    } catch (error) {
        console.log('@getGroomingApplications error', error);
        return handleMongooseError(error, res);
    }
};
