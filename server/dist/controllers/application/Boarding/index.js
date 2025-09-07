"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getBoardingApplications = exports.createBoardingApplicationExtension = exports.createBoardingApplication = void 0;
const api_statuses_1 = require("../../../_core/const/api.statuses");
const activity_enum_1 = require("../../../_core/enum/activity.enum");
const activity_event_1 = require("../../../_core/events/activity.event");
const error_util_1 = require("../../../_core/utils/db/error.util");
const utils_1 = require("../../../_core/utils/utils");
const application_validator_1 = require("../../../_core/validators/application.validator");
const BoardingApplication_schema_1 = require("../../../schema/application/BoardingApplication.schema");
const branch_schema_1 = __importDefault(require("../../../schema/branch.schema"));
const pet_schema_1 = __importDefault(require("../../../schema/pet.schema"));
const pet_services_schema_1 = __importDefault(require("../../../schema/pet_services.schema"));
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
            branch_schema_1.default.findById(branch),
            pet_services_schema_1.default.findById(cage),
        ]);
        if (!findBranch) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Branch not found.',
            });
        }
        if (!findPet) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Pet not found.',
            });
        }
        if (!findCage) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Cage not found.',
            });
        }
        await BoardingApplication_schema_1.BoardingApplication.create({
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
const createBoardingApplicationExtension = async (req, res) => {
    const error = (0, application_validator_1.validateCreateBoardingApplicationExtension)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { application: id, count, type } = req.body;
        // Validate count parameter
        if (typeof count !== 'number' || count < 0) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
                message: 'Count must be a non-negative number.',
            });
        }
        const application = await BoardingApplication_schema_1.BoardingApplication.findById(id);
        if (!application) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Boarding application not found.',
            });
        }
        const cage = await pet_services_schema_1.default.findById(application.cage);
        if (!cage) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Associated cage not found.',
            });
        }
        // Initialize original values if this is the first extension
        const originalDays = application.schedule.originalDays || application.schedule.days;
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
                        ...api_statuses_1.statuses['501'],
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
                }
                else if (count < currentExtension) {
                    activityDescription = `Reduced boarding to ${count} additional day(s)`;
                }
                else {
                    activityDescription = `Boarding extension unchanged at ${count} day(s)`;
                }
                break;
        }
        // Validate that we don't go below the original booking days
        if (newTotalDays < originalDays) {
            return res.status(400).json({
                ...api_statuses_1.statuses['501'],
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
        const updateData = {
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
        const updatedApplication = await BoardingApplication_schema_1.BoardingApplication.findByIdAndUpdate(id, updateData, { new: true }).populate(['user', 'pet', 'cage', 'branch']);
        console.log('@createBoardingApplicationExtension updatedApplication', updatedApplication);
        // Emit activity with descriptive message
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activityDescription
        });
        return res.status(201).json({
            ...api_statuses_1.statuses['00'],
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
    }
    catch (err) {
        console.log('@createBoardingApplicationExtension error', err);
        return (0, error_util_1.handleMongooseError)(err, res);
    }
};
exports.createBoardingApplicationExtension = createBoardingApplicationExtension;
const getBoardingApplications = async (req, res) => {
    try {
        const status = req.query.status;
        let query = {
            user: req.user.id
        };
        if (!(0, utils_1.isEmpty)(status)) {
            query = {
                ...query,
                status
            };
        }
        const boardingApplications = await BoardingApplication_schema_1.BoardingApplication.find(query)
            .sort({ createdAt: -1 })
            .populate('pet')
            .populate('branch')
            .populate('cage');
        console.log('boardingApplications', boardingApplications.length);
        return res.status(200).json(boardingApplications);
    }
    catch (error) {
        console.log('@getBoardingApplications error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getBoardingApplications = getBoardingApplications;
