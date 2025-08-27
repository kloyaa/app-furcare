"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const rolename_seed_1 = require("./rolename.seed");
Promise.all([
    // seedLocations(),
    (0, rolename_seed_1.seedRoleNames)(),
]);
