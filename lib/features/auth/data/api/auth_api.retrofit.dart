// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AuthApi implements AuthApi {
  _AuthApi(this._dio, {this.baseUrl}) {
    baseUrl ??= _dio.options.baseUrl;
  }

  final Dio _dio;
  String? baseUrl;

  @override
  Future<AuthResponse> login(Map<String, dynamic> body) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = body;
    final result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<AuthResponse>(
        Options(
          method: 'POST',
          headers: headers,
          extra: extra,
        ).compose(
          _dio.options,
          '/auth/login',
          data: data,
          queryParameters: queryParameters,
        ),
      ),
    );
    final value = AuthResponse.fromJson(result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      return requestOptions.copyWith(responseType: ResponseType.plain);
    }
    return requestOptions;
  }
}
