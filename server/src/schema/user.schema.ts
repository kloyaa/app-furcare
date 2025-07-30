import { CallbackError, Schema, model } from 'mongoose';
import { IPassword, IUser } from '../_core/interfaces/schema/schema.interface';
import { Role } from './role.schema';
import { UserRole } from './user_role.schema';

const userSchema = new Schema<IUser>(
  {
    username: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
    },
    roles: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Role',
      },
    ],
  },
  { timestamps: true },
);

const passwordSchema = new Schema<IPassword>(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
  },
  { timestamps: true },
);

const Password = model<IPassword>('Password', passwordSchema);
const User = model<IUser>('User', userSchema);

export { Password, User };
