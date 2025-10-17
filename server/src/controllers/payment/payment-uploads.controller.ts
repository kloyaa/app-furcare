import { Request, Response } from 'express';
import { statuses } from '../../_core/const/api.statuses';
import { handleMongooseError } from '../../_core/utils/db/error.util';
import { PaymentUpload } from '../../schema/payment-upload.schema';
import { uploadToS3 } from '../../_core/services/aws/aws.service';
import { uploadPaymentValidator } from '../../_core/validators/payment-uploads.validator';

export const uploadPaymentReceipts = async (req: Request, res: Response) => {
    try {
        const error = uploadPaymentValidator(req.body);
        if (error) {
            return res.status(400).json({
                ...statuses['501'],
                message: error.details[0].message.replace(/['"]/g, ''),
            });
        }
        const files = req.files as Express.Multer.File[];
        if (!req.files.length) {
            return res.status(400).json({ message: 'No file uploaded.' });
        }
        const { application, applicationModel } = req.body;

        for (const file of files) {
            const uploadResult = await uploadToS3(file);
            await PaymentUpload.create({
                application,
                applicationModel,
                url: uploadResult,
            });
        }
        return res.status(201).json(statuses['00']);
    } catch (err: any) {
        console.log('@uploadPaymentSingle error', err);
        return handleMongooseError(err, res);
    }
};
