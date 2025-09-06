import 'package:equatable/equatable.dart';

class AdminApplicationPayment extends Equatable {
  final String id;
  final String applicationId;
  final String applicationModel;
  final AdminPaymentUser user;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentType;
  final String transactionId;
  final String notes;
  final String createdAt;
  final String updatedAt;

  const AdminApplicationPayment({
    required this.id,
    required this.applicationId,
    required this.applicationModel,
    required this.user,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentType,
    required this.transactionId,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminApplicationPayment.fromJson(Map<String, dynamic> json) {
    return AdminApplicationPayment(
      id: json['_id'] as String? ?? '',
      applicationId: json['applicationId'] as String? ?? '',
      applicationModel: json['applicationModel'] as String? ?? '',
      user: AdminPaymentUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paymentType: json['paymentType'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'applicationId': applicationId,
      'applicationModel': applicationModel,
      'user': user.toJson(),
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentType': paymentType,
      'transactionId': transactionId,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  bool get isCompleted => paymentStatus == 'completed';
  bool get isPending => paymentStatus == 'pending';
  bool get isFailed => paymentStatus == 'failed';

  bool get isGCash => paymentMethod.toLowerCase() == 'gcash';
  bool get isCash => paymentMethod.toLowerCase() == 'cash';

  bool get isFullPayment => paymentType == 'full_payment';
  bool get isPartialPayment => paymentType == 'partial_payment';

  String get applicationTypeFromModel {
    switch (applicationModel.toLowerCase()) {
      case 'groomingapplication':
        return 'Grooming';
      case 'boardingapplication':
        return 'Boarding';
      case 'homeserviceapplication':
        return 'Home Service';
      default:
        return applicationModel;
    }
  }

  @override
  List<Object?> get props => [
    id,
    applicationId,
    applicationModel,
    user,
    amount,
    paymentMethod,
    paymentStatus,
    paymentType,
    transactionId,
    notes,
    createdAt,
    updatedAt,
  ];
}

class AdminPaymentUser extends Equatable {
  final String id;
  final String username;
  final String email;

  const AdminPaymentUser({
    required this.id,
    required this.username,
    required this.email,
  });

  factory AdminPaymentUser.fromJson(Map<String, dynamic> json) {
    return AdminPaymentUser(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'username': username, 'email': email};
  }

  @override
  List<Object?> get props => [id, username, email];
}
