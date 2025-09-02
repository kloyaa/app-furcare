"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getActivity = void 0;
const activity_schema_1 = __importDefault(require("../schema/activity.schema"));
/**
 *   * Retrieves the activity log and returns it as a JSON response.
 *
 * @param {TRequest} req - The request object containing the uploaded files.
 * @param {Response} res - The response object used to send the JSON response.
 * @return {Promise<void | Response>} A promise that resolves to the JSON response containing the activity log
 */
const getActivity = async (req, res) => {
    const activities = await activity_schema_1.default.find({ user: req.user.id }).sort({
        createdAt: -1,
    });
    return res.status(200).json(activities);
};
exports.getActivity = getActivity;
