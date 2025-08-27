"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const upload_controller_1 = require("../controllers/upload.controller");
const jwt_middleware_1 = require("../_core/middlewares/jwt.middleware");
const router = (0, express_1.Router)();
const commonMiddlewares = [jwt_middleware_1.isAuthenticated];
router.post('/upload/v1/image', upload_controller_1.uploadImage);
exports.default = router;
