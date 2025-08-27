"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getHomeServiceApplications = exports.getBoardingApplications = exports.getGroomingApplications = exports.createHomeServiceApplication = exports.createBoardingApplication = exports.createGroomingApplication = void 0;
const api_statuses_1 = require("../_core/const/api.statuses");
const application_validator_1 = require("../_core/validators/application.validator");
const application_schema_1 = require("../schema/application.schema");
const activity_event_1 = require("../_core/events/activity.event");
const activity_enum_1 = require("../_core/enum/activity.enum");
const branch_schema_1 = require("../schema/branch.schema");
const pet_schema_1 = __importDefault(require("../schema/pet.schema"));
const error_util_1 = require("../_core/utils/db/error.util");
const pet_srvices_const_1 = require("../_core/const/pet_srvices.const");
const pet_services_schema_1 = __importDefault(require("../schema/pet_services.schema"));
const createGroomingApplication = async (req, res) => {
    const error = (0, application_validator_1.validateCreateGroomingApplication)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { pet, branch, scheduleCode, groomingOptions: selectedOptions, groomingPreferences: selectedPreferences, hasAllergy, isOnMedication, hasAntiRabbiesVaccination, } = req.body;
        const [findPet, findBranch] = await Promise.all([
            pet_schema_1.default.findById(pet),
            branch_schema_1.Branch.findById(branch),
        ]);
        if (!findBranch) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Branch not found.'
            });
        }
        if (!findPet) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Pet not found.'
            });
        }
        // Calculate total price server-side
        let totalPrice = 0;
        // Add schedule price
        const schedule = pet_srvices_const_1.groomingServiceSchedules.find(s => s.code === scheduleCode);
        if (schedule) {
            totalPrice += schedule.price;
        }
        // Add grooming options prices (from request body codes)
        if (selectedOptions && selectedOptions.length > 0) {
            selectedOptions.forEach((optionCode) => {
                const optionObj = pet_srvices_const_1.groomingOptions.find(o => o.code === optionCode);
                if (optionObj) {
                    totalPrice += optionObj.price;
                }
            });
        }
        // Add grooming preferences prices (from request body codes)
        if (selectedPreferences && selectedPreferences.length > 0) {
            selectedPreferences.forEach((preferenceCode) => {
                const preferenceObj = pet_srvices_const_1.groomingPreferences.find(p => p.code === preferenceCode);
                if (preferenceObj) {
                    totalPrice += preferenceObj.price;
                }
            });
        }
        await application_schema_1.GroomingApplication.create({
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
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.APPLICATION_GROOMING_SUBMITTED,
        });
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (err) {
        console.log('@createGroomingApplication error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.createGroomingApplication = createGroomingApplication;
const createBoardingApplication = async (req, res) => {
    const error = (0, application_validator_1.validateCreateBoardingApplication)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { pet, branch, cage, schedule } = req.body;
        const [findPet, findBranch, findCage] = await Promise.all([
            pet_schema_1.default.findById(pet),
            branch_schema_1.Branch.findById(branch),
            pet_services_schema_1.default.findById(cage)
        ]);
        if (!findBranch) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Branch not found.'
            });
        }
        if (!findPet) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Pet not found.'
            });
        }
        if (!findCage) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Cage not found.'
            });
        }
        await application_schema_1.BoardingApplication.create({
            ...req.body,
            user: req.user.id,
            branch,
            pet,
            schedule,
            totalPrice: findCage.price * schedule.days,
            status: 'pending',
        });
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.APPLICATION_BOARDING_SUBMITTED,
        });
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (err) {
        console.log('@createBoardingApplication error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.createBoardingApplication = createBoardingApplication;
const createHomeServiceApplication = async (req, res) => {
    const error = (0, application_validator_1.validateCreateHomeServiceApplication)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { pet, branch, schedule } = req.body;
        const [findPet, findBranch] = await Promise.all([
            pet_schema_1.default.findById(pet),
            branch_schema_1.Branch.findById(branch),
        ]);
        if (!findBranch) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Branch not found.'
            });
        }
        if (!findPet) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Pet not found.'
            });
        }
        await application_schema_1.HomeServiceApplication.create({
            user: req.user.id,
            branch,
            pet,
            schedule,
            status: 'pending',
        });
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.APPLICATION_HOME_SERVICE_SUBMITTED,
        });
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (err) {
        console.log('@createHomeServiceApplication error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.createHomeServiceApplication = createHomeServiceApplication;
const getGroomingApplications = async (req, res) => {
    try {
        const status = req.query.status;
        const groomingApplications = await application_schema_1.GroomingApplication.find({
            user: req.user.id,
            status: status || 'pending'
        })
            .sort({ createdAt: -1 })
            .populate('pet')
            .populate('branch');
        const mappedApplications = groomingApplications.map(application => {
            const applicationObj = application.toObject();
            const scheduleObj = pet_srvices_const_1.groomingServiceSchedules.find(schedule => schedule.code === applicationObj.scheduleCode);
            const groomingOptionsObjects = applicationObj.groomingOptions?.map(optionCode => pet_srvices_const_1.groomingOptions.find(option => option.code === optionCode)).filter(Boolean) || [];
            const groomingPreferencesObjects = applicationObj.groomingPreferences?.map(preferenceCode => pet_srvices_const_1.groomingPreferences.find(preference => preference.code === preferenceCode)).filter(Boolean) || [];
            const { scheduleCode, ...restApplicationObj } = applicationObj;
            return {
                ...restApplicationObj,
                schedule: scheduleObj,
                groomingOptions: groomingOptionsObjects,
                groomingPreferences: groomingPreferencesObjects
            };
        });
        return res.status(200).json(mappedApplications);
    }
    catch (error) {
        console.log('@getGroomingApplications error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getGroomingApplications = getGroomingApplications;
const getBoardingApplications = async (req, res) => {
    try {
        const status = req.query.status;
        const boardingApplications = await application_schema_1.BoardingApplication.find({
            user: req.user.id,
            status: status || 'pending'
        })
            .sort({ createdAt: -1 })
            .populate('pet')
            .populate('branch')
            .populate('cage');
        return res.status(200).json(boardingApplications);
    }
    catch (error) {
        console.log('@getBoardingApplications error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getBoardingApplications = getBoardingApplications;
const getHomeServiceApplications = async (req, res) => {
    try {
        const status = req.query.status;
        const homeServiceApplications = await application_schema_1.HomeServiceApplication.find({
            user: req.user.id,
            status: status || 'pending'
        })
            .sort({ createdAt: -1 })
            .populate('pet')
            .populate('branch');
        return res.status(200).json(homeServiceApplications);
    }
    catch (error) {
        console.log('@getGroomingApplications error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getHomeServiceApplications = getHomeServiceApplications;
