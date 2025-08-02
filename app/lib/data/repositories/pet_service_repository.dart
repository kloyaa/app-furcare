import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/pet_service_remote_datasource.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';

abstract class PetServiceRepository {
  Future<Either<Failure, List<PetService>>> getPetServices();
  Future<Either<Failure, List<GroomingSchedule>>> getGroomingSchedules();
  Future<Either<Failure, List<GroomingOptions>>> getGroomingOptions();
  Future<Either<Failure, List<GroomingPreference>>> getGroomingPreferences();
  Future<Either<Failure, List<PetCage>>> getPetCages();
}

class PetServiceRepositoryImpl implements PetServiceRepository {
  final PetServiceRemoteDataSource _remoteDataSource;

  PetServiceRepositoryImpl({
    required PetServiceRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<PetService>>> getPetServices() async {
    try {
      final response = await _remoteDataSource.getPetServices();
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
  Future<Either<Failure, List<GroomingSchedule>>> getGroomingSchedules() async {
    try {
      final response = await _remoteDataSource.getGroomingSchedules();
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
  Future<Either<Failure, List<GroomingOptions>>> getGroomingOptions() async {
    try {
      final response = await _remoteDataSource.getGroomingOptions();
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
  Future<Either<Failure, List<GroomingPreference>>>
  getGroomingPreferences() async {
    try {
      final response = await _remoteDataSource.getGroomingPreferences();
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
  Future<Either<Failure, List<PetCage>>> getPetCages() async {
    try {
      final response = await _remoteDataSource.getPetCages();
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
