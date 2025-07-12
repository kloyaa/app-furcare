import { Response, NextFunction } from 'express';
import { TRequest } from '../interfaces/overrides.interface';
import { statuses } from '../const/api.statuses';
import { RoleName } from '../enum/roles.enum';
import { UserRole } from '../../schema/user_role.schema';

export const authorize = (...allowedRoles: RoleName[]) => {
  return async (req: TRequest, res: Response, next: NextFunction) => {
    try {
      if (!req.user || !req.user.id) {
        return res.status(401).json(statuses['10020']);
      }

      if (allowedRoles.some((role) => role === RoleName.Any)) {
        return next();
      }

      // Fetch user roles
      const userRoles = await UserRole
        .find({ user: req.user.id })
        .populate('role');

      // // Check if user has any of the allowed roles
      const hasAllowedRole = userRoles.some((userRole) =>
        allowedRoles.includes(userRole.role.name as RoleName)
      );

      if (!hasAllowedRole) {
        return res.status(403).json(statuses['0057']);
      }
      next(); // User has the required role(s)
    } catch (error) {
      next(error); // Pass any errors to the error handler
    }
  };
};
