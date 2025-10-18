import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/payment.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/payment/payment.dart';
import 'package:furcare_app/data/models/payment/payment_process_request.dart';
import 'package:furcare_app/data/models/payment/payment_request.dart';
import 'package:furcare_app/data/models/payment/payment_response.dart';
import 'package:furcare_app/data/models/payment/payments.dart';
import 'package:furcare_app/data/models/payment/payment_statistics.dart';
import 'package:furcare_app/data/repositories/payment_repository.dart';

enum PaymentState {
  initial,
  loading,
  success,
  error,
  created,
  fetched,
  updated,
  processed,
  uploading,
  uploaded,
}

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider({required PaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  PaymentResponse? _paymentResponse;
  PaymentState _createPaymentState = PaymentState.initial;
  PaymentState _processPaymentState = PaymentState.initial;
  PaymentState _fetchPaymentsState = PaymentState.initial;
  PaymentState _fetchPaymentByIdState = PaymentState.initial;
  PaymentState _fetchStatisticsState = PaymentState.initial;
  PaymentState _uploadState = PaymentState.initial;
  String? _uploadMessage;

  Payments? _payments;
  Payment? _selectedPayment;
  List<PaymentStatistics> _paymentStatistics = [];

  String? _errorMessage;
  String? _errorCode;

  // Getters
  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isCreatingPayment => _createPaymentState == PaymentState.loading;
  bool get isProcessingPayment => _processPaymentState == PaymentState.loading;
  bool get isFetchingPayments => _fetchPaymentsState == PaymentState.loading;
  bool get isFetchingPaymentById =>
      _fetchPaymentByIdState == PaymentState.loading;
  bool get isFetchingStatistics =>
      _fetchStatisticsState == PaymentState.loading;

  bool get isUploading => _uploadState == PaymentState.uploading;
  String? get uploadMessage => _uploadMessage;

  Payments? get payments => _payments;
  Payment? get selectedPayment => _selectedPayment;
  List<PaymentStatistics> get paymentStatistics => _paymentStatistics;

  PaymentResponse? get paymentResponse => _paymentResponse;

  // Create Payment
  Future<void> createPayment(PaymentRequest request) async {
    clearError();
    _setCreatePaymentState(PaymentState.loading);

    final result = await _paymentRepository.createPayment(request);

    result.fold(
      (failure) {
        _setCreatePaymentState(PaymentState.error);
        _handleFailure(failure);
      },
      (response) {
        _paymentResponse = response;
        _setCreatePaymentState(PaymentState.created);
      },
    );
  }

  Future<void> uploadPaymentReceipts({
    required String application,
    required String applicationModel,
    required List<File> media,
  }) async {
    clearError();
    _uploadState = PaymentState.uploading;
    notifyListeners();

    final result = await _paymentRepository.uploadPaymentReceipts(
      application: application,
      applicationModel: applicationModel,
      media: media,
    );

    result.fold(
      (failure) {
        _uploadState = PaymentState.error;
        _handleFailure(failure);
      },
      (response) {
        _uploadMessage = response.message;
        _uploadState = PaymentState.uploaded;
      },
    );
    notifyListeners();
  }

  // Process Payment
  Future<void> processPayment(
    String paymentId,
    PaymentProcessRequest request,
  ) async {
    clearError();
    _setProcessPaymentState(PaymentState.loading);

    final result = await _paymentRepository.processPayment(paymentId, request);

    result.fold(
      (failure) {
        _setProcessPaymentState(PaymentState.error);
        _handleFailure(failure);
      },
      (response) {
        _setProcessPaymentState(PaymentState.processed);
        getPayments();
      },
    );
  }

  // Get Payments
  Future<void> getPayments({
    int? page,
    int? limit,
    String? status,
    String? method,
  }) async {
    clearError();
    _setFetchPaymentsState(PaymentState.loading);

    final result = await _paymentRepository.getPayments(
      page: page,
      limit: limit,
      status: status,
      method: method,
    );

    result.fold(
      (failure) {
        _setFetchPaymentsState(PaymentState.error);
        _handleFailure(failure);
      },
      (response) {
        _payments = response;
        _setFetchPaymentsState(PaymentState.fetched);
      },
    );
  }

  // Get Payment by ID
  Future<void> getPaymentById(String paymentId) async {
    clearError();
    _setFetchPaymentByIdState(PaymentState.loading);

    final result = await _paymentRepository.getPaymentById(paymentId);

    result.fold(
      (failure) {
        _setFetchPaymentByIdState(PaymentState.error);
        _handleFailure(failure);
      },
      (payment) {
        _selectedPayment = payment;
        _setFetchPaymentByIdState(PaymentState.fetched);
      },
    );
  }

  // Get Payment Statistics
  Future<void> getPaymentStatistics() async {
    clearError();
    _setFetchStatisticsState(PaymentState.loading);

    final result = await _paymentRepository.getPaymentStatistics();

    result.fold(
      (failure) {
        _setFetchStatisticsState(PaymentState.error);
        _handleFailure(failure);
      },
      (statistics) {
        _paymentStatistics = statistics;
        _setFetchStatisticsState(PaymentState.fetched);
      },
    );
  }

  // Load more payments (for pagination)
  Future<void> loadMorePayments({String? status, String? method}) async {
    if (_payments?.pagination.current == _payments?.pagination.total) {
      return; // No more pages to load
    }

    final nextPage = (_payments?.pagination.current ?? 0) + 1;

    final result = await _paymentRepository.getPayments(
      page: nextPage,
      status: status,
      method: method,
    );

    result.fold(
      (failure) {
        _handleFailure(failure);
      },
      (response) {
        if (_payments != null) {
          final combinedPayments = [
            ..._payments!.payments,
            ...response.payments,
          ];

          _payments = Payments(
            payments: combinedPayments,
            pagination: response.pagination,
          );
          notifyListeners();
        }
      },
    );
  }

  // State setters
  void _setCreatePaymentState(PaymentState newState) {
    _createPaymentState = newState;
    notifyListeners();
  }

  void _setProcessPaymentState(PaymentState newState) {
    _processPaymentState = newState;
    notifyListeners();
  }

  void _setFetchPaymentsState(PaymentState newState) {
    _fetchPaymentsState = newState;
    notifyListeners();
  }

  void _setFetchPaymentByIdState(PaymentState newState) {
    _fetchPaymentByIdState = newState;
    notifyListeners();
  }

  void _setFetchStatisticsState(PaymentState newState) {
    _fetchStatisticsState = newState;
    notifyListeners();
  }

  // Error handling
  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }

  // Clear selected payment
  void clearSelectedPayment() {
    _selectedPayment = null;
    notifyListeners();
  }

  // Reset all states
  void reset() {
    _createPaymentState = PaymentState.initial;
    _processPaymentState = PaymentState.initial;
    _fetchPaymentsState = PaymentState.initial;
    _fetchPaymentByIdState = PaymentState.initial;
    _fetchStatisticsState = PaymentState.initial;

    _payments = null;
    _selectedPayment = null;
    _paymentStatistics = [];

    clearError();
  }
}

class PaymentSettingsProvider extends ChangeNotifier {
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  PaymentType _paymentType = PaymentType.fullPayment;
  ApplicationModel _applicationType = ApplicationModel.homeService;

  String _notes = 'N/A';
  String _application = 'default_id';
  String _reference = 'default_reference';
  String _accountNumber = 'Savings Account';

  int _amount = 0;
  int _amountPaid = 0;

  File? _receipt;

  PaymentMethod get paymentMethod => _paymentMethod;
  PaymentType get paymentType => _paymentType;
  ApplicationModel get applicationType => _applicationType;

  String get notes => _notes;
  String get application => _application;
  String get applicationId => _application.substring(0, 12).toUpperCase();
  String get reference => _reference.toUpperCase();
  String get accountNumber => _accountNumber;

  int get amount => _amount;
  int get amountPaid => _amountPaid;

  File? get receipt => _receipt;

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setPaymentType(PaymentType type) {
    _paymentType = type;
    notifyListeners();
  }

  void setApplicationType(ApplicationModel type) {
    _applicationType = type;
    notifyListeners();
  }

  void setNotes(String note) {
    _notes = note;
    notifyListeners();
  }

  void setApplication(String id) {
    _application = id;
    notifyListeners();
  }

  void setAmount(int amount) {
    _amount = amount;
    notifyListeners();
  }

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  void setReceipt(File receipt) {
    _receipt = receipt;
    notifyListeners();
  }

  void setAccountNumber(String accountNumber) {
    _accountNumber = accountNumber;
    notifyListeners();
  }

  void setAmountPaid(int amount) {
    _amountPaid = amount;
    notifyListeners();
  }

  void reset() {
    _paymentMethod = PaymentMethod.cash;
    _paymentType = PaymentType.fullPayment;
    _applicationType = ApplicationModel.homeService;
    _notes = 'N/A';
    _application = 'default_id';
    _amount = 0;
    notifyListeners();
  }
}
