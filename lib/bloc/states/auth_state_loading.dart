import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';

class AuthStateLoading extends AuthState {
  const AuthStateLoading({super.message});
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoading(message: message);
  }
}
