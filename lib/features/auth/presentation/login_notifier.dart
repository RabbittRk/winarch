import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winarch/core/di/get_it_provider.dart';
import 'package:winarch/features/auth/domain/usecases/login_usecase.dart';
import 'package:winarch/features/auth/presentation/login_state.dart';

/// Holds [LoginState] and handles submit logic: validation, use case call, state updates.
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginInitial();

  LoginUseCase get _loginUseCase => ref.read(getItProvider).get<LoginUseCase>();

  Future<void> submit(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = const LoginFailure('Username and password are required');
      return;
    }
    state = const LoginLoading();
    try {
      await _loginUseCase.execute({
        'username': username,
        'password': password,
      });
      state = const LoginSuccess();
    } catch (e) {
      state = LoginFailure(e.toString());
    }
  }
}

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
