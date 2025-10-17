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
      appointments:
          (json['applications'] as List<dynamic>?)
              ?.map(
                (item) =>
                    CustomerAppointment.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      statistics: ApplicationStatistics.fromJson(
        json['statistics'] as Map<String, dynamic>,
      ),
      filter: ApplicationFilter.fromJson(
        json['filter'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applications': appointments.map((app) => app.toJson()).toList(),
      'statistics': statistics.toJson(),
      'filter': filter.toJson(),
    };
  }

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
  final List<Payment> payments; // <-- new property

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
      id: json['_id'] as String? ?? '',
      user: json['user'] as String? ?? '',
      applicationType: json['applicationType'] as String? ?? '',
      userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
      petInfo: PetInfo.fromJson(json['petInfo'] as Map<String, dynamic>),
      totalPrice: json['totalPrice'] as int? ?? 0,
      paidAmount: json['paidAmount'] as int? ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      submittedAt: json['submittedAt'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      paymentUploads:
          (json['paymentUploads'] as List<dynamic>?)
              ?.map((e) => PaymentUpload.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  }

  CustomerAppointment copyWith({
    String? id,
    String? user,
    String? applicationType,
    UserInfo? userInfo,
    PetInfo? petInfo,
    int? totalPrice,
    int? paidAmount,
    String? paymentStatus,
    String? submittedAt,
    String? branchName,
    String? status,
    List<PaymentUpload>? paymentUploads,
    List<Payment>? payments,
  }) {
    return CustomerAppointment(
      id: id ?? this.id,
      user: user ?? this.user,
      applicationType: applicationType ?? this.applicationType,
      userInfo: userInfo ?? this.userInfo,
      petInfo: petInfo ?? this.petInfo,
      totalPrice: totalPrice ?? this.totalPrice,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      submittedAt: submittedAt ?? this.submittedAt,
      branchName: branchName ?? this.branchName,
      status: status ?? this.status,
      paymentUploads: paymentUploads ?? this.paymentUploads,
      payments: payments ?? this.payments,
    );
  }

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
      id: json['_id'] as String? ?? '',
      application: json['application'] as String? ?? '',
      applicationModel: json['applicationModel'] as String? ?? '',
      user: json['user'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      transactionReference: json['transactionReference'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paymentGatewayResponse: json['paymentGatewayResponse'] as String?,
      paymentType: json['paymentType'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  }

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
      id: json['_id'] as String? ?? '',
      application: json['application'] as String? ?? '',
      applicationModel: json['applicationModel'] as String? ?? '',
      url: json['url'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'application': application,
      'applicationModel': applicationModel,
      'url': url,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

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
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      facebookDisplayName: json['facebookDisplayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'facebookDisplayName': facebookDisplayName,
    };
  }

  UserInfo copyWith({
    String? username,
    String? email,
    String? fullName,
    String? address,
    String? phoneNumber,
    String? facebookDisplayName,
  }) {
    return UserInfo(
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      facebookDisplayName: facebookDisplayName ?? this.facebookDisplayName,
    );
  }

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
      name: json['name'] as String? ?? '',
      breed: json['breed'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'breed': breed, 'gender': gender};
  }

  PetInfo copyWith({String? name, String? breed, String? gender}) {
    return PetInfo(
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [name, breed, gender];
}

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
      total: json['total'] as int? ?? 0,
      grooming: json['grooming'] as int? ?? 0,
      boarding: json['boarding'] as int? ?? 0,
      homeService: json['homeService'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'grooming': grooming,
      'boarding': boarding,
      'homeService': homeService,
    };
  }

  ApplicationStatistics copyWith({
    int? total,
    int? grooming,
    int? boarding,
    int? homeService,
  }) {
    return ApplicationStatistics(
      total: total ?? this.total,
      grooming: grooming ?? this.grooming,
      boarding: boarding ?? this.boarding,
      homeService: homeService ?? this.homeService,
    );
  }

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
      status: json['status'] as String? ?? '',
      applicationType: json['applicationType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'applicationType': applicationType};
  }

  ApplicationFilter copyWith({String? status, String? applicationType}) {
    return ApplicationFilter(
      status: status ?? this.status,
      applicationType: applicationType ?? this.applicationType,
    );
  }

  @override
  List<Object?> get props => [status, applicationType];
}
