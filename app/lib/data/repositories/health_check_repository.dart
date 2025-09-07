// File: lib/data/repositories/health_check_repository.dart

import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/health_check_datasource.dart';
import 'package:furcare_app/data/models/health_check_models.dart';

abstract class HealthCheckRepository {
  Future<Either<Failure, HealthCheckResponse>> getHealthStatus();
}

class HealthCheckRepositoryImpl implements HealthCheckRepository {
  final HealthCheckRemoteDataSource _remoteDataSource;

  HealthCheckRepositoryImpl({
    required HealthCheckRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, HealthCheckResponse>> getHealthStatus() async {
    try {
      final response = await _remoteDataSource.getHealthStatus();
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
