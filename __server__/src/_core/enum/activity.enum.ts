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
}
