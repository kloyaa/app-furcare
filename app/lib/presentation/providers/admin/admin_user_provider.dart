import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/__admin/admin_create_user_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/base_admin_provider.dart';

class AdminUserProvider extends BaseAdminProvider {
  final AdminRepository _repository;

  AdminUserProvider({required AdminRepository repository})
    : _repository = repository;

  AdminState _state = AdminState.initial;
  AdminState _createState = AdminState.initial;
  AdminState _updateState = AdminState.initial;
  AdminState _refreshState = AdminState.initial;

  List<AdminUser> _users = [];
  String? _searchQuery;
  bool? _activeFilter;

  // Getters
  AdminState get state => _state;
  AdminState get createState => _createState;
  AdminState get updateState => _updateState;
  AdminState get refreshState => _refreshState;

  List<AdminUser> get users => _users;
  bool get isLoading => _state == AdminState.loading;
  bool get isCreating => _createState == AdminState.loading;
  bool get isUpdating => _updateState == AdminState.loading;
  bool get isRefreshing => _refreshState == AdminState.loading;

  String? get searchQuery => _searchQuery;
  bool? get activeFilter => _activeFilter;

  // Analytics
  int get totalCount => _users.length;
  int get activeCount => _users.where((user) => user.isActive).length;
  int get inactiveCount => _users.where((user) => !user.isActive).length;

  // Methods
  // In your AdminUserProvider, update the fetchUsers method:

  Future<void> fetchUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    _setState(AdminState.loading);
    _searchQuery = search;
    _activeFilter = isActive;

    final result = await _repository.getUsers(
      page: page,
      limit: limit,
      search: search,
      isActive: isActive,
    );

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setState(AdminState.error);
      },
      (users) {
        _users = users;
        clearError(); // Clear any previous errors
        _setState(AdminState.fetched);
      },
    );
  }

  Future<void> createUser(CreateUserRequest request) async {
    _setCreateState(AdminState.loading);

    final result = await _repository.createUser(request);

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setCreateState(AdminState.error);
      },
      (response) {
        clearError();
        if (response.success && response.user != null) {
          _users.insert(0, response.user!);
        }
        _setCreateState(AdminState.success);
        refreshUsers();
      },
    );
  }

  Future<void> updateUser(UpdateUserInfoRequest request) async {
    _setUpdateState(AdminState.loading);

    final result = await _repository.updateUser(request);

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setUpdateState(AdminState.error);
      },
      (response) {
        clearError();
        _setUpdateState(AdminState.success);
        refreshUsers();
      },
    );
  }

  Future<void> activateUser(ActivateUserRequest request) async {
    final result = await _repository.activateUser(request);
    result.fold((failure) => handleError(failure.message, failure.code), (
      response,
    ) {
      clearError();
      refreshUsers();
    });
  }

  Future<void> deactivateUser(DeactivateUserRequest request) async {
    final result = await _repository.deactivateUser(request);
    result.fold((failure) => handleError(failure.message, failure.code), (
      response,
    ) {
      clearError();
      refreshUsers();
    });
  }

  Future<void> refreshUsers() async {
    _setRefreshState(AdminState.loading);
    final result = await _repository.getUsers(
      search: _searchQuery,
      isActive: _activeFilter,
    );

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setRefreshState(AdminState.error);
      },
      (users) {
        _users = users;
        clearError(); // Clear any previous errors
        _setRefreshState(AdminState.fetched);
      },
    );
  }

  // Search and filter
  void searchUsers(String? query) => fetchUsers(search: query);
  void filterByStatus(bool? isActive) => fetchUsers(isActive: isActive);

  void clearFilters() {
    _searchQuery = null;
    _activeFilter = null;
    fetchUsers();
  }

  // Reset states
  void resetCreateState() {
    _createState = AdminState.initial;
    notifyListeners();
  }

  void resetUpdateState() {
    _updateState = AdminState.initial;
    notifyListeners();
  }

  // Private methods
  void _setState(AdminState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setCreateState(AdminState newState) {
    _createState = newState;
    notifyListeners();
  }

  void _setUpdateState(AdminState newState) {
    _updateState = newState;
    notifyListeners();
  }

  void _setRefreshState(AdminState newState) {
    _refreshState = newState;
    notifyListeners();
  }
}
