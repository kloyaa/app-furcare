import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:flutter_application_1/data/models/appointment_models.dart';
import 'package:flutter_application_1/data/models/default_models.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, DefaultResponse>> createGroomingAppointment(
    GroomingAppointmentRequest request,
  );

  Future<Either<Failure, List<GroomingAppointment>>> getGroomingAppointments();
}

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDatasource _remoteDataSource;

  AppointmentRepositoryImpl({
    required AppointmentRemoteDatasource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DefaultResponse>> createGroomingAppointment(
    GroomingAppointmentRequest pet,
  ) async {
    try {
      final response = await _remoteDataSource.createGroomingAppointment(pet);
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
  Future<Either<Failure, List<GroomingAppointment>>>
  getGroomingAppointments() async {
    try {
      final response = await _remoteDataSource.getGroomingAppointments();
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
