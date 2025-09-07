"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const mongoose_1 = __importDefault(require("mongoose"));
const app_schema_1 = __importDefault(require("../schema/app.schema"));
const router = (0, express_1.Router)();
router.get('', async (_, res) => {
    const database = await mongoose_1.default.connection.db?.admin().ping();
    const application = await app_schema_1.default.find();
    return res.status(200).json({
        database: database?.ok === 1 ? true : false,
        isUnderMaintenance: application[0].isUnderMaintenance || true,
    });
});
exports.default = router;
