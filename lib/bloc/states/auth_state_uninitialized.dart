import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({super.message});
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateUninitialized(message: message);
  }
}
