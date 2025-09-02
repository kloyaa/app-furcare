import { type Response } from 'express';
import { faker } from '@faker-js/faker';
import { TRequest } from '../_core/interfaces/overrides.interface';
import { statuses } from '../_core/const/api.statuses';
import { handleMongooseError } from '../_core/utils/db/error.util';
import { generateRandomNumber } from '../_core/utils/utils';
import Branch from '../schema/branch.schema';

export const createRandomBranches = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  try {
    const generatedBranches = await Branch.find().sort({ createdAt: -1 });
    if (generatedBranches.length > 0) {
      return res.status(400).json(statuses['03']);
    }

    const branches = [
      {
        name: 'Uptown Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: true,
      },
      {
        name: 'Downtown Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: faker.datatype.boolean(),
      },
      {
        name: 'Carmen Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: faker.datatype.boolean(),
      },

      {
        name: 'Brgy. 31 Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: faker.datatype.boolean(),
      },
      {
        name: 'Brgy. 12 Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: faker.datatype.boolean(),
      },
      {
        name: 'Lapasan Branch',
        address: `Brgy. ${faker.location.street()} St., Cagayan de Oro City, Philippines`,
        phone: `09${generateRandomNumber(9)}`,
        open: faker.datatype.boolean(),
      },
    ];

    await Branch.insertMany(branches);

    return res.status(201).json(statuses['00']);
  } catch (error) {
    console.log('@createRandomBranches error', error);
    return handleMongooseError(error, res);
  }
};

export const getBranches = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  try {
    const branches = await Branch.find().sort({ createdAt: -1 });
    return res.status(200).json(branches);
  } catch (error) {
    console.log('@getBranches error', error);
    return handleMongooseError(error, res);
  }
};

export const clearBranches = async (
  req: TRequest,
  res: Response
): Promise<any> => {
  try {
    await Branch.deleteMany({});
    return res.status(200).json(statuses['00']);
  } catch (error) {
    console.log('@clearBranches error', error);
    return handleMongooseError(error, res);
  }
};
