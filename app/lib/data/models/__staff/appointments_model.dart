import 'package:equatable/equatable.dart';

class CustomerAppointments extends Equatable {
  final List<CustomerAppointment> appointments;
  final ApplicationStatistics statistics;
  final ApplicationFilter filter;

  const CustomerAppointments({
    required this.appointments,
    required this.statistics,
    required this.filter,
  });

  factory CustomerAppointments.fromJson(Map<String, dynamic> json) {
    return CustomerAppointments(
      appointments: (json['applications'] is List)
          ? (json['applications'] as List)
                .whereType<Map<String, dynamic>>()
                .map(CustomerAppointment.fromJson)
                .toList()
          : [],
      statistics: json['statistics'] is Map<String, dynamic>
          ? ApplicationStatistics.fromJson(json['statistics'])
          : const ApplicationStatistics(
              total: 0,
              grooming: 0,
              boarding: 0,
              homeService: 0,
            ),
      filter: json['filter'] is Map<String, dynamic>
          ? ApplicationFilter.fromJson(json['filter'])
          : const ApplicationFilter(status: '', applicationType: ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'applications': appointments.map((e) => e.toJson()).toList(),
    'statistics': statistics.toJson(),
    'filter': filter.toJson(),
  };

  CustomerAppointments copyWith({
    List<CustomerAppointment>? applications,
    ApplicationStatistics? statistics,
    ApplicationFilter? filter,
  }) {
    return CustomerAppointments(
      appointments: applications ?? appointments,
      statistics: statistics ?? this.statistics,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [appointments, statistics, filter];
}

class CustomerAppointment extends Equatable {
  final String id;
  final String user;
  final String applicationType;
  final UserInfo userInfo;
  final PetInfo petInfo;
  final int totalPrice;
  final int paidAmount;
  final String paymentStatus;
  final String submittedAt;
  final String branchName;
  final String status;
  final List<PaymentUpload> paymentUploads;
  final List<Payment> payments;

  const CustomerAppointment({
    required this.id,
    required this.user,
    required this.applicationType,
    required this.userInfo,
    required this.petInfo,
    required this.totalPrice,
    required this.paidAmount,
    required this.paymentStatus,
    required this.submittedAt,
    required this.branchName,
    required this.status,
    this.paymentUploads = const [],
    this.payments = const [],
  });

  factory CustomerAppointment.fromJson(Map<String, dynamic> json) {
    return CustomerAppointment(
      id: json['_id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      applicationType: json['applicationType']?.toString() ?? '',
      userInfo: json['userInfo'] is Map<String, dynamic>
          ? UserInfo.fromJson(json['userInfo'])
          : const UserInfo(
              username: '',
              email: '',
              fullName: '',
              address: '',
              phoneNumber: '',
            ),
      petInfo: json['petInfo'] is Map<String, dynamic>
          ? PetInfo.fromJson(json['petInfo'])
          : const PetInfo(name: '', breed: '', gender: ''),
      totalPrice: _safeInt(json['totalPrice']),
      paidAmount: _safeInt(json['paidAmount']),
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      branchName: json['branchName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentUploads: (json['paymentUploads'] is List)
          ? (json['paymentUploads'] as List)
                .whereType<Map<String, dynamic>>()
                .map(PaymentUpload.fromJson)
                .toList()
          : [],
      payments: (json['payments'] is List)
          ? (json['payments'] as List)
                .whereType<Map<String, dynamic>>()
                .map(Payment.fromJson)
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'applicationType': applicationType,
    'userInfo': userInfo.toJson(),
    'petInfo': petInfo.toJson(),
    'totalPrice': totalPrice,
    'paidAmount': paidAmount,
    'paymentStatus': paymentStatus,
    'submittedAt': submittedAt,
    'branchName': branchName,
    'status': status,
    'paymentUploads': paymentUploads.map((e) => e.toJson()).toList(),
    'payments': payments.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id,
    user,
    applicationType,
    userInfo,
    petInfo,
    totalPrice,
    paidAmount,
    paymentStatus,
    submittedAt,
    branchName,
    status,
    paymentUploads,
    payments,
  ];
}

// ---------- Helper for int parsing ----------
int _safeInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// ---------- Payment Models ----------

class Payment extends Equatable {
  final String id;
  final String application;
  final String applicationModel;
  final String user;
  final String accountNumber;
  final String transactionReference;
  final int amount;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentGatewayResponse;
  final String paymentType;
  final String notes;
  final String createdAt;
  final String updatedAt;

  const Payment({
    required this.id,
    required this.application,
    required this.applicationModel,
    required this.user,
    required this.accountNumber,
    required this.transactionReference,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentGatewayResponse,
    required this.paymentType,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id']?.toString() ?? '',
      application: json['application']?.toString() ?? '',
      applicationModel: json['applicationModel']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      transactionReference: json['transactionReference']?.toString() ?? '',
      amount: _safeInt(json['amount']),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      paymentGatewayResponse: json['paymentGatewayResponse']?.toString(),
      paymentType: json['paymentType']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'application': application,
    'applicationModel': applicationModel,
    'user': user,
    'accountNumber': accountNumber,
    'transactionReference': transactionReference,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'paymentGatewayResponse': paymentGatewayResponse,
    'paymentType': paymentType,
    'notes': notes,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  @override
  List<Object?> get props => [
    id,
    application,
    applicationModel,
    user,
    accountNumber,
    transactionReference,
    amount,
    paymentMethod,
    paymentStatus,
    paymentGatewayResponse,
    paymentType,
    notes,
    createdAt,
    updatedAt,
  ];
}

class PaymentUpload extends Equatable {
  final String id;
  final String application;
  final String applicationModel;
  final String url;
  final String createdAt;
  final String updatedAt;

  const PaymentUpload({
    required this.id,
    required this.application,
    required this.applicationModel,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentUpload.fromJson(Map<String, dynamic> json) {
    return PaymentUpload(
      id: json['_id']?.toString() ?? '',
      application: json['application']?.toString() ?? '',
      applicationModel: json['applicationModel']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'application': application,
    'applicationModel': applicationModel,
    'url': url,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  @override
  List<Object?> get props => [
    id,
    application,
    applicationModel,
    url,
    createdAt,
    updatedAt,
  ];
}

// ---------- User and Pet Info ----------

class UserInfo extends Equatable {
  final String username;
  final String email;
  final String fullName;
  final String address;
  final String phoneNumber;
  final String? facebookDisplayName;

  const UserInfo({
    required this.username,
    required this.email,
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    this.facebookDisplayName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      facebookDisplayName: json['facebookDisplayName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'fullName': fullName,
    'address': address,
    'phoneNumber': phoneNumber,
    'facebookDisplayName': facebookDisplayName,
  };

  @override
  List<Object?> get props => [
    username,
    email,
    fullName,
    address,
    phoneNumber,
    facebookDisplayName,
  ];
}

class PetInfo extends Equatable {
  final String name;
  final String breed;
  final String gender;

  const PetInfo({
    required this.name,
    required this.breed,
    required this.gender,
  });

  factory PetInfo.fromJson(Map<String, dynamic> json) {
    return PetInfo(
      name: json['name']?.toString() ?? '',
      breed: json['breed']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'breed': breed,
    'gender': gender,
  };

  @override
  List<Object?> get props => [name, breed, gender];
}

// ---------- Statistics & Filter ----------

class ApplicationStatistics extends Equatable {
  final int total;
  final int grooming;
  final int boarding;
  final int homeService;

  const ApplicationStatistics({
    required this.total,
    required this.grooming,
    required this.boarding,
    required this.homeService,
  });

  factory ApplicationStatistics.fromJson(Map<String, dynamic> json) {
    return ApplicationStatistics(
      total: _safeInt(json['total']),
      grooming: _safeInt(json['grooming']),
      boarding: _safeInt(json['boarding']),
      homeService: _safeInt(json['homeService']),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'grooming': grooming,
    'boarding': boarding,
    'homeService': homeService,
  };

  @override
  List<Object?> get props => [total, grooming, boarding, homeService];
}

class ApplicationFilter extends Equatable {
  final String status;
  final String applicationType;

  const ApplicationFilter({
    required this.status,
    required this.applicationType,
  });

  factory ApplicationFilter.fromJson(Map<String, dynamic> json) {
    return ApplicationFilter(
      status: json['status']?.toString() ?? '',
      applicationType: json['applicationType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'applicationType': applicationType,
  };

  @override
  List<Object?> get props => [status, applicationType];
}
