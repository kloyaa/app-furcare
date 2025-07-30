import { Request } from 'express-jwt';

export type TRequest = Request & {
  user: {
    origin: string;
    id: string;
  };
  from: string;
};
