"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReadAddress = void 0;
const fs_1 = require("fs");
const csv_parser_1 = __importDefault(require("csv-parser"));
class ReadAddress {
    /**
     * Retrieves a list of countries from a CSV file and maps the data to the Country interface.
     *
     * @return {Promise<Country[]>} A promise that resolves to an array of Country objects.
     */
    async getCountries() {
        return new Promise((resolve, reject) => {
            const countries = [];
            (0, fs_1.createReadStream)('././src/public/data/locations/countries.csv')
                .pipe((0, csv_parser_1.default)())
                .on('data', (row) => countries.push(row))
                .on('error', reject)
                .on('end', () => resolve(countries));
        }).then(countries => {
            return countries.map((el) => ({
                id: el.id,
                name: el.name,
                iso3: el.iso3,
                iso2: el.iso2,
                numericCode: el.numeric_code,
                phoneCode: el.phone_code,
                capital: el?.capital ?? 'N/A',
                currency: el.currency,
                currencyName: el.currency_name,
                currencySymbol: el.currency_symbol,
                tld: el.tld,
                native: el.native,
                region: el.region,
                regionId: el.region_id,
                subregion: el?.subregion ?? 'N/A',
                subregionId: el?.subregion_id ?? 'N/A',
                nationality: el.nationality,
                timezones: el.timezones,
                latitude: el.latitude,
                longitude: el.longitude,
                emoji: el.emoji,
                emojiU: el.emojiU,
            }));
        });
    }
    /**
     * Retrieves a list of cities from a CSV file and maps the data to the City interface.
     *
     * @return {Promise<City[]>} A promise that resolves to an array of City objects.
     */
    async getCities() {
        return new Promise((resolve, reject) => {
            const cities = [];
            (0, fs_1.createReadStream)('././src/public/data/locations/cities.csv')
                .pipe((0, csv_parser_1.default)())
                .on('data', (row) => cities.push(row))
                .on('error', reject)
                .on('end', () => resolve(cities));
        }).then(cities => {
            return cities.map((el) => ({
                id: el.id,
                name: el.name,
                stateId: el.state_id,
                stateCode: el.state_code,
                stateName: el.state_name,
                countryId: el.country_id,
                countryCode: el.country_code,
                countryName: el.country_name,
                latitude: el.latitude,
                longitude: el.longitude,
                wikiDataId: el.wikiDataId,
            }));
        });
    }
    /**
     * Retrieves a list of regions from a CSV file and maps the data to the Region interface.
     *
     * @return {Promise<Region[]>} A promise that resolves to an array of Region objects.
     */
    async getRegions() {
        return new Promise((resolve, reject) => {
            const regions = [];
            (0, fs_1.createReadStream)('././src/public/data/locations/regions.csv')
                .pipe((0, csv_parser_1.default)())
                .on('data', (row) => regions.push(row))
                .on('error', reject)
                .on('end', () => resolve(regions));
        }).then(regions => {
            return regions.map((el) => ({
                id: el.id,
                name: el.name,
                stateId: el.state_id,
                stateCode: el.state_code,
                stateName: el.state_name,
                countryId: el.country_id,
                countryCode: el.country_code,
                countryName: el.country_name,
                latitude: el.latitude,
                longitude: el.longitude,
                wikiDataId: el.wikiDataId,
            }));
        });
    }
    /**
     * Retrieves a list of subregions from a CSV file and maps the data to the desired format.
     *
     * @return {Promise<any[]>} A promise that resolves to an array of subregion objects.
     */
    async getSubRegions() {
        return new Promise((resolve, reject) => {
            const regions = [];
            (0, fs_1.createReadStream)('././src/public/data/locations/subregions.csv')
                .pipe((0, csv_parser_1.default)())
                .on('data', (row) => regions.push(row))
                .on('error', reject)
                .on('end', () => resolve(regions));
        }).then(regions => {
            return regions.map((el) => ({
                id: el.id,
                name: el.name,
                regionId: el.region_id,
                wikiDataId: el.wikiDataId,
            }));
        });
    }
    /**
     * Retrieves a list of states from a CSV file and maps the data to the Region interface.
     *
     * @return {Promise<any[] | void>} A promise that resolves to an array of Region objects or undefined.
     */
    async getStates() {
        return new Promise((resolve, reject) => {
            const states = [];
            (0, fs_1.createReadStream)('././src/public/data/locations/states.csv')
                .pipe((0, csv_parser_1.default)())
                .on('data', (row) => states.push(row))
                .on('error', reject)
                .on('end', () => resolve(states));
        }).then(states => {
            return states.map((el) => ({
                id: el.id,
                name: el.name,
                countryId: el.country_id,
                countryCode: el.country_code,
                countryName: el.country_name,
                stateCode: el.state_code,
                type: el.type,
                latitude: el.latitude,
                longitude: el.longitude,
            }));
        });
    }
}
exports.ReadAddress = ReadAddress;
