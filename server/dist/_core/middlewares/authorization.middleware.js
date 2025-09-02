"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authorize = void 0;
const api_statuses_1 = require("../const/api.statuses");
const roles_enum_1 = require("../enum/roles.enum");
const user_role_schema_1 = require("../../schema/user_role.schema");
const authorize = (...allowedRoles) => {
    return async (req, res, next) => {
        console.log('req.user', req.user);
        try {
            if (!req.user || !req.user.id) {
                return res.status(401).json(api_statuses_1.statuses['10020']);
            }
            if (allowedRoles.some(role => role === roles_enum_1.RoleName.Any)) {
                return next();
            }
            // Fetch user roles
            const userRoles = await user_role_schema_1.UserRole.find({ user: req.user.id }).populate('role');
            // // Check if user has any of the allowed roles
            const hasAllowedRole = userRoles.some(userRole => allowedRoles.includes(userRole.role.name));
            if (!hasAllowedRole) {
                return res.status(403).json(api_statuses_1.statuses['0057']);
            }
            next(); // User has the required role(s)
        }
        catch (error) {
            next(error); // Pass any errors to the error handler
        }
    };
};
exports.authorize = authorize;
