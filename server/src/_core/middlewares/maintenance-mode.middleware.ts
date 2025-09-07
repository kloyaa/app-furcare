import Application from '../../schema/app.schema';
import { statuses } from '../const/api.statuses';
import { TRequest, TResponse } from '../interfaces/overrides.interface';

/**
 * Middleware function that checks if the application is in maintenance mode.
 *
 * @param {any} req - The request object.
 * @param {any} res - The response object.
 * @param {any} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
export const maintenanceModeMiddleware = async (
  req: TRequest,
  res: TResponse,
  next: any
): Promise<any> => {
  const application = await Application.find();
  console.log('application', application);
  if (application[0].maintenance) {
    console.log(
      'application[0].isUnderMaintenance',
      application[0].maintenance
    );
    return res.status(500).json(statuses['500']);
  }
  next();
};
