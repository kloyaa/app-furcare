import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/data/datasources/local/auth_local_datasource.dart';

class AuthHeaderProvider {
  final AuthLocalDataSource _authLocalDataSource;

  AuthHeaderProvider({required AuthLocalDataSource authLocalDataSource})
    : _authLocalDataSource = authLocalDataSource;

  Future<Map<String, dynamic>> getHeaders() async {
    final token = await _authLocalDataSource.getAccessToken();

    final headers = {...ApiConstants.defaultHeaders};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> getHeadersWithCustom(
    Map<String, dynamic> customHeaders,
  ) async {
    final baseHeaders = await getHeaders();
    return {...baseHeaders, ...customHeaders};
  }
}
