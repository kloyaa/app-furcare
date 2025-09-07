import { TRequest, TResponse } from '../_core/interfaces/overrides.interface';
import {
  generatePassword as generatePword,
  generateUsername as generateUsrname,
} from '../_core/utils/utils';
import { statuses } from '../_core/const/api.statuses';

export const generatePassword = (req: TRequest, res: TResponse): any => {
  return res.status(200).json({
    ...statuses['00'],
    password: generatePword(Number(req.query.length) || 8),
  });
};

export const generateUsername = (req: TRequest, res: TResponse): any => {
  return res.status(200).json({
    ...statuses['00'],
    username: generateUsrname(),
  });
};
