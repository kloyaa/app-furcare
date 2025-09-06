import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/admin/admin_remote_datasource.dart';
import 'package:furcare_app/data/models/__admin/admin_application_models.dart';
import 'package:furcare_app/data/models/__admin/admin_create_user_models.dart';
import 'package:furcare_app/data/models/__admin/admin_payment_models.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/data/models/default_models.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AdminUser>>> getUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  });

  Future<Either<Failure, AdminApplicationsResponse>> getApplications({
    int? page,
    int? limit,
    String? applicationType,
    String? status,
    String? paymentStatus,
  });

  Future<Either<Failure, AdminStatistics>> getStatistics({
    int? year,
    int? month,
  });

  Future<Either<Failure, List<AdminApplicationPayment>>> getPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  });

  Future<Either<Failure, AdminUser>> getUserById(String userId);

  Future<Either<Failure, AdminApplication>> getApplicationById(
    String applicationId,
  );

  Future<Either<Failure, AdminApplicationPayment>> getPaymentById(
    String paymentId,
  );

  // Admin
  Future<Either<Failure, CreateUserResponse>> createUser(
    CreateUserRequest request,
  );

  Future<Either<Failure, DefaultResponse>> updateUser(
    UpdateUserInfoRequest request,
  );

  Future<Either<Failure, UpdateUserStatusResponse>> activateUser(
    ActivateUserRequest user,
  );

  Future<Either<Failure, UpdateUserStatusResponse>> deactivateUser(
    DeactivateUserRequest user,
  );
}

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource _remoteDataSource;

  AdminRepositoryImpl({required AdminRemoteDatasource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<AdminUser>>> getUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    try {
      final users = await _remoteDataSource.getUsers(
        page: page,
        limit: limit,
        search: search,
        isActive: isActive,
      );
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AdminApplicationsResponse>> getApplications({
    int? page,
    int? limit,
    String? applicationType,
    String? status,
    String? paymentStatus,
  }) async {
    try {
      final applications = await _remoteDataSource.getApplications(
        page: page,
        limit: limit,
        applicationType: applicationType,
        status: status,
        paymentStatus: paymentStatus,
      );
      return Right(applications);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AdminStatistics>> getStatistics({
    int? year,
    int? month,
  }) async {
    try {
      final statistics = await _remoteDataSource.getStatistics(
        year: year,
        month: month,
      );
      return Right(statistics);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AdminApplicationPayment>>> getPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  }) async {
    try {
      final payments = await _remoteDataSource.getPayments(
        page: page,
        limit: limit,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        applicationId: applicationId,
      );
      return Right(payments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> getUserById(String userId) async {
    try {
      final user = await _remoteDataSource.getUserById(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AdminApplication>> getApplicationById(
    String applicationId,
  ) async {
    try {
      final application = await _remoteDataSource.getApplicationById(
        applicationId,
      );
      return Right(application);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AdminApplicationPayment>> getPaymentById(
    String paymentId,
  ) async {
    try {
      final payment = await _remoteDataSource.getPaymentById(paymentId);
      return Right(payment);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // Admin
  @override
  Future<Either<Failure, CreateUserResponse>> createUser(
    CreateUserRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.createUser(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DefaultResponse>> updateUser(
    UpdateUserInfoRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.updateUser(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UpdateUserStatusResponse>> activateUser(
    ActivateUserRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.activateUser(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UpdateUserStatusResponse>> deactivateUser(
    DeactivateUserRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.deactivateUser(request);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}
