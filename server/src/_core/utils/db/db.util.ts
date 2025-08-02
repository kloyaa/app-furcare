import mongoose from 'mongoose';
import { getEnv } from '../../config/env.config';
import { colors } from '../../const/common.const';

export const connectDB = async () => {
  try {
    const env = await getEnv();
    if (env?.DB_CONNECTION_STRING) {
      await mongoose.connect(env?.DB_CONNECTION_STRING);
      console.log(`${colors.fg.cyan}[application] @connectDB Database connection success.`);
      return;
    }
    throw new Error(`${colors.fg.red}[application] Missing connection string.`);
  } catch (error) {
    console.error(`${colors.fg.red}[application] @connectDB `, error);
    process.exit(1);
  }
};

export const closeDB = async () => {
  try {
    await mongoose.disconnect();
    console.log(`${colors.fg.cyan}[application] @closeDB Database connection closed.`);
  } catch (error) {
    console.error(`${colors.fg.red}[application] @closeDB Error closing database connection:`, error);
    process.exit(1); // Optionally exit process if closing fails
  }
};
