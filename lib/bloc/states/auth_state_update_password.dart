import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';

class AuthStateUpdatePassword extends AuthState {
  final bool hasUpdatedPassword;
  final Exception? exception;

  const AuthStateUpdatePassword({
    super.message,
    required this.hasUpdatedPassword,
    required this.exception,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateUpdatePassword(
      message: message,
      hasUpdatedPassword: hasUpdatedPassword,
      exception: exception,
    );
  }
}
