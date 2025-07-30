import { NextFunction, Response } from 'express';
import { statuses } from '../const/api.statuses';

/**
 * Middleware function that checks the 'from' header in the request to determine the user's origin.
 *
 * @param {any} req - The request object.
 * @param {Response} res - The response object.
 * @param {NextFunction} next - The next function to be called.
 * @return {void | Response} - This function does not return anything.
 */
export const checkUserOrigin = (req: any, res: Response, next: NextFunction): void | Response => {
  const from = req.headers['from'];
  if (from === 'mobile' || from === 'web') {
    req.from = from;
    next();
  } else {
    return res.status(403).json(statuses['0059']);
  }
};
