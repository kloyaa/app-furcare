import { Schema, model } from 'mongoose';
import { IApplication } from '../_core/interfaces/schema/schema.interface';

const appSchema = new Schema<IApplication>(
  {
    maintenance: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

const Application = model<IApplication>('Application', appSchema);
export default Application;
