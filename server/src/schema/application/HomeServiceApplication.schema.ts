import { Schema, model, Document } from 'mongoose';
import {
  addPaymentMethods,
  addPaymentVirtuals,
  paymentFields,
} from '../../mixins/payment-mixin';
import {
  baseApplicationFields,
  baseSchemaOptions,
} from '../base/BaseApplicationSchema';
import { IHomeServiceApplication } from '../../_core/interfaces/schema/schema.interface';

const homeServiceApplicationSchema = new Schema<IHomeServiceApplication>(
  {
    ...baseApplicationFields,
    schedule: {
      date: {
        type: Date,
        required: [, 'Service date is required'],
        index: true,
        validate: {
          validator: (date: Date) => date > new Date(),
          message: 'Service date must be in the future',
        },
      },
      time: {
        type: String,
        required: [true, 'Service time is required'],
        validate: {
          validator: (time: string) =>
            /^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$/i.test(time),
          message: 'Invalid time format (HH:MM expected)',
        },
      },
    },
    totalPrice: {
      type: Number,
      default: 390,
      min: 0,
      validate: {
        validator: (value: number) => value >= 0,
        message: 'Price cannot be negative',
      },
    },
    ...paymentFields,
  },
  baseSchemaOptions
);

// Add payment functionality
addPaymentVirtuals(homeServiceApplicationSchema);
addPaymentMethods(homeServiceApplicationSchema);

// Indexes
homeServiceApplicationSchema.index({ user: 1, paymentStatus: 1 });
homeServiceApplicationSchema.index({ branch: 1, 'schedule.date': 1 });

export const HomeServiceApplication = model<IHomeServiceApplication>(
  'HomeServiceApplication',
  homeServiceApplicationSchema
);
