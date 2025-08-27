import { Response } from 'express';
import { Error as MongooseError } from 'mongoose';
import { statuses } from '../../const/api.statuses';

export function handleMongooseError(error: unknown, res: Response) {
  if (
    error instanceof MongooseError &&
    'message' in error &&
    typeof error.message === 'string' &&
    error.message.includes('buffering timed out')
  ) {
    return res.status(500).json({
      ...statuses['0900'],
      message: 'Database connection error. Please try again shortly.',
    });
  }
  if (
    error instanceof MongooseError.CastError ||
    error instanceof MongooseError.ValidationError
  ) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.message,
    });
  }
  return res.status(400).json(statuses['0900']);
}
