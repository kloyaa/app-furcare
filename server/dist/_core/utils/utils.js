"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateRandomNumber = exports.delay = exports.generateUsername = exports.generatePassword = exports.formatDate = exports.isEmpty = void 0;
const dayjs_1 = __importDefault(require("dayjs"));
const text_const_1 = require("../const/text.const");
const isEmpty = (value) => {
    if (value === null || value === undefined) {
        return true;
    }
    if (Array.isArray(value)) {
        return value.length === 0;
    }
    if (typeof value === 'string') {
        return value.trim().length === 0;
    }
    return false;
};
exports.isEmpty = isEmpty;
const formatDate = (date) => {
    return (0, dayjs_1.default)(date).format('MMM D, YYYY; hh:mm A');
};
exports.formatDate = formatDate;
const generatePassword = (length) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*_+.';
    let password = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * chars.length);
        password += chars[randomIndex];
    }
    return password;
};
exports.generatePassword = generatePassword;
const generateUsername = () => {
    const randomAdjective = text_const_1.adjectives[Math.floor(Math.random() * text_const_1.adjectives.length)];
    const randomNoun = text_const_1.nouns[Math.floor(Math.random() * text_const_1.nouns.length)];
    const randomNumber = Math.floor(Math.random() * 10000);
    return `${randomAdjective}${randomNoun}${randomNumber}`;
};
exports.generateUsername = generateUsername;
const delay = (ms) => {
    console.log(`Delay started ${ms}`);
    return new Promise(resolve => setTimeout(resolve, ms));
};
exports.delay = delay;
const generateRandomNumber = (length) => {
    if (length <= 0)
        return '';
    return Array.from({ length }, () => Math.floor(Math.random() * 10)).join('');
};
exports.generateRandomNumber = generateRandomNumber;
