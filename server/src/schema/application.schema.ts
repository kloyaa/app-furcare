import { Schema, model } from 'mongoose';
import {
  IBoardingApplication,
  IGroomingApplication,
  IHomeServiceApplication,
} from '../_core/interfaces/schema/schema.interface';
import { ApplicationStatusEnum } from '../_core/enum/application.enum';

const groomingApplicationSchema = new Schema<IGroomingApplication>(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    pet: {
      type: Schema.Types.ObjectId,
      ref: 'Pet',
      required: true,
    },
    branch: {
      type: Schema.Types.ObjectId,
      ref: 'Branch',
      required: true,
    },
    scheduleCode: {
      type: String,
      required: true,
    },
    groomingOptions: {
      type: [String],
      required: true,
    },
    groomingPreferences: {
      type: [String],
      required: true,
    },
    hasAllergy: {
      type: Boolean,
      required: true,
    },
    isOnMedication: {
      type: Boolean,
      required: true,
    },
    hasAntiRabbiesVaccination: {
      type: Boolean,
      required: true,
    },
    totalPrice: {
      type: Number,
      required: true,
    },
    status: {
      type: String,
      required: true,
      enum: Object.values(ApplicationStatusEnum),
      default: 'pending',
    },
  },
  { timestamps: true }
);

const boardingApplicationSchema = new Schema<IBoardingApplication>(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    pet: {
      type: Schema.Types.ObjectId,
      ref: 'Pet',
      required: true,
    },
    cage: {
      type: Schema.Types.ObjectId,
      ref: 'PetCage',
      required: true,
    },
    branch: {
      type: Schema.Types.ObjectId,
      ref: 'Branch',
      required: true,
    },
    schedule: {
      date: {
        type: Date,
        required: true,
      },
      time: {
        type: String,
        required: true,
      },
      days: {
        type: Number,
        required: true,
      },
      originalDays: {
        type: Number,
        required: false, // Will be set on first extension
      },
    },
    instructions: {
      type: String,
      required: true,
    },
    totalPrice: {
      type: Number,
      required: true,
    },
    originalPrice: {
      type: Number,
      required: false, // Will be set on first extension
    },
    requestAntiRabiesVaccination: {
      type: Boolean,
      required: true,
    },
    status: {
      type: String,
      required: true,
      enum: Object.values(ApplicationStatusEnum),
      default: 'pending',
    },
    extensions: [{
      type: {
        type: String,
        enum: ['add', 'minus', 'set'],
        required: true,
      },
      days: {
        type: Number,
        required: true,
      },
      priceChange: {
        type: Number,
        required: true,
      },
      timestamp: {
        type: Date,
        default: Date.now,
      },
      user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
      },
    }],
  },
  { timestamps: true }
);

// Add virtual fields for easier access
boardingApplicationSchema.virtual('extensionDays').get(function () {
  if (this.schedule.originalDays) {
    return this.schedule.days - this.schedule.originalDays;
  }
  return 0;
});

boardingApplicationSchema.virtual('extensionPrice').get(function () {
  if (this.originalPrice) {
    return this.totalPrice - this.originalPrice;
  }
  return 0;
});

// Ensure virtual fields are serialized
boardingApplicationSchema.set('toJSON', { virtuals: true });
boardingApplicationSchema.set('toObject', { virtuals: true });

const homeServiceApplicationSchema = new Schema<IHomeServiceApplication>(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    pet: {
      type: Schema.Types.ObjectId,
      ref: 'Pet',
      required: true,
    },
    branch: {
      type: Schema.Types.ObjectId,
      ref: 'Branch',
      required: true,
    },
    schedule: {
      date: {
        type: Date,
        required: true,
      },
      time: {
        type: String,
        required: true,
      },
    },
    totalPrice: {
      type: Number,
      default: 390,
    },
    status: {
      type: String,
      required: true,
      enum: Object.values(ApplicationStatusEnum),
      default: 'pending',
    },
  },
  { timestamps: true }
);

const HomeServiceApplication = model<IHomeServiceApplication>(
  'HomeServiceApplication',
  homeServiceApplicationSchema
);
const BoardingApplication = model(
  'BoardingApplication',
  boardingApplicationSchema
);
const GroomingApplication = model(
  'GroomingApplication',
  groomingApplicationSchema
);

export { HomeServiceApplication, BoardingApplication, GroomingApplication };
