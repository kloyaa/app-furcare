// lib/core/constants/api_constants.dart
import 'package:flutter_application_1/core/constants/___generated.dart';

class ApiConstants {
  static const String baseUrl = AppConfig.generatedBaseUrl;

  // Auth endpoints
  static const String login = '/api/auth/v1/login';
  static const String register = '/api/auth/v1/register';

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
