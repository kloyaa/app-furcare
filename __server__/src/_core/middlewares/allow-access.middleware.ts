import { NextFunction, type Response, type Request } from 'express';
import { isEmpty } from '../utils/utils';
import { statuses } from '../const/api.statuses';
import { getEnv } from '../config/env.config';

/**
 * Middleware function that allows API access based on the provided access key, secret key, and user origin.
 *
 * @param {Request} req - The request object.
 * @param {Response} res - The response object.
 * @param {NextFunction} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
export const allowApiAccessMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void | Response> => {
  const accessKey = req.headers['nodex-access-key'];
  const secretKey = req.headers['nodex-secret-key'];
  const userOrigin = req.headers['nodex-user-origin'];

  if (req.path.includes('api-docs')) {
    return next();
  }
  if (isEmpty(accessKey) || isEmpty(secretKey) || isEmpty(userOrigin)) {
    return res.status(403).json(statuses['0060']);
  }

  const env = await getEnv();
  if (accessKey?.toString().trim() === env.NODEX_ACCESS_KEY && secretKey?.toString().trim() === env.NODEX_SECRET_KEY) {
    next();
  } else {
    return res.status(403).json(statuses['0070']);
  }
};
