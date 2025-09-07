import { Schema, model } from 'mongoose';
import {
  baseApplicationFields,
  baseSchemaOptions,
} from '../base/base-application-schema';
import { IGroomingApplication } from '../../_core/interfaces/schema/schema.interface';
import {
  addPaymentMethods,
  addPaymentVirtuals,
  paymentFields,
} from '../../mixins/payment-mixin';

const groomingApplicationSchema = new Schema<IGroomingApplication>(
  {
    ...baseApplicationFields,
    scheduleCode: {
      type: String,
      required: [true, 'Schedule code is required'],
      index: true,
    },
    groomingOptions: {
      type: [String],
      required: [true, 'At least one grooming option is required'],
      validate: {
        validator: (arr: string[]) => arr && arr.length > 0,
        message: 'At least one grooming option must be selected',
      },
    },
    groomingPreferences: {
      type: [String],
      default: [],
    },
    hasAllergy: {
      type: Boolean,
      required: true,
      default: false,
    },
    isOnMedication: {
      type: Boolean,
      required: true,
      default: false,
    },
    hasAntiRabbiesVaccination: {
      type: Boolean,
      required: true,
      default: false,
    },
    ...paymentFields,
  },
  baseSchemaOptions
);

// Add payment functionality
addPaymentVirtuals(groomingApplicationSchema);
addPaymentMethods(groomingApplicationSchema);

// Add indexes
groomingApplicationSchema.index({ user: 1, status: 1 });
groomingApplicationSchema.index({ branch: 1, createdAt: -1 });
groomingApplicationSchema.index({ scheduleCode: 1 });

export const GroomingApplication = model<IGroomingApplication>(
  'GroomingApplication',
  groomingApplicationSchema
);
