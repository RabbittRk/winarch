import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:winarch/core/network/no_connectivity_exception.dart';
import 'package:winarch/features/auth/data/api/auth_api.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required AuthApi api}) : _api = api;

  final AuthApi _api;

  @override
  Future<Either<String, AuthResponse>> login({
    required String username,
    required String password,
  }) async {
    try {
      // TODO: Remove this after testing
      username = 'emilys';
      password = 'emilyspass';

      final response = await _api.login({
        'username': username,
        'password': password,
      });
      return Right(response);
    } on DioException catch (e) {
      if (e.error is NoConnectivityException) {
        return const Left('No network connection');
      }
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString() ?? e.message
          : e.message;
      return Left(message ?? 'Login failed');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
