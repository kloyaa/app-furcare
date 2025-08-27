"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const multer_1 = __importDefault(require("multer"));
const swagger_ui_express_1 = __importDefault(require("swagger-ui-express"));
const db_util_1 = require("./_core/utils/db/db.util");
const env_config_1 = require("./_core/config/env.config");
const maintenance_mode_middleware_1 = require("./_core/middlewares/maintenance-mode.middleware");
const request_logger_middleware_1 = require("./_core/middlewares/request-logger.middleware");
const allow_access_middleware_1 = require("./_core/middlewares/allow-access.middleware");
const image_upload_service_1 = require("./_core/services/upload/image_upload.service");
const auth_route_1 = __importDefault(require("./routes/auth.route"));
const user_route_1 = __importDefault(require("./routes/user.route"));
const upload_route_1 = __importDefault(require("./routes/upload.route"));
const auxiliary_route_1 = __importDefault(require("./routes/auxiliary.route"));
const activity_route_1 = __importDefault(require("./routes/activity.route"));
const pet_services_route_1 = __importDefault(require("./routes/pet_services.route"));
const pet_route_1 = __importDefault(require("./routes/pet.route"));
const application_route_1 = __importDefault(require("./routes/application.route"));
const branch_route_1 = __importDefault(require("./routes/branch.route"));
const health_route_1 = __importDefault(require("./routes/health.route"));
const default_middleware_1 = require("./_core/middlewares/default.middleware");
const common_const_1 = require("./_core/const/common.const");
// import { swaggerSetup } from './swagger/swagger';
const swagger_json_1 = __importDefault(require("./swagger/swagger.json"));
const utils_1 = require("./_core/utils/utils");
const app = (0, express_1.default)();
const swaggerOptions = {
    explorer: true,
};
/**
 * Runs the application by setting up middleware and routes, connecting to MongoDB, and starting the HTTPS server.
 *
 * @return {Promise<void>} A promise that resolves when the application has started.
 */
async function runApp() {
    const env = await (0, env_config_1.getEnv)();
    app.get('/', health_route_1.default);
    // Middleware
    app.use((0, helmet_1.default)()); // Apply standard security headers
    app.use((0, cors_1.default)({
        exposedHeaders: ['X-Nodex-DateTime'],
    }));
    app.use(express_1.default.urlencoded({ extended: true }));
    app.use(express_1.default.json());
    app.use(default_middleware_1.setDefaultDateTime);
    app.use(request_logger_middleware_1.requestLoggerMiddleware);
    app.use((0, multer_1.default)({ storage: image_upload_service_1.storage, fileFilter: image_upload_service_1.fileFilter }).array('media'));
    app.use(allow_access_middleware_1.allowApiAccessMiddleware);
    app.use(maintenance_mode_middleware_1.maintenanceModeMiddleware);
    app.use(default_middleware_1.logNetworkRequests);
    app.use(default_middleware_1.logNetworkHeaders);
    app.use(default_middleware_1.logNetworBody);
    // delay route
    app.use(async (req, res, next) => {
        await (0, utils_1.delay)(1_500);
        next();
    });
    // Routes
    app.use('/api', auth_route_1.default);
    app.use('/api', user_route_1.default);
    app.use('/api', upload_route_1.default);
    app.use('/api', auxiliary_route_1.default);
    app.use('/api', activity_route_1.default);
    app.use('/api', pet_services_route_1.default);
    app.use('/api', pet_route_1.default);
    app.use('/api', application_route_1.default);
    app.use('/api', branch_route_1.default);
    // Swagger setup
    app.use("/api-docs", swagger_ui_express_1.default.serve);
    app.use("/api-docs", swagger_ui_express_1.default.setup(swagger_json_1.default, swaggerOptions));
    // Connect to MongoDB
    (0, db_util_1.connectDB)();
    // Connect to Redis
    // connectRedisDb()
    // Start the HTTPS server
    app.listen(Number(env?.PORT) || 5000, () => {
        console.log(`${common_const_1.colors.fg.cyan}[application] @environment `, env?.ENVIRONMENT);
        console.log(`${common_const_1.colors.fg.cyan}[application] @port `, Number(env?.PORT));
        console.log(`${common_const_1.colors.fg.cyan}[application] @url `, `http://localhost:${Number(env?.PORT)}`);
    });
}
runApp();
