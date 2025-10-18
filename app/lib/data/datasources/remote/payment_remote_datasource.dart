import 'dart:io';

import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/default_models.dart';
import 'package:furcare_app/data/models/payment/payment.dart';
import 'package:furcare_app/data/models/payment/payment_process_request.dart';
import 'package:furcare_app/data/models/payment/payment_request.dart';
import 'package:furcare_app/data/models/payment/payment_response.dart';
import 'package:furcare_app/data/models/payment/payments.dart';
import 'package:furcare_app/data/models/payment/payment_statistics.dart';

abstract class PaymentRemoteDatasource {
  Future<PaymentResponse> createPayment(PaymentRequest request);
  Future<DefaultResponse> processPayment(
    String paymentId,
    PaymentProcessRequest request,
  );
  // ✅ NEW: Upload payment receipts
  Future<DefaultResponse> uploadPaymentReceipts({
    required String application,
    required String applicationModel,
    required List<File> media,
  });
  Future<Payments> getPayments({
    int? page,
    int? limit,
    String? status,
    String? method,
  });
  Future<Payment> getPaymentById(String paymentId);
  Future<List<PaymentStatistics>> getPaymentStatistics();
}

class PaymentRemoteDatasourceImpl implements PaymentRemoteDatasource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  PaymentRemoteDatasourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<PaymentResponse> createPayment(PaymentRequest request) async {
    try {
      final response = await _networkService.post(
        data: request.toJson(),
        ApiConstants.payments,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 201) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error creating payment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during payment creation',
      );
    }
  }

  @override
  Future<DefaultResponse> uploadPaymentReceipts({
    required String application,
    required String applicationModel,
    required List<File> media,
  }) async {
    try {
      final headers = await _authHeaderProvider.getHeaders();
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('application', application),
        MapEntry('applicationModel', applicationModel),
      ]);

      const uploadField = 'media'; // must match backend

      for (final file in media) {
        formData.files.add(
          MapEntry(
            uploadField,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: DioMediaType('image', 'jpeg'), // <— explicit mime
            ),
          ),
        );
      }

      final response = await _networkService.post(
        ApiConstants.uploadPaymentReceipts,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Failed to upload receipts',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      print('❌ Upload error: $e');
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Error uploading receipts');
    }
  }

  @override
  Future<DefaultResponse> processPayment(
    String paymentId,
    PaymentProcessRequest request,
  ) async {
    try {
      final response = await _networkService.post(
        data: request.toJson(),
        "${ApiConstants.payments}/$paymentId/process",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return DefaultResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error processing payment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during payment processing',
      );
    }
  }

  @override
  Future<Payments> getPayments({
    int? page,
    int? limit,
    String? status,
    String? method,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;
      if (status != null) queryParameters['status'] = status;
      if (method != null) queryParameters['method'] = method;

      final response = await _networkService.get(
        ApiConstants.payments,
        queryParameters: queryParameters,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return Payments.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching payments',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching payments',
      );
    }
  }

  @override
  Future<Payment> getPaymentById(String paymentId) async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.payments}/$paymentId",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        return Payment.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching payment',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching payment',
      );
    }
  }

  @override
  Future<List<PaymentStatistics>> getPaymentStatistics() async {
    try {
      final response = await _networkService.get(
        "${ApiConstants.payments}/statistics",
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => PaymentStatistics.fromJson(item)).toList();
      } else {
        throw ServerException(
          message:
              response.data?['message'] ?? 'Error fetching payment statistics',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching payment statistics',
      );
    }
  }
}
