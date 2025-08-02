// lib/core/constants/api_constants.dart
import 'package:furcare_app/core/constants/___generated.dart';

class ApiConstants {
  static const String baseUrl = AppConfig.generatedBaseUrl;

  // Auth endpoints
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

  // Others
  static const String activities = '$baseUrl/activity/v1';
  static const String petServices = '$baseUrl/pet-services/v1';

  // Branches
  static const String branches = '$baseUrl/branch/v1';

  // Headers
  static const String userOrigin = 'nodex-user-origin';
  static const String accessKey = 'nodex-access-key';
  static const String secretKey = 'nodex-secret-key';
  static const String roleFor = 'nodex-role-for';
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';

  // Header values
  static const String userOriginValue = 'mobile';
  static const String accessKeyValue = AppConfig.accessKeyValue;
  static const String secretKeyValue = AppConfig.secretKeyValue;
  static const String roleForValue = 'user';
  static const String contentTypeValue = 'application/json';

  // Default headers for authentication
  static Map<String, String> get defaultHeaders => {
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

  // Headers with bearer token
  static Map<String, String> getAuthorizedHeaders(String token) => {
    ...defaultHeaders,
    authorization: 'Bearer $token',
  };
}
