import { Types } from 'mongoose';
import { Role } from '../../../schema/Role.schema';
import { ApplicationStatusEnum } from '../../enum/application.enum';
import { P } from '@faker-js/faker/dist/airline-CLphikKp';

export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
  roles: IRole[];
  createdAt: Date;
  updatedAt: Date;
}

export interface IPassword extends Document {
  user: Types.ObjectId;
  password: string;
}

export interface IProfile extends Document {
  user: Types.ObjectId;
  fullName: string;
  address: string;
  contact: {
    facebookDisplayName: string;
    phoneNumber: string;
  };
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
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

export interface IPet extends Document {
  user: Types.ObjectId;
  name: string;
  gender: string;
  specie: string;
}

export interface IGroomingApplication extends Document {
  user: Types.ObjectId;
  pet: Types.ObjectId;
  branch: Types.ObjectId;
  scheduleCode: string;
  groomingOptions: string[];
  groomingPreferences: string[];
  hasAllergy: boolean;
  isOnMedication: boolean;
  hasAntiRabbiesVaccination: boolean;
  totalPrice: number;
  status: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IBoardingApplication extends Document {
  user: Types.ObjectId;
  pet: Types.ObjectId;
  cage: Types.ObjectId;
  branch: Types.ObjectId;
  schedule: {
    date: Date;
    time: string;
    days: number;
    originalDays: number;
  };
  totalPrice: number;
  originalPrice: number;
  requestAntiRabiesVaccination: boolean;
  instructions: string;
  status: string;
  createdAt?: Date;
  updatedAt?: Date;
  extensions: any[];

  // Virtual fields
  extensionDays: number;
  extensionPrice: number;
}

export interface IHomeServiceApplication extends Document {
  user: Types.ObjectId;
  pet: Types.ObjectId;
  branch: Types.ObjectId;
  schedule: {
    date: Date;
    time: string;
  };

  totalPrice?: number;
  paidAmount?: number;
  paymentStatus: string;
  remainingBalance: number;

  status: string;

  createdAt?: Date;
  updatedAt?: Date;
  // Methods
  updatePaymentStatus(): void;
  getTotalPaidAmount(): Promise<number>;
}

export interface IBranch {
  name: string;
  address: string;
  phone: string;
  open: boolean;

  createdAt?: Date;
  updatedAt?: Date;
}

export interface IApplication {
  maintenance: boolean;

  isUnderMaintenance: boolean;

  createdAt?: Date;
  updatedAt?: Date;
}

export interface IPetCage extends Document {
  price: number;
  size: 'Small' | 'Medium' | 'Large';
  occupant: number;
  max: number;
}

export interface IPayment extends Document {
  application: Types.ObjectId;
  applicationModel: string;
  user: Types.ObjectId;
  amount: number;
  paymentMethod: string;
  paymentStatus: string;
  paymentType: string;
  transactionId?: string;
  paymentGatewayResponse?: any;
  notes?: string;

  createdAt?: Date;
  updatedAt?: Date;
}
