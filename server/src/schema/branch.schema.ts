import { Schema, model } from 'mongoose';
import { IBranch } from '../_core/interfaces/schema/schema.interface';

const branchSchema = new Schema<IBranch>(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    address: {
      type: String,
      required: true,
      trim: true,
    },
    phone: {
      type: String,
      required: true,
      trim: true,
    },
    open: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  {
    timestamps: true,
  },
);

export const Branch = model<IBranch>('Branch', branchSchema);
