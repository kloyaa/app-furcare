# Nodex - Node.js Boilerplate with TypeScript, Express.js, and MongoDB

"Nodex" is a versatile boilerplate for Node.js applications, offering a solid foundation for various project types, including web applications, RESTful APIs, and server-side applications. With "Nodex," you can kickstart your development process with confidence.

## Key Features

- **Image uploading with cloudinary:** Easily manage image uploads by integrating with Cloudinary, a powerful image and video management service. Upload, transform, and optimize images directly from your application, and leverage Cloudinary’s robust features for handling media files, such as automatic format conversion, resizing, and CDN delivery.
- **Redis cache:** Improve application performance and scalability by using Redis as an in-memory cache. Store frequently accessed data in Redis to reduce database load and latency. Redis caching helps speed up data retrieval operations, providing a more responsive user experience and efficiently managing high-traffic scenarios.
- **TypeScript Ready:** Benefit from strong typing and enhanced code quality with TypeScript.
- **Express.js Framework:** Utilize the popular Express.js framework for building robust web applications and APIs.
- **MongoDB Integration:** Seamlessly connect to MongoDB databases to efficiently store and retrieve data.
- **Modular Structure:** Organize your codebase with a modular structure, making it easy to maintain and scale.
- **Authentication and Authorization:** Implement user authentication and authorization using industry-standard practices.
- **Middleware Support:** Add custom middleware to handle authentication, logging, and more.
- **Environment Configuration:** Manage environment-specific configurations with ease.
- **Testing Ready:** Includes setup for unit testing and integration testing to ensure code reliability.
- **Error Handling:** Implement comprehensive error handling to enhance application stability.
- **Logging:** Incorporate logging mechanisms to monitor application activity.
- **API Documentation:** Generate API documentation for better communication with your team and users.
- **Docker Support:** Containerize your application for easy deployment and scaling.

## Getting Started

To start using "Nodex," follow these steps:

1. Clone this repository to your local machine.
2. Configure your environment variables using the provided `.env.example` file.
3. Run `npm install` to install the required dependencies.
4. Start building your Node.js application with all the features and advantages "Nodex" offers.

## Environment Variables

| Variable Name           | Description                    | Example Value        |
|-------------------------|--------------------------------|-----------------------|
| ENVIRONMENT             | The environment name           | Production            |
| ENVIRONMENT_MAINTENANCE | Indicates maintenance mode    | true                  |
| PORT                    | Port number for the application | 8080                  |
| DB_CONNECTION_STRING    | Database connection string     | mongodb://localhost   |
| AWS_ACCESS_KEY_ID       | AWS Access Key ID               | your-access-key-id    |
| AWS_SECRET_ACCESS_KEY   | AWS Secret Access Key           | your-secret-access-key |
| AWS_SECRET_NAME         | AWS Secret Name                 | your-secret-name      |
| JWT_EXPIRY              | JWT token expiration duration   | 1h                    |
| JWT_SECRET_KEY          | JWT secret key for token signing | your-secret-key      |
| NODEX_ACCESS_KEY          | Headers validation | your-nodex-key      |
| NODEX_SECRET_KEY          | Headers validation | your-nodex-key      |
| NODEX_CRYPTO_KEY          | Encryption secret key | your-nodex-key      |
| CLOUDINARY_NAME          | Cloudinary name | your-cld-name      |
| CLOUDINARY_KEY          | Cloudinary key | your-cld-key      |
| CLOUDINARY_SECRET          | Cloudinary secret key | your-cld-secret-key      |
| CLOUDINARY_PROJECT_NAME          | Cloudinary project name | your-cld-project-name      |
## Scripts

Run application locally
<pre> $ npm run start:local </pre>

Run seeds
<pre> $ npm run start:seeding </pre>

Run application using docker
<pre> 
    Running the Dockerfile
    $ docker build -t <name> . // build the docker image
    $ docker run -p 3000:3000 <name> // running the image
    $ docker run -p 3000:3000 --env-file <.env> <name>

    or 

    Running with docker-compose.yml
    $ docker-compose up -d  // up
    $ docker-compose down // down

    Running specific service
    $ docker-compose run <servicename>

    note: if there is changes that doesn't reflect
    $ docker build --no-cache -t <name> . 


    Running redis via Docker
    $ docker run -p 6379:6379 -it redis/redis-stack-server:latest
 </pre>

## Usage

Feel free to customize and extend "Nodex" to meet the specific requirements of your project. This boilerplate is designed to save you time during the initial setup, allowing you to focus on building the core functionality of your Node.js project.

## Contributing

Contributions are welcome! If you'd like to contribute to "Nodex," please follow our [contribution guidelines](CONTRIBUTING.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

# Author
Kolya Madridano <br/>
madridano.kolya@gmail.com
