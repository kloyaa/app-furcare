import { Schema, model } from 'mongoose';
import { IApplication } from '../_core/interfaces/schema/schema.interface';
import { statuses } from '../_core/const/api.statuses';

const appSchema = new Schema<IApplication>(
  {
    maintenance: {
      type: Boolean,
      default: false,
    },
    maintenanceMessage: {
      type: String,
      default: statuses['503'].message,
    },
  },
  {
    timestamps: true,
  }
);

const Application = model<IApplication>('Application', appSchema);
export default Application;
