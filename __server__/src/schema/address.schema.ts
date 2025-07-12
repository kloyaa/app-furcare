import mongoose, { Schema } from 'mongoose';
import { City, Country, Region, State, SubRegion } from '../_core/interfaces/schema/schema.interface';

const countrySchema = new Schema<Country>({
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

const citySchema = new Schema<City>({
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

const regionSchema = new Schema<Region>({
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

const stateSchema: Schema = new Schema<State>({
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

const subRegionSchema: Schema = new Schema<SubRegion>({
  id: { type: String },
  name: { type: String },
  regionId: { type: String },
  wikiDataId: { type: String },
});

const CountrySchema = mongoose.model<Country>('Country', countrySchema);
const CitySchema = mongoose.model<City>('City', citySchema);
const RegionSchema = mongoose.model<Region>('Region', regionSchema);
const SubRegionSchema = mongoose.model<Region>('SubRegion', subRegionSchema);
const StateSchema = mongoose.model<State>('State', stateSchema);

export { CountrySchema, CitySchema, RegionSchema, SubRegionSchema, StateSchema };
