"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadImage = void 0;
/**
 * Uploads an image and returns the uploaded files as a JSON response.
 *
 * @param {TRequest} req - The request object containing the uploaded files.
 * @param {Response} res - The response object used to send the JSON response.
 * @return {Promise<void | Response>} A promise that resolves to the JSON response containing the uploaded files.
 */
const uploadImage = async (req, res) => {
    const { files } = req;
    return res.status(200).json(files);
};
exports.uploadImage = uploadImage;
