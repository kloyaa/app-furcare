import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

// Swagger configuration
const swaggerOptions = {
  definition: {
    openapi: '3.0.0', // OpenAPI version
    info: {
      title: 'Nodex API', // API title
      version: '1.0.0', // API version
      description: 'A Nodejs Express and MongoDB boilerplate',
    },
    servers: [
      {
        url: 'http://localhost:3432', // Base URL
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/routes/*.ts'], // Path to your API docs
};

const swaggerDocs = swaggerJsdoc(swaggerOptions);

export const swaggerSetup = (app: any) => {
  app.use(
    '/api-docs',
    swaggerUi.serve,
    swaggerUi.setup(swaggerDocs, {
      customCss: '.swagger-ui .topbar { display: none }',
      explorer: true,
    }),
  );
};
