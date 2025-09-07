import { type Response } from 'express';
import { TRequest } from '../_core/interfaces/overrides.interface';
import Activity from '../schema/Activity.schema';

/**
 *   * Retrieves the activity log and returns it as a JSON response.
 *
 * @param {TRequest} req - The request object containing the uploaded files.
 * @param {Response} res - The response object used to send the JSON response.
 * @return {Promise<void | Response>} A promise that resolves to the JSON response containing the activity log
 */
export const getActivity = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  const activities = await Activity.find({ user: req.user.id }).sort({
    createdAt: -1,
  });

  return res.status(200).json(activities);
};
