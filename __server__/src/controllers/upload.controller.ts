import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';

/**
 * Uploads an image and returns the uploaded files as a JSON response.
 *
 * @param {TRequest} req - The request object containing the uploaded files.
 * @param {Response} res - The response object used to send the JSON response.
 * @return {Promise<void | Response>} A promise that resolves to the JSON response containing the uploaded files.
 */
export const uploadImage = async (req: TRequest, res: Response): Promise<any> => {
  const { files } = req;
  return res.status(200).json(files);
};
