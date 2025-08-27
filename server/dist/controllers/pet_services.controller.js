"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateCageAvailability = exports.updateCageOccupant = exports.getAllCages = exports.insertCages = exports.getGroomingExtra = exports.getGroomingPreferences = exports.getGroomingSchedules = exports.getPetServices = void 0;
const pet_srvices_const_1 = require("../_core/const/pet_srvices.const");
const pet_services_schema_1 = __importDefault(require("../schema/pet_services.schema"));
const api_statuses_1 = require("../_core/const/api.statuses");
const error_util_1 = require("../_core/utils/db/error.util");
const pet_services_validator_1 = require("../_core/validators/pet_services.validator");
const mongoose_1 = require("mongoose");
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
const getPetServices = async (req, res) => {
    return res.status(200).json(pet_srvices_const_1.petServices);
};
exports.getPetServices = getPetServices;
/**
 * @description Get all available grooming schedules
 * @route GET /pet/grooming/schedules
 * @header Authorization: Bearer [token]
 * @response 200 GroomingSchedule[]
 * @responseProperty {string} schedule - Schedule of the grooming service in 12-hour format
 * @responseProperty {number} price - Price of the grooming service
 * @responseProperty {boolean} available - Whether the grooming service is available or not
 */
const getGroomingSchedules = async (req, res) => {
    return res.status(200).json(pet_srvices_const_1.groomingServiceSchedules);
};
exports.getGroomingSchedules = getGroomingSchedules;
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
const getGroomingPreferences = async (req, res) => {
    return res.status(200).json(pet_srvices_const_1.groomingPreferences);
};
exports.getGroomingPreferences = getGroomingPreferences;
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
const getGroomingExtra = async (req, res) => {
    return res.status(200).json(pet_srvices_const_1.groomingOptions);
};
exports.getGroomingExtra = getGroomingExtra;
const insertCages = async (req, res) => {
    try {
        const cages = await pet_services_schema_1.default.find();
        if (cages.length > 0) {
            return res.status(400).json(api_statuses_1.statuses['03']);
        }
        await pet_services_schema_1.default.insertMany(pet_srvices_const_1.petCages);
        return res.status(201).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@insertCages error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.insertCages = insertCages;
const getAllCages = async (req, res) => {
    try {
        const cages = await pet_services_schema_1.default.find();
        return res.status(200).json(cages);
    }
    catch (error) {
        console.log('@getAllCages error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getAllCages = getAllCages;
const updateCageOccupant = async (req, res) => {
    const error = (0, pet_services_validator_1.validateUpdatePetCages)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    const { action, id } = req.body;
    try {
        const cage = await pet_services_schema_1.default.findById(id);
        if (!cage) {
            return res
                .status(404)
                .json(api_statuses_1.statuses['02']);
        }
        if (action === 'add') {
            if (cage.occupant >= cage.max) {
                return res
                    .status(400)
                    .json({
                    ...api_statuses_1.statuses['01'],
                    message: 'Cage is already full.'
                });
            }
            cage.occupant += 1;
        }
        else if (action === 'remove') {
            if (cage.occupant <= 0) {
                return res
                    .status(400)
                    .json({
                    ...api_statuses_1.statuses['01'],
                    message: 'Cage is already empty.'
                });
            }
            cage.occupant -= 1;
        }
        await cage.save();
        return res
            .status(200)
            .json({
            ...api_statuses_1.statuses['00'],
            message: 'Occupant updated successfully.'
        });
    }
    catch (error) {
        console.log('@updateCageOccupant error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.updateCageOccupant = updateCageOccupant;
const validateCageAvailability = async (req, res) => {
    try {
        const { id } = req.params;
        if (!(0, mongoose_1.isObjectIdOrHexString)(id)) {
            return res
                .status(400)
                .json(api_statuses_1.statuses['0901']);
        }
        const cage = await pet_services_schema_1.default.findById(id);
        if (!cage) {
            return res
                .status(404)
                .json(api_statuses_1.statuses['02']);
        }
        if (cage.occupant >= cage.max) {
            return res
                .status(400)
                .json({
                ...api_statuses_1.statuses['01'],
                message: 'Cage is already full.'
            });
        }
        return res
            .status(200)
            .json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@validateCageCapacity error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.validateCageAvailability = validateCageAvailability;
