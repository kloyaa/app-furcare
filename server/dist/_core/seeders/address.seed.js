"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedLocations = void 0;
const address_schema_1 = require("../../schema/address.schema");
const db_util_1 = require("../utils/db/db.util");
const address_1 = require("./services/address");
const seedLocations = async () => {
    await (0, db_util_1.connectDB)();
    const location = new address_1.ReadAddress();
    const countries = await location.getCountries();
    const subRegions = await location.getSubRegions();
    const cities = await location.getCities();
    const regions = await location.getRegions();
    const states = await location.getStates();
    await Promise.all([
        address_schema_1.RegionSchema.insertMany(regions),
        address_schema_1.SubRegionSchema.insertMany(subRegions),
        address_schema_1.CountrySchema.insertMany(countries),
        address_schema_1.CitySchema.insertMany(cities),
        address_schema_1.StateSchema.insertMany(states),
    ]);
    await (0, db_util_1.closeDB)();
};
exports.seedLocations = seedLocations;
