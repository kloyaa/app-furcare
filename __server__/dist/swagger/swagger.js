"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.swaggerSetup = void 0;
const swagger_jsdoc_1 = __importDefault(require("swagger-jsdoc"));
const swagger_ui_express_1 = __importDefault(require("swagger-ui-express"));
// Swagger configuration
const swaggerOptions = {
    definition: {
        openapi: '3.0.0',
        info: {
            title: 'Nodex API',
            version: '1.0.0',
            description: 'A Nodejs Express and MongoDB boilerplate',
        },
        servers: [
            {
                url: 'http://localhost:3432',
                description: 'Development server',
            },
        ],
    },
    apis: ['./src/routes/*.ts'], // Path to your API docs
};
const swaggerDocs = (0, swagger_jsdoc_1.default)(swaggerOptions);
const swaggerSetup = (app) => {
    app.use('/api-docs', swagger_ui_express_1.default.serve, swagger_ui_express_1.default.setup(swaggerDocs, {
        customCss: '.swagger-ui .topbar { display: none }',
        explorer: true,
    }));
};
exports.swaggerSetup = swaggerSetup;
