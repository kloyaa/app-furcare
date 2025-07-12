import { Types } from 'mongoose';
import { Role } from '../../../schema/role.schema';

export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
  roles: IRole[];
}

export interface IPassword extends Document {
  user: Types.ObjectId;
  password: string;
}

export interface IProfile extends Document {
  user: Types.ObjectId;
  firstName: string;
  lastName: string;
  middleName: string;
  birthdate: Date;
  address: {
    present: string;
    permanent: string;
  };
  contact: {
    email: string;
    number: string;
  };
  gender: string;
  isActive: false;
}

export interface IRequestLog extends Document {
  timestamp: Date;
  clientIp: string;
  requestMethod: string;
  requestUrl: string;
  userAgent: string;
  requestBody?: any;
  responseStatus: number;
  responseStatusMessage: string;
  elapsed: number;
}

export interface Country extends Partial<Document> {
  id: string;
  name: string;
  iso3: string;
  iso2: string;
  numericCode: string;
  phoneCode: string;
  capital: string;
  currency: string;
  currencyName: string;
  currencySymbol: string;
  tld: string;
  native: string;
  region: string;
  regionId: string;
  subregion: string;
  subregionId: string;
  nationality: string;
  timezones: string; // You may want to parse this string to an array of timezone objects
  latitude: string;
  longitude: string;
  emoji: string;
  emojiU: string;
}

export interface City extends Partial<Document> {
  id: string;
  name: string;
  stateId: string;
  stateCode: string;
  stateName: string;
  countryId: string;
  countryCode: string;
  countryName: string;
  latitude: string;
  longitude: string;
  wikiDataId: string;
}

export interface Region extends Partial<Document> {
  id: string;
  name: string;
  stateId: string;
  stateCode: string;
  stateName: string;
  countryId: string;
  countryCode: string;
  countryName: string;
  latitude: string;
  longitude: string;
  wikiDataId: string;
}

export interface State extends Partial<Document> {
  id: string;
  name: string;
  countryId: string;
  countryCode: string;
  countryName: string;
  stateCode: string;
  type: string;
  latitude: string;
  longitude: string;
}

export interface SubRegion extends Partial<Document> {
  id: string;
  name: string;
  regionId: string;
  wikiDataId: string;
}

export interface IRole extends Document {
  name: string;
  description: string;
}

export interface IUserRole extends Document {
  user: Types.ObjectId;
  role: typeof Role;
}
