"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CustomJoiHelpers = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
class CustomJoiHelpers {
    static isValidObjectId(value, helpers) {
        if (!mongoose_1.default.Types.ObjectId.isValid(value)) {
            return helpers.message({
                custom: `${helpers.state.path} value is not a valid ObjectId`,
            });
        }
        return value;
    }
}
exports.CustomJoiHelpers = CustomJoiHelpers;
