import 'package:flutter/foundation.dart';
import 'package:furcare_app/core/errors/failures.dart';
import 'package:furcare_app/data/models/branch_models.dart';
import 'package:furcare_app/data/repositories/branch_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BranchState {
  initial,
  loading,
  success,
  error,
  created,
  fetched,
  updated,
  deleted,
}

class BranchProvider with ChangeNotifier {
  final BranchRepository _branchRepository;

  BranchProvider({required BranchRepository branchRepository})
    : _branchRepository = branchRepository;

  Branch? _selectedBranch;

  BranchState _fetchApplicationState = BranchState.initial;

  List<Branch> _branches = [];

  String? _errorMessage;
  String? _errorCode;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get hasSelectedBranch => _selectedBranch != null;
  Branch? get selectedBranch => _selectedBranch;

  List<Branch> get branches => _branches;

  bool get isFetchingApplication =>
      _fetchApplicationState == BranchState.loading;

  Future<void> fetchBranches() async {
    clearError();
    _setFetchBranches(BranchState.loading);

    final result = await _branchRepository.getBranches();

    result.fold(
      (failure) {
        _setFetchBranches(BranchState.error);
        _handleFailure(failure);
      },
      (branches) {
        _branches = branches;
        _setFetchBranches(BranchState.created);
        // getPets();
      },
    );
  }

  // Save selected branch to local storage
  Future<void> setSelectedBranch(Branch branch) async {
    try {
      _selectedBranch = branch;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_branch_id', branch.id);

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save selected branch';
      notifyListeners();
    }
  }

  void _setFetchBranches(BranchState newState) {
    _fetchApplicationState = newState;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _errorCode = failure.code;
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
