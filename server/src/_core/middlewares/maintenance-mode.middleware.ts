import { getEnv } from '../config/env.config';
import { statuses } from '../const/api.statuses';

/**
 * Middleware function that checks if the application is in maintenance mode.
 *
 * @param {any} req - The request object.
 * @param {any} res - The response object.
 * @param {any} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
export const maintenanceModeMiddleware = async (req: any, res: any, next: any): Promise<void | Response> => {
  const env = await getEnv();
  if (env?.ENVIRONMENT_MAINTENANCE === 'true') {
    return res.status(500).json(statuses['500']);
  }
  next();
};
