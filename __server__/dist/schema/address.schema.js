"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StateSchema = exports.SubRegionSchema = exports.RegionSchema = exports.CitySchema = exports.CountrySchema = void 0;
const mongoose_1 = __importStar(require("mongoose"));
const countrySchema = new mongoose_1.Schema({
    id: {
        type: String,
    },
    name: {
        type: String,
    },
    iso3: {
        type: String,
    },
    iso2: {
        type: String,
    },
    numericCode: {
        type: String,
    },
    phoneCode: {
        type: String,
    },
    capital: {
        type: String,
    },
    currency: {
        type: String,
    },
    currencyName: {
        type: String,
    },
    currencySymbol: {
        type: String,
    },
    tld: {
        type: String,
    },
    native: {
        type: String,
    },
    region: {
        type: String,
    },
    regionId: {
        type: String,
    },
    subregion: {
        type: String,
    },
    subregionId: {
        type: String,
    },
    nationality: {
        type: String,
    },
    timezones: {
        type: String,
    },
    latitude: {
        type: String,
    },
    longitude: {
        type: String,
    },
    emoji: {
        type: String,
    },
    emojiU: {
        type: String,
    },
});
const citySchema = new mongoose_1.Schema({
    id: {
        type: String,
    },
    name: {
        type: String,
    },
    stateId: {
        type: String,
    },
    stateCode: {
        type: String,
    },
    stateName: {
        type: String,
    },
    countryId: {
        type: String,
    },
    countryCode: {
        type: String,
    },
    countryName: {
        type: String,
    },
    latitude: {
        type: String,
    },
    longitude: {
        type: String,
    },
    wikiDataId: {
        type: String,
    },
});
const regionSchema = new mongoose_1.Schema({
    id: { type: String },
    name: { type: String },
    stateId: { type: String },
    stateCode: { type: String },
    stateName: { type: String },
    countryId: { type: String },
    countryCode: { type: String },
    countryName: { type: String },
    latitude: { type: String },
    longitude: { type: String },
    wikiDataId: { type: String },
});
const stateSchema = new mongoose_1.Schema({
    id: { type: String },
    name: { type: String },
    countryId: { type: String },
    countryCode: { type: String },
    countryName: { type: String },
    stateCode: { type: String },
    type: { type: String },
    latitude: { type: String },
    longitude: { type: String },
});
const subRegionSchema = new mongoose_1.Schema({
    id: { type: String },
    name: { type: String },
    regionId: { type: String },
    wikiDataId: { type: String },
});
const CountrySchema = mongoose_1.default.model('Country', countrySchema);
exports.CountrySchema = CountrySchema;
const CitySchema = mongoose_1.default.model('City', citySchema);
exports.CitySchema = CitySchema;
const RegionSchema = mongoose_1.default.model('Region', regionSchema);
exports.RegionSchema = RegionSchema;
const SubRegionSchema = mongoose_1.default.model('SubRegion', subRegionSchema);
exports.SubRegionSchema = SubRegionSchema;
const StateSchema = mongoose_1.default.model('State', stateSchema);
exports.StateSchema = StateSchema;
