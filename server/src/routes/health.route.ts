import { Router } from 'express';
import mongoose from 'mongoose';
import Application from '../schema/app.schema';

const router = Router();

router.get('', async (_, res) => {
  const database = await mongoose.connection.db?.admin().ping();
  const application = await Application.find();
  return res.status(200).json({
    database: database?.ok === 1 ? true : false,
    isUnderMaintenance: application[0].maintenance,
  });
});

export default router;
