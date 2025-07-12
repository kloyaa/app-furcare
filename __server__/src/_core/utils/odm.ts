import mongoose from 'mongoose';

export const toObjectId = (idString: string): mongoose.Types.ObjectId => {
  return new mongoose.Types.ObjectId(idString);
};
