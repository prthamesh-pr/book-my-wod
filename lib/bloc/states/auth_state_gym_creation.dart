import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';

class AuthStateGymCreation extends AuthState {
  final AuthUser authUser;
  final Exception? exception;

  const AuthStateGymCreation({
    super.message,
    required this.exception,
    required this.authUser,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateGymCreation(
      exception: exception,
      message: message,
      authUser: authUser,
    );
  }
}
