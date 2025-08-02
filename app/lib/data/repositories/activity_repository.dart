import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/activity_remote_datasource.dart';
import 'package:furcare_app/data/models/activity_log_models.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<ActivityLog>>> getActivities();
  // Future<Either<Failure, void>> deleteProfile();
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDatasource _remoteDataSource;

  ActivityRepositoryImpl({required ActivityRemoteDatasource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<ActivityLog>>> getActivities() async {
    try {
      final response = await _remoteDataSource.getActivities();
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
