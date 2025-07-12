import jwt from 'jsonwebtoken';
import { statuses } from '../const/api.statuses';
import { getEnv } from '../config/env.config';
import { decrypt } from '../utils/security/encryption.util';
import { TRequest } from '../interfaces/overrides.interface';

/**
 * Middleware function that checks if the user is authenticated by verifying the JWT token in the request headers.
 *
 * @param {TRequest} req - The request object.
 * @param {any} res - The response object.
 * @param {any} next - The next function to be called.
 * @return {Promise<void | Response>} - Returns a Promise that resolves when the middleware is done.
 */
export const isAuthenticated = async (req: TRequest, res: any, next: any): Promise<void | Response> => {
  try {
    const authHeader = req.headers['authorization'];
    if (!authHeader) {
      return res.status(401).json(statuses['10020']);
    }

    const token = authHeader.split(' ')[1];
    if (!token) {
      return res.status(401).json(statuses['10020']);
    }

    const env = await getEnv();

    jwt.verify(token, env?.JWT_SECRET_KEY as string, (err: any, decoded: any) => {
      if (err) {
        return res.status(401).json(statuses['10020']);
      } else if (decoded) {
        const decryptedData: { origin: string; id: string } = decrypt(
          decoded.value,
          env.NODEX_CRYPTO_KEY ?? '123_cryptoKey',
        );
        if (!decryptedData) {
          return res.status(401).json(statuses['10020']);
        } else if (decryptedData?.origin !== req.headers['nodex-user-origin']) {
          return res.status(403).json(statuses['0059']);
        }
        req.user = decryptedData as any;
        next();
      }
    });
  } catch (error) {
    return res.status(401).json(statuses['10020']);
  }
};
