"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedRoleNames = void 0;
const role_schema_1 = require("../../schema/role.schema");
const roles_enum_1 = require("../enum/roles.enum");
const db_util_1 = require("../utils/db/db.util");
const seedRoleNames = async () => {
    await (0, db_util_1.connectDB)();
    await role_schema_1.Role.deleteMany(); // clear all
    const roles = Object.values(roles_enum_1.RoleName).map(roleName => ({ name: roleName }));
    await role_schema_1.Role.insertMany(roles);
    await (0, db_util_1.closeDB)();
};
exports.seedRoleNames = seedRoleNames;
