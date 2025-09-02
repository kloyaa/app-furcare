"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deletePet = exports.getPets = exports.updatePet = exports.createPet = void 0;
const pet_schema_1 = __importDefault(require("../schema/pet.schema"));
const api_statuses_1 = require("../_core/const/api.statuses");
const pet_validator_1 = require("../_core/validators/pet.validator");
const activity_event_1 = require("../_core/events/activity.event");
const activity_enum_1 = require("../_core/enum/activity.enum");
const mongoose_1 = require("mongoose");
const error_util_1 = require("../_core/utils/db/error.util");
/**
 * Creates a new pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves when the pet is created successfully or rejects with an error.
 */
const createPet = async (req, res) => {
    const error = (0, pet_validator_1.validateCreatePet)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const pet = await pet_schema_1.default.findOne({
            name: { $regex: new RegExp(`^${req.body.name}$`, 'i') },
        });
        if (pet) {
            return res.status(400).json(api_statuses_1.statuses['0200']);
        }
        const createdPet = await pet_schema_1.default.create({
            ...req.body,
            user: req.user.id,
        });
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PET_ADDED,
        });
        return res.status(201).json(createdPet);
    }
    catch (error) {
        console.log('@createPet error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.createPet = createPet;
/**
 * Updates an existing pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's updated data.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves when the pet is updated successfully or rejects with an error.
 */
const updatePet = async (req, res) => {
    const { id } = req.params;
    if (!id || !(0, mongoose_1.isObjectIdOrHexString)(id)) {
        return res.status(400).json(api_statuses_1.statuses['0901']);
    }
    const error = (0, pet_validator_1.validateCreatePet)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const updatedPet = await pet_schema_1.default.findByIdAndUpdate(id, req.body, { new: true });
        if (!updatedPet) {
            return res.status(404).json(api_statuses_1.statuses['02']);
        }
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PET_UPDATED,
        });
        return res.status(200).json(updatedPet);
    }
    catch (error) {
        console.log('@updatePet error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.updatePet = updatePet;
/**
 * Retrieves all pets associated with the authenticated user.
 *
 * @param {TRequest} req - The request object containing the user's access token.
 * @param {Response} res - The response object used to send the list of pets.
 * @return {Promise<any>} A promise that resolves with a 200 status and the list of pets if successful,
 *                        or rejects with a 400 status in case of an error.
 */
const getPets = async (req, res) => {
    try {
        const pets = await pet_schema_1.default.find({ user: req.user.id }).sort({ createdAt: -1 });
        return res.status(200).json(pets);
    }
    catch (error) {
        console.log('@getPets error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.getPets = getPets;
/**
 * Deletes an existing pet for a user.
 *
 * @param {TRequest} req - The request object containing the pet's id as a parameter.
 * @param {Response} res - The response object used to send the response.
 * @return {Promise<any>} A promise that resolves with a 200 status when the pet is deleted successfully or rejects with a 400 status when there is an error.
 */
const deletePet = async (req, res) => {
    const { id } = req.params;
    if (!id || !(0, mongoose_1.isObjectIdOrHexString)(id)) {
        return res.status(400).json(api_statuses_1.statuses['0901']);
    }
    try {
        const deletedPet = await pet_schema_1.default.findByIdAndDelete(id);
        if (!deletedPet) {
            return res.status(404).json(api_statuses_1.statuses['02']);
        }
        activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
            user: req.user.id,
            description: activity_enum_1.ActivityType.PET_DELETED,
        });
        return res.status(200).json(api_statuses_1.statuses['00']);
    }
    catch (error) {
        console.log('@deletePet error', error);
        return (0, error_util_1.handleMongooseError)(error, res);
    }
};
exports.deletePet = deletePet;
