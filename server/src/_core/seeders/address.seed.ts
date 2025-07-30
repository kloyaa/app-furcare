import { CitySchema, CountrySchema, RegionSchema, StateSchema, SubRegionSchema } from '../../schema/address.schema';
import { connectDB, closeDB } from '../utils/db/db.util';
import { ReadAddress } from './services/address';

export const seedLocations = async () => {
  await connectDB();

  const location = new ReadAddress();
  const countries = await location.getCountries();
  const subRegions = await location.getSubRegions();
  const cities = await location.getCities();
  const regions = await location.getRegions();
  const states = await location.getStates();

  await Promise.all([
    RegionSchema.insertMany(regions),
    SubRegionSchema.insertMany(subRegions),
    CountrySchema.insertMany(countries),
    CitySchema.insertMany(cities),
    StateSchema.insertMany(states),
  ]);

  await closeDB();
};
