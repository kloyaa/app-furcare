export enum JwtExpiration {
  ACCESS_TOKEN = '15m', // 15 minutes for access tokens
  REFRESH_TOKEN = '7d', // 7 days for refresh tokens
  EMAIL_VERIFICATION = '1h', // 1 hour for email verification tokens
  PASSWORD_RESET = '30m', // 30 minutes for password reset tokens
}
