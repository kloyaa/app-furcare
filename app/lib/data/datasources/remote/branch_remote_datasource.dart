import 'package:dio/dio.dart';
import 'package:furcare_app/core/constants/api_constants.dart';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/models/branch_models.dart';

abstract class BranchRemoteDataSource {
  Future<List<Branch>> getBranches();
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final NetworkService _networkService;
  final AuthHeaderProvider _authHeaderProvider;

  BranchRemoteDataSourceImpl({
    required NetworkService networkService,
    required AuthHeaderProvider authHeaderProvider,
  }) : _networkService = networkService,
       _authHeaderProvider = authHeaderProvider;

  @override
  Future<List<Branch>> getBranches() async {
    try {
      final response = await _networkService.get(
        ApiConstants.branches,
        options: Options(headers: await _authHeaderProvider.getHeaders()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Branch.fromJson(item)).toList();
      } else {
        throw ServerException(
          message: response.data?['message'] ?? 'Error fetching branches',
          code: response.data?['code'],
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'An error occurred during fetching pet branches',
      );
    }
  }
}
