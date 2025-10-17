import dayjs from 'dayjs';
import { adjectives, nouns } from '../const/text.const';

export const isEmpty = (value: any) => {
  if (value === null || value === undefined) {
    return true;
  }

  if (Array.isArray(value)) {
    return value.length === 0;
  }

  if (typeof value === 'string') {
    return value.trim().length === 0;
  }

  return false;
};

export const formatDate = (date: Date): string => {
  return dayjs(date).format('MMM D, YYYY; hh:mm A');
};

export const generatePassword = (length: number) => {
  const chars =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*_+.';
  let password = '';
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * chars.length);
    password += chars[randomIndex];
  }
  return password;
};

export const generateUsername = () => {
  const randomAdjective =
    adjectives[Math.floor(Math.random() * adjectives.length)];
  const randomNoun = nouns[Math.floor(Math.random() * nouns.length)];
  const randomNumber = Math.floor(Math.random() * 10000);

  return `${randomAdjective}${randomNoun}${randomNumber}`;
};

export const delay = (ms: number) => {
  console.log(`Delay started ${ms}`);
  return new Promise(resolve => setTimeout(resolve, ms));
};

export const generateRandomNumber = (length: number): string => {
  if (length <= 0) return '';

  return Array.from({ length }, () => Math.floor(Math.random() * 10)).join('');
};

export const generateTransactionRef = (prefix: string = ''): string => {
  const now = new Date();

  // Format date as YYYYMMDD
  const datePart = now
    .toISOString()
    .slice(0, 10)
    .replace(/-/g, '');

  // Generate 8-char random alphanumeric code
  const randomPart = Math.random().toString(36).substring(2, 10).toUpperCase();

  // Combine
  return `${prefix}-${datePart}-${randomPart}`;
};
