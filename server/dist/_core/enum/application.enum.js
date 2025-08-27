"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ApplicationStatusEnum = exports.groomingPreferencesEnum = exports.groomingOptionsEnum = exports.groomingScheduleEnum = exports.applicationStatusEnum = void 0;
exports.applicationStatusEnum = ['pending', 'in-progress', 'completed', 'cancelled', 'rejected'];
exports.groomingScheduleEnum = [
    'SCHEDULE_1',
    'SCHEDULE_2',
    'SCHEDULE_3',
    'SCHEDULE_4',
    'SCHEDULE_5',
    'SCHEDULE_6',
    'SCHEDULE_7',
];
exports.groomingOptionsEnum = [
    'FULL_BATH',
    'FLEA_AND_TICK_TREATMENT',
    'TEETH_BRUSHING',
    'SPECIFIC_REQUEST',
    'NAIL_TRIM',
    'HAIRCUT',
    'EAR_CLEANING'
];
exports.groomingPreferencesEnum = [
    'SPECIFIC_REQUEST',
    'FULL_TRIM',
    'LONG_TRIM',
    'SHORT_TRIM'
];
var ApplicationStatusEnum;
(function (ApplicationStatusEnum) {
    ApplicationStatusEnum["PENDING"] = "pending";
    ApplicationStatusEnum["IN_PROGRESS"] = "in-progress";
    ApplicationStatusEnum["COMPLETED"] = "completed";
    ApplicationStatusEnum["CANCELLED"] = "cancelled";
    ApplicationStatusEnum["REJECTED"] = "rejected";
})(ApplicationStatusEnum || (exports.ApplicationStatusEnum = ApplicationStatusEnum = {}));
