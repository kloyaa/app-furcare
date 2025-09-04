enum ApplicationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  inProgress('in-progress'),
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
      case ApplicationStatus.inProgress:
        return 'In Progress';
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
