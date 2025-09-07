import { type Request } from 'express-jwt';
import { type Response } from 'express';

export type TRequest = Request & {
  user: {
    origin: string;
    id: string;
  };
  from: string;
};

export type TResponse = Response;
