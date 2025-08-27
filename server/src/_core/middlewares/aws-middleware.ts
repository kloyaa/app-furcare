import { Request, Response, NextFunction } from 'express';
import { AWSConfig } from '../interfaces/aws.interface';
import { AWSServiceSingleton } from '../services/aws/AWSServiceSingleton';
import { AWSService } from '../services/aws/AWSService';

declare global {
  namespace Express {
    interface Request {
      aws: AWSService;
    }
  }
}

export function awsMiddleware(config: AWSConfig) {
  return (req: Request, res: Response, next: NextFunction) => {
    req.aws = AWSServiceSingleton.getInstance(config);
    next();
  };
}
