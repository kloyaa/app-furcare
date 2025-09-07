"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applicationModelEnum = exports.paymentTypeEnum = exports.paymentStatusEnum = exports.paymentMethodEnum = void 0;
// Payment method enum
exports.paymentMethodEnum = [
    'credit_card',
    'debit_card',
    'cash',
    'gcash',
    'paymaya',
    'bank_transfer'
];
// Payment status enum
exports.paymentStatusEnum = [
    'pending',
    'completed',
    'failed',
    'refunded',
    'cancelled'
];
// Payment type enum
exports.paymentTypeEnum = [
    'full_payment',
    'partial_payment',
    'deposit',
    'refund'
];
// Application model enum
exports.applicationModelEnum = [
    'GroomingApplication',
    'BoardingApplication',
    'HomeServiceApplication'
];
