import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:winarch/features/auth/data/models/auth_response.dart';

part 'auth_api.retrofit.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);
}
