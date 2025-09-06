import 'package:equatable/equatable.dart';

class AdminApplicationsResponse extends Equatable {
  final List<AdminApplication> applications;
  final AdminPagination pagination;

  const AdminApplicationsResponse({
    required this.applications,
    required this.pagination,
  });

  factory AdminApplicationsResponse.fromJson(Map<String, dynamic> json) {
    return AdminApplicationsResponse(
      applications:
          (json['applications'] as List<dynamic>?)
              ?.map(
                (item) =>
                    AdminApplication.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: AdminPagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applications': applications.map((app) => app.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  @override
  List<Object?> get props => [applications, pagination];
}

// Individual Admin Application
class AdminApplication extends Equatable {
  final String id;
  final String applicationType;
  final AdminApplicationUser user;
  final AdminApplicationPet pet;
  final AdminApplicationBranch branch;
  final double totalPrice;
  final double paidAmount;
  final String paymentStatus;
  final String status;
  final String createdAt;
  final String? scheduleCode;
  final List<String>? groomingOptions;

  const AdminApplication({
    required this.id,
    required this.applicationType,
    required this.user,
    required this.pet,
    required this.branch,
    required this.totalPrice,
    required this.paidAmount,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    this.scheduleCode,
    this.groomingOptions,
  });

  factory AdminApplication.fromJson(Map<String, dynamic> json) {
    return AdminApplication(
      id: json['_id'] as String? ?? '',
      applicationType: json['applicationType'] as String? ?? '',
      user: AdminApplicationUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      pet: AdminApplicationPet.fromJson(
        json['pet'] as Map<String, dynamic>? ?? {},
      ),
      branch: AdminApplicationBranch.fromJson(
        json['branch'] as Map<String, dynamic>? ?? {},
      ),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      scheduleCode: json['scheduleCode'] as String?,
      groomingOptions: (json['groomingOptions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'applicationType': applicationType,
      'user': user.toJson(),
      'pet': pet.toJson(),
      'branch': branch.toJson(),
      'totalPrice': totalPrice,
      'paidAmount': paidAmount,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': createdAt,
      'scheduleCode': scheduleCode,
      'groomingOptions': groomingOptions,
    };
  }

  double get remainingBalance => totalPrice - paidAmount;

  bool get isFullyPaid => paymentStatus == 'fully_paid';
  bool get isPartiallyPaid => paymentStatus == 'partially_paid';
  bool get isUnpaid => paymentStatus == 'unpaid';

  @override
  List<Object?> get props => [
    id,
    applicationType,
    user,
    pet,
    branch,
    totalPrice,
    paidAmount,
    paymentStatus,
    status,
    createdAt,
    scheduleCode,
    groomingOptions,
  ];
}

class AdminApplicationUser extends Equatable {
  final String id;
  final String username;
  final String email;

  const AdminApplicationUser({
    required this.id,
    required this.username,
    required this.email,
  });

  factory AdminApplicationUser.fromJson(Map<String, dynamic> json) {
    return AdminApplicationUser(
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

class AdminApplicationPet extends Equatable {
  final String id;
  final String name;
  final String specie;

  const AdminApplicationPet({
    required this.id,
    required this.name,
    required this.specie,
  });

  factory AdminApplicationPet.fromJson(Map<String, dynamic> json) {
    return AdminApplicationPet(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specie: json['specie'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'specie': specie};
  }

  @override
  List<Object?> get props => [id, name, specie];
}

class AdminApplicationBranch extends Equatable {
  final String id;
  final String name;

  const AdminApplicationBranch({required this.id, required this.name});

  factory AdminApplicationBranch.fromJson(Map<String, dynamic> json) {
    return AdminApplicationBranch(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}

class AdminPagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  const AdminPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory AdminPagination.fromJson(Map<String, dynamic> json) {
    return AdminPagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
  ];
}
