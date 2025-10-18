import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/datasources/remote/payment_remote_datasource.dart';
import 'package:furcare_app/data/models/default_models.dart';
import 'package:furcare_app/data/models/payment/payment.dart';
import 'package:furcare_app/data/models/payment/payment_process_request.dart';
import 'package:furcare_app/data/models/payment/payment_request.dart';
import 'package:furcare_app/data/models/payment/payment_response.dart';
import 'package:furcare_app/data/models/payment/payments.dart';
import 'package:furcare_app/data/models/payment/payment_statistics.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentResponse>> createPayment(
    PaymentRequest request,
  );

  Future<Either<Failure, DefaultResponse>> processPayment(
    String paymentId,
    PaymentProcessRequest request,
  );

  Future<Either<Failure, DefaultResponse>> uploadPaymentReceipts({
    required String application,
    required String applicationModel,
    required List<File> media,
  });

  Future<Either<Failure, Payments>> getPayments({
    int? page,
    int? limit,
    String? status,
    String? method,
  });

  Future<Either<Failure, Payment>> getPaymentById(String paymentId);

  Future<Either<Failure, List<PaymentStatistics>>> getPaymentStatistics();
}

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDatasource _remoteDataSource;

  PaymentRepositoryImpl({required PaymentRemoteDatasource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, PaymentResponse>> createPayment(
    PaymentRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.createPayment(request);
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
  Future<Either<Failure, DefaultResponse>> processPayment(
    String paymentId,
    PaymentProcessRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.processPayment(
        paymentId,
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
  Future<Either<Failure, DefaultResponse>> uploadPaymentReceipts({
    required String application,
    required String applicationModel,
    required List<File> media,
  }) async {
    try {
      final response = await _remoteDataSource.uploadPaymentReceipts(
        application: application,
        applicationModel: applicationModel,
        media: media,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (_) {
      return Left(ServerFailure(message: 'Error uploading receipts'));
    }
  }

  @override
  Future<Either<Failure, Payments>> getPayments({
    int? page,
    int? limit,
    String? status,
    String? method,
  }) async {
    try {
      final response = await _remoteDataSource.getPayments(
        page: page,
        limit: limit,
        status: status,
        method: method,
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
  Future<Either<Failure, Payment>> getPaymentById(String paymentId) async {
    try {
      final response = await _remoteDataSource.getPaymentById(paymentId);
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
  Future<Either<Failure, List<PaymentStatistics>>>
  getPaymentStatistics() async {
    try {
      final response = await _remoteDataSource.getPaymentStatistics();
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
