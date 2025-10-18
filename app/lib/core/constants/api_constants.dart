// lib/core/constants/api_constants.dart
import 'package:furcare_app/core/constants/___generated.dart';

class ApiConstants {
  static const String host = AppConfig.generatedBaseUrl;
  static const String baseUrl = '${AppConfig.generatedBaseUrl}/api';

  static const String login = '$baseUrl/auth/v1/login';
  static const String register = '$baseUrl/auth/v1/register';
  static const String changePassword =
      '$baseUrl/auth/v1/account/change-password';

  // Client endpoints
  static const String clientProfile = '$baseUrl/user/v1/profile';

  // Pets
  static const String pets = '$baseUrl/pet/v1';

  // Appointments
  static const String appointment = '$baseUrl/application/v1';

  // Staff
  static const String staff = '$baseUrl/staff/v1';

  // Ekyc
  static const String ekyc = '$baseUrl/ekyc/v1';

  // Grooming
  static const String admin = '$baseUrl/admin/v1';

  // Others
  static const String activities = '$baseUrl/activity/v1';
  static const String petServices = '$baseUrl/pet-services/v1';

  // Branches
  static const String branches = '$baseUrl/branch/v1';

  // Payments
  static const String payments = '$baseUrl/payment/v1';
  static const String uploadPaymentReceipts =
      '$baseUrl/upload/v1/payment/receipts';

  // Headers
  static const String userOrigin = 'nodex-user-origin';
  static const String accessKey = 'nodex-access-key';
  static const String secretKey = 'nodex-secret-key';
  static const String roleFor = 'nodex-role-for';
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';

  // Header values
  static const String userOriginValue = 'mobile';
  static const String webOriginValue = 'web';

  static const String accessKeyValue = AppConfig.accessKeyValue;
  static const String secretKeyValue = AppConfig.secretKeyValue;
  static const String roleForValue = 'user';
  static const String contentTypeValue = 'application/json';

  // Default headers for authentication
  static Map<String, String> get defaultHeaders => {
    'Access-Control-Allow-Origin': '*',
    'Accept': 'application/json',
    userOrigin: userOriginValue,
    accessKey: accessKeyValue,
    secretKey: secretKeyValue,
    contentType: contentTypeValue,
  };

  // Headers for registration (includes role)
  static Map<String, String> get registerHeaders => {
    ...defaultHeaders,
    roleFor: roleForValue,
  };

  static Map<String, String> get webApplicationHeaders => {
    ...defaultHeaders,
    userOrigin: webOriginValue,
  };

  // Headers with bearer token
  static Map<String, String> getAuthorizedHeaders(String token) => {
    ...defaultHeaders,
    authorization: 'Bearer $token',
  };
}
