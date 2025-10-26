import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/__admin/admin_application_models.dart';
import 'package:furcare_app/data/models/__admin/admin_create_user_models.dart';
import 'package:furcare_app/data/models/__admin/admin_payment_models.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/data/models/default_models.dart';

abstract class AdminRemoteDatasource {
  Future<List<AdminUser>> getUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  });

  Future<AdminApplicationsResponse> getApplications({
    int? page,
    int? limit,
    String? applicationType,
    String? status,
    String? paymentStatus,
  });

  Future<AdminStatistics> getStatistics({int? year, int? month});

  Future<List<AdminApplicationPayment>> getPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  });

  Future<AdminUser> getUserById(String userId);
  Future<AdminApplication> getApplicationById(String applicationId);
  Future<AdminApplicationPayment> getPaymentById(String paymentId);

  // User management
  Future<CreateUserResponse> createUser(CreateUserRequest request);
  Future<DefaultResponse> updateUser(UpdateUserInfoRequest request);

  Future<UpdateUserStatusResponse> activateUser(ActivateUserRequest user);
  Future<UpdateUserStatusResponse> deactivateUser(DeactivateUserRequest user);
}

class AdminRemoteDatasourceImpl implements AdminRemoteDatasource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  AdminRemoteDatasourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<List<AdminUser>> getUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (search != null) queryParameters['search'] = search;
      if (isActive != null) queryParameters['isActive'] = isActive;

      final response = await _networkService.get(
        "${ApiConstants.admin}/users",
        queryParameters: queryParameters,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => AdminUser.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching users',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during fetching users');
    }
  }

  @override
  Future<AdminApplicationsResponse> getApplications({
    int? page,
    int? limit,
    String? applicationType,
    String? status,
    String? paymentStatus,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (applicationType != null) {
        queryParameters['applicationType'] = applicationType;
      }
      if (status != null) queryParameters['status'] = status;
      if (paymentStatus != null) {
        queryParameters['paymentStatus'] = paymentStatus;
      }

      final response = await _networkService.get(
        "${ApiConstants.admin}/applications",
        queryParameters: queryParameters,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return AdminApplicationsResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching appointments',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching appointments',
      );
    }
  }

  @override
  Future<AdminStatistics> getStatistics({int? year, int? month}) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (year != null) queryParameters['year'] = year;
      if (month != null) queryParameters['month'] = month;

      final response = await _networkService.get(
        "${ApiConstants.admin}/statistics",
        queryParameters: queryParameters,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return AdminStatistics.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching statistics',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching statistics',
      );
    }
  }

  @override
  Future<List<AdminApplicationPayment>> getPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (paymentMethod != null) {
        queryParameters['paymentMethod'] = paymentMethod;
      }
      if (paymentStatus != null) {
        queryParameters['paymentStatus'] = paymentStatus;
      }
      if (applicationId != null) {
        queryParameters['applicationId'] = applicationId;
      }

      final response = await _networkService.get(
        "${ApiConstants.admin}/payments",
        queryParameters: queryParameters,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((item) => AdminApplicationPayment.fromJson(item))
            .toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching payments',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching payments',
      );
    }
  }

  @override
  Future<AdminUser> getUserById(String userId) async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.admin}/users/$userId",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return AdminUser.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching user',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred during fetching user');
    }
  }

  @override
  Future<AdminApplication> getApplicationById(String applicationId) async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.admin}/applications/$applicationId",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return AdminApplication.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching application',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching application',
      );
    }
  }

  @override
  Future<AdminApplicationPayment> getPaymentById(String paymentId) async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.admin}/payments/$paymentId",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return AdminApplicationPayment.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching payment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching payment',
      );
    }
  }

  // User management
  @override
  Future<CreateUserResponse> createUser(CreateUserRequest request) async {
    try {
      final response = await _networkService.post(
        ApiConstants.ekyc,
        data: request.toJson(),
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const CreateUserResponse(
          success: true,
          message: 'User created successfully',
        );
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error creating user',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred while creating user');
    }
  }

  @override
  Future<DefaultResponse> updateUser(UpdateUserInfoRequest request) async {
    try {
      final response = await _networkService.put(
        ApiConstants.ekyc,
        data: request.toJson(),
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error updating user',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred while updating user');
    }
  }

  @override
  Future<UpdateUserStatusResponse> activateUser(
    ActivateUserRequest request,
  ) async {
    try {
      final response = await _networkService.patch(
        '${ApiConstants.admin}/users/activate',
        data: request.toJson(),
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return UpdateUserStatusResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error activating user',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'An error occurred while activating user');
    }
  }

  @override
  Future<UpdateUserStatusResponse> deactivateUser(
    DeactivateUserRequest request,
  ) async {
    try {
      final response = await _networkService.patch(
        '${ApiConstants.admin}/users/deactivate',
        data: request.toJson(),
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return UpdateUserStatusResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error deactivating user',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred while deactivating user',
      );
    }
  }
}
