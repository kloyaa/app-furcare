enum ApplicationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  completed('completed'),
  cancelled('cancelled');

  const ApplicationStatus(this.value);
  final String value;

  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.completed:
        return 'Completed';
      case ApplicationStatus.cancelled:
        return 'Cancelled';
    }
  }

  static ApplicationStatus fromString(String status) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

enum ApplicationModel {
  homeService('HomeServiceApplication'),
  boarding('BoardingApplication'),
  grooming('GroomingApplication'),
  empty('EmptyApplication');

  const ApplicationModel(this.value);
  final String value;

  static ApplicationModel fromString(String value) {
    return ApplicationModel.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ApplicationModel.grooming,
    );
  }

  static ApplicationModel fromStringToModel(String value) {
    switch (value) {
      case 'boarding':
        return ApplicationModel.boarding;
      case 'homeService':
        return ApplicationModel.homeService;
      case 'grooming':
        return ApplicationModel.grooming;
      default:
        return ApplicationModel.empty;
    }
  }
}
