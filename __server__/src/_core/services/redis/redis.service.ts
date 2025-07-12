import { IGetPayload, IGetResponse, ISetPayload, ISetResponse } from '../../interfaces';
import redisClient from './redis-client.service';

export const setLocalStorage = async <T>(payload: ISetPayload<T>): Promise<ISetResponse<void>> => {
  const { key, value } = payload;

  try {
    await redisClient.set(key, JSON.stringify(value)); // Store value as JSON string
    return {
      success: true,
      message: `Value for ${key} set successfully.`,
    };
  } catch (err) {
    return {
      success: false,
      message: 'Error setting value in Redis',
    };
  }
};

export const getLocalStorage = async <T>(payload: IGetPayload): Promise<IGetResponse<T | null>> => {
  const { key } = payload;

  try {
    const value = await redisClient.get(key);

    if (value !== null) {
      return {
        success: true,
        message: `Value for ${key} retrieved successfully.`,
        data: JSON.parse(value) as T, // Parse JSON string to desired type
      };
    } else {
      return {
        success: false,
        message: `No value found for ${key}`,
      };
    }
  } catch (err) {
    return {
      success: false,
      message: 'Error retrieving value from Redis',
    };
  }
};
