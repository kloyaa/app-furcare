import { Router } from 'express';
import mongoose from 'mongoose';

const router = Router();

router.get('', async (_, res) => {
    const database = await mongoose.connection.db.admin().ping();
    return res.status(200).json({
        database
    })
});

export default router;