import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';
import { config } from 'dotenv';
import { getEnv } from '../../config/env.config';


export const uploadToS3 = async (file: Express.Multer.File) => {
    const env = await getEnv();
    const s3 = new S3Client({
        region: env.AWS_REGION,
        credentials: {
            accessKeyId: env.AWS_ACCESS_KEY_ID,
            secretAccessKey: env.AWS_SECRET_ACCESS_KEY,
        },
    });
    const fileKey = `uploads/${uuidv4()}${path.extname(file.originalname)}`;

    const command = new PutObjectCommand({
        Bucket: env.AWS_BUCKET_NAME!,
        Key: fileKey,
        Body: file.buffer,
        ContentType: file.mimetype,
    });

    await s3.send(command);
    const fileUrl = `https://${process.env.AWS_BUCKET_NAME}.s3.${process.env.AWS_REGION}.amazonaws.com/${fileKey}`;
    return fileUrl;
};
