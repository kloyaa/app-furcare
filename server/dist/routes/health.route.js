"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const mongoose_1 = __importDefault(require("mongoose"));
const router = (0, express_1.Router)();
router.get('', async (_, res) => {
    const database = await mongoose_1.default.connection.db.admin().ping();
    return res.status(200).json({
        database
    });
});
exports.default = router;
