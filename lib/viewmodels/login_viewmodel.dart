import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vein_pay_wallet/core/network/api_exception.dart';
import 'package:vein_pay_wallet/data/repositories/auth_repository.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState {
  const LoginState({this.status = LoginStatus.initial, this.errorMessage});

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading, clearErrorMessage: true));

    try {
      await _authRepository.login(username: username, password: password);
      emit(
        state.copyWith(status: LoginStatus.success, clearErrorMessage: true),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(status: LoginStatus.error, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: 'Unable to log in right now. Please try again.',
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(status: LoginStatus.initial, clearErrorMessage: true));
  }
}
