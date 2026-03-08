import 'package:dio/dio.dart';
import 'package:winarch/core/connectivity/connectivity_service.dart';
import 'package:winarch/core/network/no_connectivity_exception.dart';

/// Interceptor that fails requests immediately when the device is offline.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required ConnectivityService connectivity})
      : _connectivity = connectivity;

  final ConnectivityService _connectivity;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasConnection = await _connectivity.hasConnection;
    if (!hasConnection) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const NoConnectivityException(),
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }
    handler.next(options);
  }
}
