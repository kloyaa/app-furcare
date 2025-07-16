import { Schema, model } from 'mongoose';

const groomingApplicationSchema = new Schema(
    {
        pet: {
            type: Schema.Types.ObjectId,
            ref: 'Pet',
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
        hasAntiRabiesVaccination: {
            type: Boolean,
            required: true,
        },
        totalPrice: {
            type: Number,
            required: true,
        }
    },
    { timestamps: true },
);

const boardingApplicationSchema = new Schema(
    {
        petType: {
            type: String,
            required: true,
        },
        dailyRate: {
            type: Number,
            required: true,
        },
        maxDays: {
            type: Number,
            required: true,
        },
        facilities: {
            type: [String],
            required: false,
        },
        isAvailable: {
            type: Boolean,
            default: true,
        },
    },
    { timestamps: true },
);

const homeServiceApplicationSchema = new Schema(
    {
        serviceArea: {
            type: String,
            required: true,
        },
        servicesOffered: {
            type: [String],
            required: true,
        },
        callOutFee: {
            type: Number,
            required: true,
        },
        isAvailable: {
            type: Boolean,
            default: true,
        },
    },
    { timestamps: true },
);

const HomeServiceApplication = model('HomeServiceApplication', homeServiceApplicationSchema);
const BoardingApplication = model('BoardingApplication', boardingApplicationSchema);
const GroomingApplication = model('GroomingApplication', groomingApplicationSchema);

export {
    HomeServiceApplication,
    BoardingApplication,
    GroomingApplication
};
