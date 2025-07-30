import { NextFunction, type Response, type Request } from 'express';
import { formatDate } from '../utils/utils';
import { colors } from '../const/common.const';

/**
 * Sets the 'x-nodex-datetime' header in the response to the current date and time in ISO format.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
export const setDefaultDateTime = (req: Request, res: Response, next: NextFunction): void => {
  res.setHeader('x-nodex-datetime', new Date().toISOString());
  next();
};

/**
 * Logs the network request details and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
export const logNetworkRequests = (req: Request, res: Response, next: NextFunction): void => {
  console.log(
    `${colors.fg.yellow}[endpoint] ${req.method} ${req.originalUrl} - ${formatDate(new Date())} ${colors.fg.white}`,
  );
  next();
};

/**
 * Logs the network request headers and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
export const logNetworkHeaders = (req: Request, res: Response, next: NextFunction): void => {
  console.log(`${colors.fg.green}--> headers ${colors.fg.white}`);
  console.log(req.headers);
  next();
};

/**
 * Logs the network request body and calls the next middleware function.
 *
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the chain.
 * @return {void} This function does not return anything.
 */
export const logNetworBody = (req: Request, res: Response, next: NextFunction): void => {
  console.log(`${colors.fg.green}--> body ${colors.fg.white}`);
  console.log(req.body);
  next();
};
