"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateJwt = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const jwt_const_1 = require("../../const/jwt.const");
const generateJwt = async (value, secretKey) => {
    return jsonwebtoken_1.default.sign({ value }, secretKey, { expiresIn: jwt_const_1.JwtExpiration.ACCESS_TOKEN });
};
exports.generateJwt = generateJwt;
