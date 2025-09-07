import { PipelineStage } from 'mongoose';
import { statuses } from '../../_core/const/api.statuses';
import {
  TRequest,
  TResponse,
} from '../../_core/interfaces/overrides.interface';
import { handleMongooseError } from '../../_core/utils/db/error.util';
import { isEmpty } from '../../_core/utils/utils';
import { validateApplicationFilters } from '../../_core/validators/admin';
import {
  GroomingApplication,
  BoardingApplication,
  HomeServiceApplication,
} from '../../schema/application';

export const getAllApplications = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  const error = validateApplicationFilters(req.query);
  if (error) {
    return res.status(400).json({
      ...statuses['501'],
      message: error.details[0].message.replace(/['"]/g, ''),
    });
  }

  try {
    const { status, serviceType, page = 1, limit = 50 } = req.query;

    const baseQuery: any = {};
    if (!isEmpty(status)) {
      baseQuery.status = status;
    }

    const skipCount = (Number(page) - 1) * Number(limit);
    const applications: any[] = [];

    // Grooming Applications
    if (!serviceType || serviceType === 'grooming') {
      const groomingApps = await GroomingApplication.find(baseQuery)
        .populate('user', 'username email')
        .populate('pet', 'name specie')
        .populate('branch', 'name address')
        .sort({ createdAt: -1 })
        .lean();

      groomingApps.forEach((app: any) => {
        applications.push({
          _id: app._id,
          applicationType: 'grooming',
          user: {
            _id: app.user?._id || null,
            username: app.user?.username || 'N/A',
            email: app.user?.email || 'N/A',
          },
          pet: {
            _id: app.pet?._id || null,
            name: app.pet?.name || 'N/A',
            specie: app.pet?.specie || 'N/A',
          },
          branch: {
            _id: app.branch?._id || null,
            name: app.branch?.name || 'N/A',
          },
          totalPrice: app.totalPrice || 0,
          paidAmount: app.paidAmount || 0,
          paymentStatus: app.paymentStatus || 'pending',
          status: app.status,
          createdAt: app.createdAt,
          scheduleCode: app.scheduleCode,
          groomingOptions: app.groomingOptions || [],
        });
      });
    }

    // Boarding Applications
    if (!serviceType || serviceType === 'boarding') {
      const boardingApps = await BoardingApplication.find(baseQuery)
        .populate('user', 'username email')
        .populate('pet', 'name specie')
        .populate('branch', 'name address')
        .populate('cage', 'size price')
        .sort({ createdAt: -1 })
        .lean();

      boardingApps.forEach((app: any) => {
        applications.push({
          _id: app._id,
          applicationType: 'boarding',
          user: {
            _id: app.user?._id || null,
            username: app.user?.username || 'N/A',
            email: app.user?.email || 'N/A',
          },
          pet: {
            _id: app.pet?._id || null,
            name: app.pet?.name || 'N/A',
            specie: app.pet?.specie || 'N/A',
          },
          branch: {
            _id: app.branch?._id || null,
            name: app.branch?.name || 'N/A',
          },
          cage: {
            _id: app.cage?._id || null,
            size: app.cage?.size || 'N/A',
            price: app.cage?.price || 0,
          },
          totalPrice: app.totalPrice || 0,
          paidAmount: app.paidAmount || 0,
          paymentStatus: app.paymentStatus || 'pending',
          status: app.status,
          createdAt: app.createdAt,
          schedule: app.schedule,
          instructions: app.instructions,
          extensionDays: app.extensionDays || 0,
          extensionPrice: app.extensionPrice || 0,
        });
      });
    }

    // Home Service Applications
    if (!serviceType || serviceType === 'home_service') {
      const homeServiceApps = await HomeServiceApplication.find(baseQuery)
        .populate('user', 'username email')
        .populate('pet', 'name specie')
        .populate('branch', 'name address')
        .sort({ createdAt: -1 })
        .lean();

      homeServiceApps.forEach((app: any) => {
        applications.push({
          _id: app._id,
          applicationType: 'homeService',
          user: {
            _id: app.user?._id || null,
            username: app.user?.username || 'N/A',
            email: app.user?.email || 'N/A',
          },
          pet: {
            _id: app.pet?._id || null,
            name: app.pet?.name || 'N/A',
            specie: app.pet?.specie || 'N/A',
          },
          branch: {
            _id: app.branch?._id || null,
            name: app.branch?.name || 'N/A',
          },
          totalPrice: app.totalPrice || 0,
          paidAmount: app.paidAmount || 0,
          paymentStatus: app.paymentStatus || 'pending',
          status: app.status,
          createdAt: app.createdAt,
          schedule: app.schedule,
        });
      });
    }

    // Sort all applications by createdAt (descending)
    applications.sort(
      (a, b) =>
        new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );

    // Apply pagination
    const paginatedApplications = applications.slice(
      skipCount,
      skipCount + Number(limit)
    );
    const total = applications.length;

    return res.status(200).json({
      applications: paginatedApplications,
      pagination: {
        currentPage: Number(page),
        totalPages: Math.ceil(total / Number(limit)),
        totalItems: total,
        itemsPerPage: Number(limit),
      },
    });
  } catch (error) {
    console.log('@getAllApplications error', error);
    return handleMongooseError(error, res);
  }
};

export const getApplicationStatistics = async (
  req: TRequest,
  res: TResponse
): Promise<any> => {
  try {
    const currentYear = new Date().getFullYear();
    const startOfYear = new Date(currentYear, 0, 1);
    const endOfYear = new Date(currentYear, 11, 31, 23, 59, 59);

    // Create monthly aggregation pipeline

    const monthlyPipeline: PipelineStage[] = [
      {
        $match: {
          createdAt: {
            $gte: startOfYear,
            $lte: endOfYear,
          },
        },
      },
      {
        $group: {
          _id: { $month: '$createdAt' as any }, // cast to Expression
          count: { $sum: 1 },
          totalRevenue: { $sum: '$totalPrice' as any }, // cast to Expression
        },
      },
      {
        $sort: { _id: 1 as const }, // force as 1 | -1
      },
    ];

    // Get statistics for each service type
    const [groomingStats, boardingStats, homeServiceStats] = await Promise.all([
      GroomingApplication.aggregate(monthlyPipeline),
      BoardingApplication.aggregate(monthlyPipeline),
      HomeServiceApplication.aggregate(monthlyPipeline),
    ]);

    // Initialize monthly data structure
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const monthlyData = months.map((monthName, index) => {
      const monthNumber = index + 1;

      const groomingData = groomingStats.find(
        stat => stat._id === monthNumber
      ) || { count: 0, totalRevenue: 0 };
      const boardingData = boardingStats.find(
        stat => stat._id === monthNumber
      ) || { count: 0, totalRevenue: 0 };
      const homeServiceData = homeServiceStats.find(
        stat => stat._id === monthNumber
      ) || { count: 0, totalRevenue: 0 };

      return {
        month: monthName,
        monthNumber,
        grooming: {
          transactions: groomingData.count,
          revenue: groomingData.totalRevenue,
        },
        boarding: {
          transactions: boardingData.count,
          revenue: boardingData.totalRevenue,
        },
        homeService: {
          transactions: homeServiceData.count,
          revenue: homeServiceData.totalRevenue,
        },
        total: {
          transactions:
            groomingData.count + boardingData.count + homeServiceData.count,
          revenue:
            groomingData.totalRevenue +
            boardingData.totalRevenue +
            homeServiceData.totalRevenue,
        },
      };
    });

    // Calculate yearly totals
    const yearlyTotals = monthlyData.reduce(
      (acc, month) => ({
        transactions: acc.transactions + month.total.transactions,
        revenue: acc.revenue + month.total.revenue,
        grooming: {
          transactions: acc.grooming.transactions + month.grooming.transactions,
          revenue: acc.grooming.revenue + month.grooming.revenue,
        },
        boarding: {
          transactions: acc.boarding.transactions + month.boarding.transactions,
          revenue: acc.boarding.revenue + month.boarding.revenue,
        },
        homeService: {
          transactions:
            acc.homeService.transactions + month.homeService.transactions,
          revenue: acc.homeService.revenue + month.homeService.revenue,
        },
      }),
      {
        transactions: 0,
        revenue: 0,
        grooming: { transactions: 0, revenue: 0 },
        boarding: { transactions: 0, revenue: 0 },
        homeService: { transactions: 0, revenue: 0 },
      }
    );

    return res.status(200).json({
      year: currentYear,
      monthlyBreakdown: monthlyData,
      yearlyTotals,
    });
  } catch (error) {
    console.log('@getApplicationStatistics error', error);
    return handleMongooseError(error, res);
  }
};
