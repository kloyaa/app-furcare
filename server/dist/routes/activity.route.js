"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const activity_controller_1 = require("../controllers/activity.controller");
const jwt_middleware_1 = require("../_core/middlewares/jwt.middleware");
const router = (0, express_1.Router)();
const commonMiddlewares = [jwt_middleware_1.isAuthenticated];
router.get('/activity/v1', commonMiddlewares, activity_controller_1.getActivity);
exports.default = router;
