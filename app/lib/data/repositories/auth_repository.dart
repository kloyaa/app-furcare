import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/local/auth_local_datasource.dart';
import 'package:furcare_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:furcare_app/data/models/auth_models.dart';
import 'package:furcare_app/data/models/default_models.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);
  Future<Either<Failure, DefaultResponse>> changePassword(
    ChangePasswordRequest request,
  );

  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, String?>> getAccessToken();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> hasValidSession();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);

      // Save user data locally
      final user = User(
        username: request.username,
        accessToken: response.accessToken,
      );

      await _localDataSource.saveUser(user);
      await _localDataSource.saveAccessToken(response.accessToken);

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
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.register(request);

      // Save user data locally
      final user = User(
        email: request.email,
        username: request.username,
        accessToken: response.accessToken,
      );

      await _localDataSource.saveUser(user);
      await _localDataSource.saveAccessToken(response.accessToken);

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
  Future<Either<Failure, DefaultResponse>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.changePassword(request);
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
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final token = await _localDataSource.getAccessToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get access token'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearUserData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasValidSession() async {
    try {
      final hasSession = await _localDataSource.hasValidSession();
      return Right(hasSession);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to check session'));
    }
  }
}
