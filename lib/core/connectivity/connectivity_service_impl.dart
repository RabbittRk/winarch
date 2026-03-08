import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:winarch/core/connectivity/connectivity_service.dart';

/// Implementation using connectivity_plus. Maps platform connectivity to bool.
class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _resultToBool(List<ConnectivityResult> result) {
    if (result.isEmpty) return false;
    return result.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
  }

  @override
  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return _resultToBool(result);
  }

  @override
  Stream<bool> get isConnectedStream =>
      _connectivity.onConnectivityChanged.map(_resultToBool);
}
