"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getApplicationDetails = exports.updateApplicationStatus = exports.getAllApplicationsByStatus = void 0;
const date_fns_1 = require("date-fns");
const api_statuses_1 = require("../../_core/const/api.statuses");
const Date_util_1 = require("../../_core/utils/Date.util");
const application_1 = require("../../schema/application");
const application_validator_1 = require("../../_core/validators/__staff/application.validator");
const profile_schema_1 = __importDefault(require("../../schema/profile.schema"));
const pet_services_controller_1 = require("../pet_services.controller");
const application_enum_1 = require("../../_core/enum/application.enum");
const activity_event_1 = require("../../_core/events/activity.event");
const activity_enum_1 = require("../../_core/enum/activity.enum");
/**
 * Retrieves all applications based on status with formatted data for staff review
 *
 * @param {TRequest} req - The request object containing query parameters
 * @param {TResponse} res - The response object used to send the applications data
 * @return {Promise<void>} A promise that resolves when the applications are successfully retrieved
 */
const getAllApplicationsByStatus = async (req, res) => {
    // Validate query parameters
    const error = (0, application_validator_1.validateGetApplicationsByStatus)(req.query);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { status = 'pending', applicationType = 'all' } = req.query;
        // Define population options for consistent data structure
        const populateOptions = [
            {
                path: 'user',
                select: 'username email',
            },
            {
                path: 'pet',
                select: 'name specie gender',
            },
            {
                path: 'branch',
                select: 'name location',
            },
        ];
        let applications = [];
        // Fetch based on application type filter
        if (applicationType === 'all' || applicationType === 'grooming') {
            const groomingApps = await application_1.GroomingApplication.find({ status })
                .populate(populateOptions)
                .sort({ createdAt: -1 })
                .lean()
                .exec();
            applications.push(...groomingApps.map(app => ({ ...app, applicationType: 'grooming' })));
        }
        if (applicationType === 'all' || applicationType === 'boarding') {
            const boardingApps = await application_1.BoardingApplication.find({ status })
                .populate(populateOptions)
                .sort({ createdAt: -1 })
                .lean()
                .exec();
            applications.push(...boardingApps.map(app => ({ ...app, applicationType: 'boarding' })));
        }
        if (applicationType === 'all' || applicationType === 'homeService') {
            const homeServiceApps = await application_1.HomeServiceApplication.find({ status })
                .populate(populateOptions)
                .sort({ createdAt: -1 })
                .lean()
                .exec();
            applications.push(...homeServiceApps.map(app => ({ ...app, applicationType: 'homeService' })));
        }
        // Fetch user profiles for all applications
        const userIds = applications.map(app => app.user?._id).filter(Boolean);
        const userProfiles = await profile_schema_1.default.find({ user: { $in: userIds } })
            .select('user fullName address contact')
            .lean()
            .exec();
        // Create a map for quick profile lookup
        const profileMap = new Map();
        userProfiles.forEach(profile => profileMap.set(profile.user.toString(), profile));
        // Format applications with consistent structure
        const formatApplications = (applications) => {
            return applications.map((app) => {
                // Get user profile from the map
                const userProfile = profileMap.get(app.user?._id?.toString());
                return {
                    _id: app._id,
                    user: app.user?._id || null,
                    applicationType: app.applicationType,
                    userInfo: {
                        username: app.user?.username || 'N/A',
                        email: app.user?.email || 'N/A',
                        fullName: userProfile?.fullName || 'N/A',
                        address: userProfile?.address || 'N/A',
                        phoneNumber: userProfile?.contact?.phoneNumber || 'N/A',
                        facebookDisplayName: userProfile?.contact?.facebookDisplayName || 'N/A',
                    },
                    petInfo: {
                        name: app.pet?.name || 'N/A',
                        breed: app.pet?.specie || 'N/A',
                        gender: app.pet?.gender || 'N/A',
                    },
                    totalPrice: app.totalPrice || 0,
                    paidAmount: app.paidAmount || 0,
                    paymentStatus: app.paymentStatus || 'unpaid',
                    submittedAt: (0, Date_util_1.formatRelativeTime)(app.createdAt),
                    branchName: app.branch?.name || 'N/A',
                    status: app.status || 'pending',
                };
            });
        };
        // Format and sort all applications by creation date
        const formattedApplications = formatApplications(applications)
            .sort((a, b) => {
            const aApp = applications.find(app => app._id.toString() === a._id.toString());
            const bApp = applications.find(app => app._id.toString() === b._id.toString());
            const aDate = aApp?.createdAt ? new Date(aApp.createdAt).getTime() : 0;
            const bDate = bApp?.createdAt ? new Date(bApp.createdAt).getTime() : 0;
            return bDate - aDate; // Most recent first
        });
        // Count by type
        const typeCount = {
            grooming: applications.filter(app => app.applicationType === 'grooming').length,
            boarding: applications.filter(app => app.applicationType === 'boarding').length,
            homeService: applications.filter(app => app.applicationType === 'homeService').length,
        };
        return res.status(200).json({
            applications: formattedApplications,
            statistics: {
                total: formattedApplications.length,
                ...typeCount,
            },
            filter: {
                status,
                applicationType,
            },
        });
    }
    catch (error) {
        console.log('@getAllApplicationsByStatus error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
};
exports.getAllApplicationsByStatus = getAllApplicationsByStatus;
/**
 * Updates the status of an application by ID and type
 *
 * @param {TRequest} req - The request object containing application ID, type, and new status
 * @param {TResponse} res - The response object used to send the update result
 * @return {Promise<void>} A promise that resolves when the application status is updated
 */
const updateApplicationStatus = async (req, res) => {
    const error = (0, application_validator_1.validateUpdateApplicationStatus)(req.body);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { application, applicationType, status: newStatus } = req.body;
        let updatedApplication;
        // Update based on application type
        switch (applicationType) {
            case application_enum_1.ApplicationTypeEnum.GroomingApplication:
                updatedApplication = await application_1.GroomingApplication.findByIdAndUpdate(application, { status: newStatus, updatedAt: new Date() }, { new: true }).populate([
                    { path: 'user', select: 'username email' },
                    { path: 'pet', select: 'name specie gender' },
                    { path: 'branch', select: 'name' },
                ]);
                activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
                    user: req.user.id,
                    description: applicationType + ' application status updated to ' + newStatus,
                });
                break;
            case application_enum_1.ApplicationTypeEnum.BoardingApplication:
                {
                    updatedApplication = await application_1.BoardingApplication.findById(application);
                    if (!updatedApplication) {
                        return res.status(404).json({
                            ...api_statuses_1.statuses['02'],
                            message: 'Application not found'
                        });
                    }
                    const isRejected = newStatus === application_enum_1.ApplicationStatusEnum.REJECTED;
                    const isCompleted = newStatus === application_enum_1.ApplicationStatusEnum.COMPLETED;
                    const isApproved = newStatus === application_enum_1.ApplicationStatusEnum.APPROVED;
                    if (isApproved) {
                        const isCageAvailable = await (0, pet_services_controller_1.validateCageAvailability)(updatedApplication.cage);
                        if (!isCageAvailable) {
                            return res.status(400).json({
                                ...api_statuses_1.statuses['501'],
                                message: 'Cage is full',
                            });
                        }
                    }
                    updatedApplication = await application_1.BoardingApplication.findByIdAndUpdate(application, { status: newStatus, updatedAt: new Date() }, { new: true }).populate([
                        { path: 'user', select: 'username email' },
                        { path: 'pet', select: 'name specie gender' },
                        { path: 'branch', select: 'name' },
                    ]);
                    if (isApproved) {
                        const isCageUpdated = await (0, pet_services_controller_1.updateCageOccupant)({
                            action: 'add',
                            cage: updatedApplication.cage,
                        });
                        if (!isCageUpdated) {
                            console.log('cage not updated');
                        }
                    }
                    if (isCompleted) {
                        const isCageUpdated = await (0, pet_services_controller_1.updateCageOccupant)({
                            action: 'remove',
                            cage: updatedApplication.cage,
                        });
                        if (!isCageUpdated) {
                            console.log('cage not updated');
                        }
                    }
                    activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
                        user: req.user.id,
                        description: applicationType + ' application status updated to ' + newStatus,
                    });
                }
                break;
            case application_enum_1.ApplicationTypeEnum.HomeServiceApplication:
                updatedApplication = await application_1.HomeServiceApplication.findByIdAndUpdate(application, { status: newStatus, updatedAt: new Date() }, { new: true }).populate([
                    { path: 'user', select: 'username email' },
                    { path: 'pet', select: 'name specie gender' },
                    { path: 'branch', select: 'name' },
                ]);
                activity_event_1.emitter.emit(activity_enum_1.EventName.ACTIVITY, {
                    user: req.user.id,
                    description: applicationType + ' application status updated to ' + newStatus,
                });
                break;
            default:
                return res.status(400).json({
                    ...api_statuses_1.statuses['501'],
                    message: 'Invalid application type',
                });
        }
        if (!updatedApplication) {
            return res.status(404).json({
                ...api_statuses_1.statuses['404'],
                message: 'Application not found',
            });
        }
        return res.status(200).json({
            application: updatedApplication,
            message: `${applicationType} application status updated to ${newStatus}`,
        });
    }
    catch (error) {
        console.log('@updateApplicationStatus error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
};
exports.updateApplicationStatus = updateApplicationStatus;
/**
 * Gets application details by ID and type for detailed view
 *
 * @param {TRequest} req - The request object containing application ID and type
 * @param {TResponse} res - The response object used to send the application details
 * @return {Promise<void>} A promise that resolves when the application details are retrieved
 */
const getApplicationDetails = async (req, res) => {
    // Validate parameters
    const error = (0, application_validator_1.validateGetApplicationDetails)(req.params);
    if (error) {
        return res.status(400).json({
            ...api_statuses_1.statuses['501'],
            message: error.details[0].message.replace(/['"]/g, ''),
        });
    }
    try {
        const { applicationId, applicationType } = req.params;
        const populateOptions = [
            { path: 'user', select: 'username email' },
            { path: 'pet', select: 'name specie gender age color' },
            { path: 'branch', select: 'name location address contact' },
        ];
        let application;
        switch (applicationType) {
            case 'grooming':
                application = await application_1.GroomingApplication.findById(applicationId)
                    .populate(populateOptions)
                    .lean()
                    .exec();
                break;
            case 'boarding':
                application = await application_1.BoardingApplication.findById(applicationId)
                    .populate([...populateOptions, { path: 'cage', select: 'name size pricePerDay' }])
                    .lean()
                    .exec();
                break;
            case 'homeService':
                application = await application_1.HomeServiceApplication.findById(applicationId)
                    .populate(populateOptions)
                    .lean()
                    .exec();
                break;
            default:
                return res.status(400).json({
                    ...api_statuses_1.statuses['501'],
                    message: 'Invalid application type',
                });
        }
        if (!application) {
            return res.status(404).json({
                ...api_statuses_1.statuses['02'],
                message: 'Application not found',
            });
        }
        // Fetch user profile separately
        let userProfile = null;
        if (application.user?._id) {
            userProfile = await profile_schema_1.default.findOne({ user: application.user._id })
                .select('fullName address contact')
                .lean()
                .exec();
        }
        return res.status(200).json({
            ...api_statuses_1.statuses['00'],
            data: {
                application: {
                    ...application,
                    // Enhanced user info with profile data
                    userInfo: {
                        username: application.user?.username || 'N/A',
                        email: application.user?.email || 'N/A',
                        fullName: userProfile?.fullName || 'N/A',
                        address: userProfile?.address || 'N/A',
                        phoneNumber: userProfile?.contact?.phoneNumber || 'N/A',
                        facebookDisplayName: userProfile?.contact?.facebookDisplayName || 'N/A',
                    },
                    createdAtFormatted: (0, Date_util_1.formatRelativeTime)(application.createdAt),
                    createdAtFull: (0, date_fns_1.formatDate)(application.createdAt, 'dd/MM/yyyy'),
                    applicationType,
                },
            },
        });
    }
    catch (error) {
        console.log('@getApplicationDetails error', error);
        return res.status(500).json(api_statuses_1.statuses['0900']);
    }
};
exports.getApplicationDetails = getApplicationDetails;
