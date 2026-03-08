/// Async phase for login (idle, loading, success, failure).
sealed class LoginStatus {
  const LoginStatus();
}

class LoginStatusIdle extends LoginStatus {
  const LoginStatusIdle();
}

class LoginStatusLoading extends LoginStatus {
  const LoginStatusLoading();
}

class LoginStatusSuccess extends LoginStatus {
  const LoginStatusSuccess();
}

class LoginStatusFailure extends LoginStatus {
  const LoginStatusFailure();
}

/// Immutable state for the login screen: all presentation variables.
class LoginState {
  const LoginState({
    this.username = '',
    this.password = '',
    this.isPasswordObscure = true,
    this.status = const LoginStatusIdle(),
    this.errorMessage,
  });

  final String username;
  final String password;
  final bool isPasswordObscure;
  final LoginStatus status;
  final String? errorMessage;

  bool get isLoading => status is LoginStatusLoading;

  LoginState copyWith({
    String? username,
    String? password,
    bool? isPasswordObscure,
    LoginStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      status: clearError ? const LoginStatusIdle() : (status ?? this.status),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
