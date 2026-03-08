/// Abstraction for network connectivity. Used by Dio interceptor and presentation.
abstract class ConnectivityService {
  /// Returns true if the device has network connectivity.
  Future<bool> get hasConnection;

  /// Stream of connectivity status. Emits true when connected, false when disconnected.
  Stream<bool> get isConnectedStream;
}
