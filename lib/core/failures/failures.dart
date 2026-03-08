/// Base for domain/data layer failures.
sealed class Failure {
  const Failure();
  String get message;
}

/// No network connectivity when making a request.
class NoConnectivityFailure extends Failure {
  const NoConnectivityFailure();

  @override
  String get message => 'No network connection';
}
