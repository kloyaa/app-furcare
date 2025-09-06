import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:furcare_app/data/models/__staff/appointment_request.dart';
import 'package:furcare_app/data/models/__staff/appointment_update_response.dart';
import 'package:furcare_app/data/models/__staff/appointments_model.dart';
import 'package:furcare_app/data/models/boarding/boarding.dart';
import 'package:furcare_app/data/models/boarding/boarding_request.dart';
import 'package:furcare_app/data/models/default_models.dart';
import 'package:furcare_app/data/models/grooming/grooming.dart';
import 'package:furcare_app/data/models/grooming/grooming_request.dart';
import 'package:furcare_app/data/models/home_service/home_service.dart';
import 'package:furcare_app/data/models/home_service/home_service_request.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, DefaultResponse>> createGroomingAppointment(
    GroomingAppointmentRequest request,
  );

  Future<Either<Failure, DefaultResponse>> createBoardingAppointment(
    BoardingAppointmentRequest request,
  );

  Future<Either<Failure, DefaultResponse>> createHomeServiceAppointment(
    HomeServiceAppointmentRequest request,
  );

  Future<Either<Failure, List<GroomingAppointment>>> getGroomingAppointments();
  Future<Either<Failure, List<BoardingAppointment>>> getBoardingAppointments();
  Future<Either<Failure, List<HomeServiceAppointment>>>
  getHomeServiceAppointments();

  Future<Either<Failure, DefaultResponse>> createBoardingAppointmentExtension(
    AppointmentExtensionRequest request,
  );

  // Staff
  Future<Either<Failure, CustomerAppointments>> fetchNewAppointmentsByStatus(
    ApplicationStatus status,
  );

  Future<Either<Failure, AppointmentStatusUpdateResponse>>
  updateAppointmentStatus(AppointmentStatusUpdateRequest request);
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
  Future<Either<Failure, DefaultResponse>> createBoardingAppointment(
    BoardingAppointmentRequest pet,
  ) async {
    try {
      final response = await _remoteDataSource.createBoardingAppointment(pet);
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

  @override
  Future<Either<Failure, List<BoardingAppointment>>>
  getBoardingAppointments() async {
    try {
      final response = await _remoteDataSource.getBoardingAppointments();
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
  Future<Either<Failure, List<HomeServiceAppointment>>>
  getHomeServiceAppointments() async {
    try {
      final response = await _remoteDataSource.getHomeServiceAppointments();
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
  Future<Either<Failure, DefaultResponse>> createHomeServiceAppointment(
    HomeServiceAppointmentRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.createHomeServiceAppointment(
        request,
      );
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
  Future<Either<Failure, DefaultResponse>> createBoardingAppointmentExtension(
    AppointmentExtensionRequest request,
  ) async {
    try {
      final response = await _remoteDataSource
          .createBoardingAppointmentExtension(request);
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

  // Staff
  @override
  Future<Either<Failure, CustomerAppointments>> fetchNewAppointmentsByStatus(
    ApplicationStatus status,
  ) async {
    try {
      final response = await _remoteDataSource.fetchNewAppointmentsByStatus(
        status,
      );
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
  Future<Either<Failure, AppointmentStatusUpdateResponse>>
  updateAppointmentStatus(AppointmentStatusUpdateRequest request) async {
    try {
      final response = await _remoteDataSource.updateAppointmentStatus(request);
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
