import { Schema, model } from 'mongoose';
import { IPetCage } from '../_core/interfaces/schema/schema.interface';

const petCageSchema = new Schema<IPetCage>(
    {
        price: {
            type: Number,
            required: true,
        },
        size: {
            type: String,
            enum: ['Small', 'Medium', 'Large'],
            required: true,
        },
        occupant: {
            type: Number,
            default: 0,
        },
        max: {
            type: Number,
            required: true,
        },
    },
    { timestamps: true },
);

const PetCage = model<IPetCage>('PetCage', petCageSchema);
export default PetCage;
