import { createClient } from 'redis';
import { colors } from '../../const/common.const';

const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379'; // Use env variable

const redisClient = createClient({
  url: redisUrl,
});

redisClient.on('error', (err) => {
  console.error('Redis error:', err);
});

redisClient.on('connect', () => {
  console.log(`${colors.fg.cyan}[application] @connectRedisDb Redis connection success.`);
});

export const connectRedisDb = async () => {
  try {
    await redisClient.connect();
  } catch (err) {
    console.error('Redis connection error:', err);
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('Closing Redis connection...');
  await redisClient.quit();
  process.exit(0);
});

export default redisClient;