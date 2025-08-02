import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/pet_remote_datasource.dart';
import 'package:furcare_app/data/models/default_models.dart';
import 'package:furcare_app/data/models/pet_models.dart';

abstract class PetRepository {
  Future<Either<Failure, List<Pet>>> getPets();
  Future<Either<Failure, Pet>> createPet(RequestPet pet);
  Future<Either<Failure, Pet>> updatePet(UpdatePet pet);
  Future<Either<Failure, DefaultResponse>> deletePet(String id);
}

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource _remoteDataSource;

  PetRepositoryImpl({required PetRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Pet>>> getPets() async {
    try {
      final response = await _remoteDataSource.getPets();
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
  Future<Either<Failure, Pet>> createPet(RequestPet pet) async {
    try {
      final response = await _remoteDataSource.createPet(pet);
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
  Future<Either<Failure, Pet>> updatePet(UpdatePet pet) async {
    try {
      final response = await _remoteDataSource.updatePet(pet);
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
  Future<Either<Failure, DefaultResponse>> deletePet(String id) async {
    try {
      final response = await _remoteDataSource.deletePet(id);
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
