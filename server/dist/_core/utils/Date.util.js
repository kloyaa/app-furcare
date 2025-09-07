"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatNaturalRelativeTime = exports.formatDate = exports.formatRelativeTime = void 0;
const date_fns_1 = require("date-fns");
/**
 * Formats a date into a relative time string (e.g., "30s ago", "3d ago")
 * @param date - The date to format
 * @returns Formatted relative time string
 */
const formatRelativeTime = (date) => {
    if (!date)
        return 'N/A';
    let targetDate;
    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = (0, date_fns_1.parseISO)(date);
    }
    else {
        targetDate = date;
    }
    // Validate the date
    if (!(0, date_fns_1.isValid)(targetDate)) {
        return 'N/A';
    }
    const now = new Date();
    // Check if date is in the future
    if ((0, date_fns_1.isFuture)(targetDate)) {
        return 'in the future';
    }
    // Calculate differences
    const diffInSeconds = (0, date_fns_1.differenceInSeconds)(now, targetDate);
    const diffInMinutes = (0, date_fns_1.differenceInMinutes)(now, targetDate);
    const diffInHours = (0, date_fns_1.differenceInHours)(now, targetDate);
    const diffInDays = (0, date_fns_1.differenceInDays)(now, targetDate);
    const diffInMonths = (0, date_fns_1.differenceInMonths)(now, targetDate);
    const diffInYears = (0, date_fns_1.differenceInYears)(now, targetDate);
    // Return appropriate format based on time difference
    if (diffInSeconds < 60) {
        return `${diffInSeconds}s ago`;
    }
    if (diffInMinutes < 60) {
        return `${diffInMinutes}m ago`;
    }
    if (diffInHours < 24) {
        return `${diffInHours}h ago`;
    }
    if (diffInDays < 30) {
        return `${diffInDays}d ago`;
    }
    if (diffInMonths < 12) {
        return `${diffInMonths}mo ago`;
    }
    return `${diffInYears}y ago`;
};
exports.formatRelativeTime = formatRelativeTime;
/**
 * Formats a date into a readable string format using date-fns
 * @param date - The date to format
 * @returns Formatted date string
 */
const formatDate = (date) => {
    if (!date)
        return 'N/A';
    let targetDate;
    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = (0, date_fns_1.parseISO)(date);
    }
    else {
        targetDate = date;
    }
    // Validate the date
    if (!(0, date_fns_1.isValid)(targetDate)) {
        return 'N/A';
    }
    return (0, date_fns_1.format)(targetDate, 'MMM dd, yyyy • hh:mm a');
};
exports.formatDate = formatDate;
/**
 * Formats a date into a more natural relative time using date-fns built-in function
 * @param date - The date to format
 * @returns Formatted relative time string (e.g., "about 2 hours ago", "3 days ago")
 */
const formatNaturalRelativeTime = (date) => {
    if (!date)
        return 'N/A';
    let targetDate;
    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = (0, date_fns_1.parseISO)(date);
    }
    else {
        targetDate = date;
    }
    // Validate the date
    if (!(0, date_fns_1.isValid)(targetDate)) {
        return 'N/A';
    }
    return (0, date_fns_1.formatDistanceToNow)(targetDate, { addSuffix: true });
};
exports.formatNaturalRelativeTime = formatNaturalRelativeTime;
