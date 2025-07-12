import { Schema, model } from 'mongoose';
import { IUserRole } from '../_core/interfaces/schema/schema.interface';

const userRoleSchema = new Schema<IUserRole>({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  role: {
    type: Schema.Types.ObjectId,
    ref: 'Role',
    required: true,
  },
});

export const UserRole = model<IUserRole>('UserRole', userRoleSchema);
