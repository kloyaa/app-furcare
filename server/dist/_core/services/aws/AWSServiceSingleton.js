"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AWSServiceSingleton = void 0;
const AWSService_1 = require("./AWSService");
class AWSServiceSingleton {
    static getInstance(config) {
        if (!AWSServiceSingleton.instance) {
            if (!config) {
                throw new Error('AWS config required for first initialization');
            }
            AWSServiceSingleton.instance = new AWSService_1.AWSService(config);
        }
        return AWSServiceSingleton.instance;
    }
}
exports.AWSServiceSingleton = AWSServiceSingleton;
