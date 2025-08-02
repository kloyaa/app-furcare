import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/branch_remote_datasource.dart';
import 'package:furcare_app/data/models/branch_models.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<Branch>>> getBranches();
}

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource _remoteDataSource;

  BranchRepositoryImpl({required BranchRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Branch>>> getBranches() async {
    try {
      final response = await _remoteDataSource.getBranches();
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
