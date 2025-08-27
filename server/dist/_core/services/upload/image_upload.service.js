"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadImage = exports.storage = exports.fileFilter = void 0;
require('dotenv').config();
const cloudinary_1 = require("cloudinary");
const multer_1 = __importDefault(require("multer"));
const fs_1 = __importDefault(require("fs"));
cloudinary_1.v2.config({
    cloud_name: process.env.CLOUDINARY_NAME,
    api_key: process.env.CLOUDINARY_KEY,
    api_secret: process.env.CLOUDINARY_SECRET,
});
const fileFilter = (req, file, callback) => {
    if (file.mimetype === 'image/png' ||
        file.mimetype === 'image/jpg' ||
        file.mimetype === 'image/jpeg' ||
        file.mimetype === 'video/mp4') {
        callback(null, true);
    }
    else
        callback(null, false);
};
exports.fileFilter = fileFilter;
exports.storage = multer_1.default.diskStorage({});
const uploadImage = async (files, scope = 'temp') => {
    const cloudOptions = {
        folder: `Public/${process.env.CLOUDINARY_PROJECT_NAME}}/${scope}/uploads`,
        unique_filename: true,
    };
    const urls = [];
    if (files?.length > 1) {
        for (const file of files) {
            const { path } = file;
            const upload = await cloudinary_1.v2.uploader.upload(path, cloudOptions);
            urls.push(upload);
            fs_1.default.unlinkSync(path);
        }
        return urls;
    }
    for (const file of files) {
        const { path } = file;
        const upload = await cloudinary_1.v2.uploader.upload(path, cloudOptions);
        urls.push(upload);
        fs_1.default.unlinkSync(path);
        break;
    }
    return urls[0];
};
exports.uploadImage = uploadImage;
