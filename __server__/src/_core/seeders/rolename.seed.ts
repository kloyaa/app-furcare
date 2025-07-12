import { Role } from '../../schema/role.schema';
import { RoleName } from '../enum/roles.enum';
import { closeDB, connectDB } from '../utils/db/db.util';

export const seedRoleNames = async () => {
  await connectDB();

  await Role.deleteMany(); // clear all

  const roles = Object.values(RoleName).map((roleName) => ({ name: roleName }));

  await Role.insertMany(roles);

  await closeDB();
};
