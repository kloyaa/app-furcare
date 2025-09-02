"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.connectRedisDb = void 0;
const redis_1 = require("redis");
const common_const_1 = require("../../const/common.const");
const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379'; // Use env variable
const redisClient = (0, redis_1.createClient)({
    url: redisUrl,
});
redisClient.on('error', err => {
    console.error('Redis error:', err);
});
redisClient.on('connect', () => {
    console.log(`${common_const_1.colors.fg.cyan}[application] @connectRedisDb Redis connection success.`);
});
const connectRedisDb = async () => {
    try {
        await redisClient.connect();
    }
    catch (err) {
        console.error('Redis connection error:', err);
    }
};
exports.connectRedisDb = connectRedisDb;
// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('Closing Redis connection...');
    await redisClient.quit();
    process.exit(0);
});
exports.default = redisClient;
