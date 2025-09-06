export enum EventName {
  ACTIVITY = 'user-activity',
  NETWORK_ACTIVITY = 'network-activity',
}

export enum ActivityType {
  LOGIN = 'Logged in successfully',
  CHANGE_PASSWORD = 'Changed password successfully',
  REGISTRATION_SUCCESS = 'Registered successfully',
  EKYC_SUCCESS = 'EKYC completed',
  SEED_USER_ACCOUNT = 'Seeded user account successfully',
  PROFILE_CREATED = 'Profile created',
  PROFILE_UPDATED = 'Profile updated',

  PET_ADDED = 'Companion added',
  PET_UPDATED = 'Companion updated',
  PET_DELETED = 'Companion removed',

  APPLICATION_GROOMING_SUBMITTED = 'Grooming application submitted',
  APPLICATION_GROOMING_UPDATED = 'Grooming application updated',
  APPLICATION_GROOMING_DELETED = 'Grooming application deleted',

  APPLICATION_BOARDING_SUBMITTED = 'Boarding application submitted',
  APPLICATION_BOARDING_UPDATED = 'Boarding application updated',
  APPLICATION_BOARDING_DELETED = 'Boarding application deleted',
  APPLICATION_BOARDING_EXTENDED = 'Boarding application extended',


  APPLICATION_HOME_SERVICE_SUBMITTED = 'Home service application submitted',
  APPLICATION_HOME_SERVICE_UPDATED = 'Home service application updated',
  APPLICATION_HOME_SERVICE_DELETED = 'Home service application deleted',

  PAYMENT_COMPLETED = "Payment completed",
  PAYMENT_FAILED = "Payment failed",
  PAYMENT_STATUS_UPDATED = "Payment status updated",
  PAYMENT_CREATED = "Payment created",
  PAYMENT_REFUNDED = "Payment refunded",
}
