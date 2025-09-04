import {
    formatDistanceToNow,
    format,
    isValid,
    parseISO,
    differenceInSeconds,
    differenceInMinutes,
    differenceInHours,
    differenceInDays,
    differenceInMonths,
    differenceInYears,
    isFuture
} from 'date-fns';

/**
 * Formats a date into a relative time string (e.g., "30s ago", "3d ago")
 * @param date - The date to format
 * @returns Formatted relative time string
 */
export const formatRelativeTime = (date: Date | string): string => {
    if (!date) return 'N/A';

    let targetDate: Date;

    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = parseISO(date);
    } else {
        targetDate = date;
    }

    // Validate the date
    if (!isValid(targetDate)) {
        return 'N/A';
    }

    const now = new Date();

    // Check if date is in the future
    if (isFuture(targetDate)) {
        return 'in the future';
    }

    // Calculate differences
    const diffInSeconds = differenceInSeconds(now, targetDate);
    const diffInMinutes = differenceInMinutes(now, targetDate);
    const diffInHours = differenceInHours(now, targetDate);
    const diffInDays = differenceInDays(now, targetDate);
    const diffInMonths = differenceInMonths(now, targetDate);
    const diffInYears = differenceInYears(now, targetDate);

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

/**
 * Formats a date into a readable string format using date-fns
 * @param date - The date to format
 * @returns Formatted date string
 */
export const formatDate = (date: Date | string): string => {
    if (!date) return 'N/A';

    let targetDate: Date;

    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = parseISO(date);
    } else {
        targetDate = date;
    }

    // Validate the date
    if (!isValid(targetDate)) {
        return 'N/A';
    }

    return format(targetDate, 'MMM dd, yyyy • hh:mm a');
};

/**
 * Formats a date into a more natural relative time using date-fns built-in function
 * @param date - The date to format
 * @returns Formatted relative time string (e.g., "about 2 hours ago", "3 days ago")
 */
export const formatNaturalRelativeTime = (date: Date | string): string => {
    if (!date) return 'N/A';

    let targetDate: Date;

    // Handle string dates (ISO format)
    if (typeof date === 'string') {
        targetDate = parseISO(date);
    } else {
        targetDate = date;
    }

    // Validate the date
    if (!isValid(targetDate)) {
        return 'N/A';
    }

    return formatDistanceToNow(targetDate, { addSuffix: true });
};