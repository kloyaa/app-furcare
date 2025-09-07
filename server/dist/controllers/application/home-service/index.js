"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getHomeServiceApplications = exports.createHomeServiceApplication = void 0;
const api_statuses_1 = require("../../../_core/const/api.statuses");
const activity_enum_1 = require("../../../_core/enum/activity.enum");
const activity_event_1 = require("../../../_core/events/activity.event");
const error_util_1 = require("../../../_core/utils/db/error.util");
const utils_1 = require("../../../_core/utils/utils");
const application_validator_1 = require("../../../_core/validators/application.validator");
const HomeServiceApplication_schema_1 = require("../../../schema/application/HomeServiceApplication.schema");
const branch_schema_1 = __importDefault(require("../../../schema/branch.schema"));
const pet_schema_1 = __importDefault(require("../../../schema/pet.schema"));
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
            branch_schema_1.default.findById(branch),
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
        await HomeServiceApplication_schema_1.HomeServiceApplication.create({
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
const getHomeServiceApplications = async (req, res) => {
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
        const homeServiceApplications = await HomeServiceApplication_schema_1.HomeServiceApplication.find(query)
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
