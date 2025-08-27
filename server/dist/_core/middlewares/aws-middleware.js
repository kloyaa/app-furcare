"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.awsMiddleware = awsMiddleware;
const AWSServiceSingleton_1 = require("../services/aws/AWSServiceSingleton");
function awsMiddleware(config) {
    return (req, res, next) => {
        req.aws = AWSServiceSingleton_1.AWSServiceSingleton.getInstance(config);
        next();
    };
}
