import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:winarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';

/// Login endpoint path. Align with your backend.
const _loginPath = '/auth/login';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Either<String, AuthResponse>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _loginPath,
      data: {'username': username, 'password': password},
    );
    final data = response.data;
    if (data == null) {
      return Left('Empty login response');
    }
    return Right(AuthResponse.fromJson(data));
  }
}
