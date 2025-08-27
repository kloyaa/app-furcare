import Joi from 'joi';
import mongoose from 'mongoose';

export class CustomJoiHelpers {
  public static isValidObjectId(value: string, helpers: Joi.CustomHelpers) {
    if (!mongoose.Types.ObjectId.isValid(value)) {
      return helpers.message({ custom: `${helpers.state.path} value is not a valid ObjectId` });
    }
    return value;
  }
}
