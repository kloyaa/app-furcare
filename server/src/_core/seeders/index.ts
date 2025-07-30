import { seedLocations } from './address.seed';
import { seedRoleNames } from './rolename.seed';

Promise.all([
  // seedLocations(),
  seedRoleNames(),
]);
