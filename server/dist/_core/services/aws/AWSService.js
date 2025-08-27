"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AWSService = void 0;
const client_s3_1 = require("@aws-sdk/client-s3");
const client_dynamodb_1 = require("@aws-sdk/client-dynamodb");
const client_ses_1 = require("@aws-sdk/client-ses");
const client_secrets_manager_1 = require("@aws-sdk/client-secrets-manager");
const s3_request_presigner_1 = require("@aws-sdk/s3-request-presigner");
class AWSService {
    constructor(config) {
        this.config = config;
        const clientConfig = {
            region: config.region,
            ...(config.accessKeyId && config.secretAccessKey && {
                credentials: {
                    accessKeyId: config.accessKeyId,
                    secretAccessKey: config.secretAccessKey,
                    ...(config.sessionToken && { sessionToken: config.sessionToken })
                }
            })
        };
        this.s3Client = new client_s3_1.S3Client(clientConfig);
        this.dynamoClient = new client_dynamodb_1.DynamoDBClient(clientConfig);
        this.sesClient = new client_ses_1.SESClient(clientConfig);
        this.secretsManagerClient = new client_secrets_manager_1.SecretsManagerClient(clientConfig);
    }
    // S3 Methods
    // async uploadToS3(options: S3UploadOptions): Promise<{ location: string; etag: string }> {
    //     try {
    //         const command = new PutObjectCommand({
    //             Bucket: options.bucket,
    //             Key: options.key,
    //             Body: options.body,
    //             ContentType: options.contentType || 'application/octet-stream',
    //             ACL: options.acl || 'private',
    //             Metadata: options.metadata
    //         });
    //         const command = new ListBucketsCommand(
    //             {}
    //         );
    //         const result = await this.s3Client.send(command);
    //         return {
    //             location: `https://${options.bucket}.s3.${this.config.region}.amazonaws.com/${options.key}`,
    //             etag: result.ETag
    //         };
    //     } catch (error) {
    //         throw new Error(`S3 Upload failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    //     }
    // }
    async downloadFromS3(options) {
        try {
            const command = new client_s3_1.GetObjectCommand({
                Bucket: options.bucket,
                Key: options.key
            });
            const result = await this.s3Client.send(command);
            if (!result.Body) {
                throw new Error('No body in S3 response');
            }
            // Convert stream to buffer
            const chunks = [];
            const stream = result.Body;
            for await (const chunk of stream) {
                chunks.push(chunk);
            }
            return Buffer.concat(chunks);
        }
        catch (error) {
            throw new Error(`S3 Download failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async deleteFromS3(options) {
        try {
            const command = new client_s3_1.DeleteObjectCommand({
                Bucket: options.bucket,
                Key: options.key
            });
            await this.s3Client.send(command);
            return true;
        }
        catch (error) {
            throw new Error(`S3 Delete failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async listS3Objects(options) {
        try {
            const command = new client_s3_1.ListObjectsV2Command({
                Bucket: options.bucket,
                Prefix: options.prefix,
                MaxKeys: options.maxKeys || 1000,
                ContinuationToken: options.continuationToken
            });
            const result = await this.s3Client.send(command);
            return {
                objects: result.Contents || [],
                isTruncated: result.IsTruncated || false,
                nextContinuationToken: result.NextContinuationToken
            };
        }
        catch (error) {
            throw new Error(`S3 List failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async getS3ObjectInfo(options) {
        try {
            const command = new client_s3_1.HeadObjectCommand({
                Bucket: options.bucket,
                Key: options.key
            });
            const result = await this.s3Client.send(command);
            return {
                contentLength: result.ContentLength,
                contentType: result.ContentType,
                lastModified: result.LastModified,
                etag: result.ETag,
                metadata: result.Metadata
            };
        }
        catch (error) {
            throw new Error(`S3 Head Object failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async generatePresignedUrl(options, expiresIn = 3600) {
        try {
            const command = new client_s3_1.GetObjectCommand({
                Bucket: options.bucket,
                Key: options.key
            });
            return await (0, s3_request_presigner_1.getSignedUrl)(this.s3Client, command, { expiresIn });
        }
        catch (error) {
            throw new Error(`Presigned URL generation failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    // SES Methods
    async sendEmail(to, subject, body, from) {
        try {
            const command = new client_ses_1.SendEmailCommand({
                Source: from || process.env.AWS_SES_FROM_EMAIL,
                Destination: {
                    ToAddresses: to
                },
                Message: {
                    Subject: {
                        Data: subject,
                        Charset: 'UTF-8'
                    },
                    Body: {
                        Html: {
                            Data: body,
                            Charset: 'UTF-8'
                        }
                    }
                }
            });
            const result = await this.sesClient.send(command);
            return { messageId: result.MessageId };
        }
        catch (error) {
            throw new Error(`SES Send Email failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    // Secrets Manager Methods
    async getSecret(secretName) {
        try {
            const command = new client_secrets_manager_1.GetSecretValueCommand({
                SecretId: secretName
            });
            const result = await this.secretsManagerClient.send(command);
            if (!result.SecretString) {
                throw new Error('Secret value is empty or binary');
            }
            // Try to parse as JSON, if it fails return as string
            try {
                return JSON.parse(result.SecretString);
            }
            catch {
                return result.SecretString;
            }
        }
        catch (error) {
            throw new Error(`Get Secret failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async createSecret(options) {
        try {
            if (!options.secretValue) {
                throw new Error('Secret value is required for creation');
            }
            const secretString = typeof options.secretValue === 'string'
                ? options.secretValue
                : JSON.stringify(options.secretValue);
            const command = new client_secrets_manager_1.CreateSecretCommand({
                Name: options.secretName,
                SecretString: secretString,
                Description: options.description,
                KmsKeyId: options.kmsKeyId
            });
            const result = await this.secretsManagerClient.send(command);
            return {
                arn: result.ARN || '',
                name: result.Name || '',
                versionId: result.VersionId || ''
            };
        }
        catch (error) {
            throw new Error(`Create Secret failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async updateSecret(options) {
        try {
            if (!options.secretValue) {
                throw new Error('Secret value is required for update');
            }
            const secretString = typeof options.secretValue === 'string'
                ? options.secretValue
                : JSON.stringify(options.secretValue);
            const command = new client_secrets_manager_1.UpdateSecretCommand({
                SecretId: options.secretName,
                SecretString: secretString,
                Description: options.description,
                KmsKeyId: options.kmsKeyId
            });
            const result = await this.secretsManagerClient.send(command);
            return {
                arn: result.ARN || '',
                name: result.Name || '',
                versionId: result.VersionId || ''
            };
        }
        catch (error) {
            throw new Error(`Update Secret failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async deleteSecret(secretName, forceDelete = false) {
        try {
            const command = new client_secrets_manager_1.DeleteSecretCommand({
                SecretId: secretName,
                ForceDeleteWithoutRecovery: forceDelete
            });
            const result = await this.secretsManagerClient.send(command);
            return {
                arn: result.ARN || '',
                deletionDate: result.DeletionDate
            };
        }
        catch (error) {
            throw new Error(`Delete Secret failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    async listSecrets(options) {
        try {
            const command = new client_secrets_manager_1.ListSecretsCommand({
                MaxResults: options?.maxResults || 100,
                NextToken: options?.nextToken,
            });
            const result = await this.secretsManagerClient.send(command);
            return {
                secrets: result.SecretList || [],
                nextToken: result.NextToken
            };
        }
        catch (error) {
            throw new Error(`List Secrets failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    // Utility method to safely get secret with fallback
    async getSecretOrDefault(secretName, defaultValue) {
        try {
            const secret = await this.getSecret(secretName);
            return secret;
        }
        catch (error) {
            console.warn(`Failed to get secret ${secretName}, using default value:`, error);
            return defaultValue;
        }
    }
    // Utility Methods
    getS3Client() {
        return this.s3Client;
    }
    getDynamoClient() {
        return this.dynamoClient;
    }
    getSESClient() {
        return this.sesClient;
    }
    getSecretsManagerClient() {
        return this.secretsManagerClient;
    }
}
exports.AWSService = AWSService;
// import express from 'express';
// import multer from 'multer';
// import { awsMiddleware } from './middleware/awsMiddleware';
// import { AWSConfig } from './types/aws.types';
// import { S3DownloadOptions, S3UploadOptions, SecretsManagerListOptions, SecretsManagerOptions } from '../../interfaces/aws.interface';
// const app = express();
// // AWS Configuration
// const awsConfig: AWSConfig = {
//     region: process.env.AWS_REGION || 'us-east-1',
//     accessKeyId: process.env.AWS_ACCESS_KEY_ID,
//     secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
// };
// // Apply AWS middleware
// app.use(awsMiddleware(awsConfig));
// // Setup multer for file uploads
// const upload = multer({ storage: multer.memoryStorage() });
// // Example routes
// app.post('/upload', upload.single('file'), async (req, res) => {
//     try {
//         if (!req.file) {
//             return res.status(400).json({ error: 'No file provided' });
//         }
//         const uploadResult = await req.aws.uploadToS3({
//             bucket: 'your-bucket-name',
//             key: `uploads/${Date.now()}-${req.file.originalname}`,
//             body: req.file.buffer,
//             contentType: req.file.mimetype,
//             acl: 'public-read'
//         });
//         res.json({
//             success: true,
//             location: uploadResult.location,
//             etag: uploadResult.etag
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Upload failed'
//         });
//     }
// });
// app.get('/download/:key', async (req, res) => {
//     try {
//         const fileBuffer = await req.aws.downloadFromS3({
//             bucket: 'your-bucket-name',
//             key: req.params.key
//         });
//         const fileInfo = await req.aws.getS3ObjectInfo({
//             bucket: 'your-bucket-name',
//             key: req.params.key
//         });
//         res.setHeader('Content-Type', fileInfo.contentType || 'application/octet-stream');
//         res.setHeader('Content-Length', fileInfo.contentLength || 0);
//         res.send(fileBuffer);
//     } catch (error) {
//         res.status(404).json({
//             error: error instanceof Error ? error.message : 'File not found'
//         });
//     }
// });
// app.get('/presigned-url/:key', async (req, res) => {
//     try {
//         const url = await req.aws.generatePresignedUrl({
//             bucket: 'your-bucket-name',
//             key: req.params.key
//         }, 3600); // 1 hour expiration
//         res.json({ url });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to generate URL'
//         });
//     }
// });
// app.get('/list-files', async (req, res) => {
//     try {
//         const result = await req.aws.listS3Objects({
//             bucket: 'your-bucket-name',
//             prefix: req.query.prefix as string,
//             maxKeys: parseInt(req.query.limit as string) || 100
//         });
//         res.json(result);
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to list files'
//         });
//     }
// });
// app.delete('/delete/:key', async (req, res) => {
//     try {
//         await req.aws.deleteFromS3({
//             bucket: 'your-bucket-name',
//             key: req.params.key
//         });
//         res.json({ success: true });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to delete file'
//         });
//     }
// });
// app.post('/send-email', async (req, res) => {
//     try {
//         const { to, subject, body } = req.body;
//         const result = await req.aws.sendEmail(to, subject, body);
//         res.json({
//             success: true,
//             messageId: result.messageId
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to send email'
//         });
//     }
// });
// // Secrets Manager routes
// app.get('/secret/:name', async (req, res) => {
//     try {
//         const secret = await req.aws.getSecret(req.params.name);
//         res.json({
//             success: true,
//             secret: secret
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to get secret'
//         });
//     }
// });
// app.post('/secret', async (req, res) => {
//     try {
//         const { name, value, description, kmsKeyId } = req.body;
//         const result = await req.aws.createSecret({
//             secretName: name,
//             secretValue: value,
//             description,
//             kmsKeyId
//         });
//         res.json({
//             success: true,
//             ...result
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to create secret'
//         });
//     }
// });
// app.put('/secret/:name', async (req, res) => {
//     try {
//         const { value, description, kmsKeyId } = req.body;
//         const result = await req.aws.updateSecret({
//             secretName: req.params.name,
//             secretValue: value,
//             description,
//             kmsKeyId
//         });
//         res.json({
//             success: true,
//             ...result
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to update secret'
//         });
//     }
// });
// app.delete('/secret/:name', async (req, res) => {
//     try {
//         const forceDelete = req.query.force === 'true';
//         const result = await req.aws.deleteSecret(req.params.name, forceDelete);
//         res.json({
//             success: true,
//             ...result
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to delete secret'
//         });
//     }
// });
// app.get('/secrets', async (req, res) => {
//     try {
//         const maxResults = req.query.limit ? parseInt(req.query.limit as string) : undefined;
//         const nextToken = req.query.nextToken as string;
//         const result = await req.aws.listSecrets({
//             maxResults,
//             nextToken
//         });
//         res.json({
//             success: true,
//             ...result
//         });
//     } catch (error) {
//         res.status(500).json({
//             error: error instanceof Error ? error.message : 'Failed to list secrets'
//         });
//     }
// });
// export default app;
