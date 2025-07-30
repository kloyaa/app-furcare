import jwt from 'jsonwebtoken';
import { getEnv } from '../../config/env.config';
import { JwtExpiration } from '../../const/jwt.const';

export const generateJwt = async (value: any, secretKey: string) => {
  return jwt.sign({ value }, secretKey, { expiresIn: JwtExpiration.ACCESS_TOKEN });
};
