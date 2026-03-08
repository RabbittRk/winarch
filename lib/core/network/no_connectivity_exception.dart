/// Thrown when a request is blocked because the device has no connectivity.
class NoConnectivityException implements Exception {
  const NoConnectivityException();

  @override
  String toString() => 'NoConnectivityException: No network connection';
}
