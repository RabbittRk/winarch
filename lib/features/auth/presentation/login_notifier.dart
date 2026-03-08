import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/features/auth/domain/usecases/login_usecase.dart';
import 'package:winarch/features/auth/presentation/auth_providers.dart';
import 'package:winarch/features/auth/presentation/login_state.dart';

/// View model for login: holds [LoginState] and exposes actions (events).
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  LoginUseCase get _loginUseCase => ref.read(loginUseCaseProvider);

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordObscure() {
    state = state.copyWith(isPasswordObscure: !state.isPasswordObscure);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> submit(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: const LoginStatusFailure(),
        errorMessage: 'Username and password are required',
      );
      return;
    }
    state = state.copyWith(status: const LoginStatusLoading());
    try {
      await _loginUseCase.execute({
        'username': username,
        'password': password,
      });
      state = state.copyWith(status: const LoginStatusSuccess());
    } catch (e) {
      state = state.copyWith(
        status: const LoginStatusFailure(),
        errorMessage: e.toString(),
      );
    }
  }
}

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
