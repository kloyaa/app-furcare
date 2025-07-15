import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/datasources/remote/pet_service_remode_datasource.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';

abstract class PetServiceRepository {
  Future<Either<Failure, List<PetService>>> getPetServices();
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
}
