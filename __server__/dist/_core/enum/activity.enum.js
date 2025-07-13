"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ActivityType = exports.EventName = void 0;
var EventName;
(function (EventName) {
    EventName["ACTIVITY"] = "user-activity";
    EventName["NETWORK_ACTIVITY"] = "network-activity";
})(EventName || (exports.EventName = EventName = {}));
var ActivityType;
(function (ActivityType) {
    ActivityType["LOGIN"] = "Logged in successfully";
    ActivityType["CHANGE_PASSWORD"] = "Changed password successfully";
    ActivityType["REGISTRATION_SUCCESS"] = "Registered successfully";
    ActivityType["EKYC_SUCCESS"] = "EKYC completed";
    ActivityType["SEED_USER_ACCOUNT"] = "Seeded user account successfully";
    ActivityType["PROFILE_CREATED"] = "Profile created";
    ActivityType["PROFILE_UPDATED"] = "Profile updated";
})(ActivityType || (exports.ActivityType = ActivityType = {}));
