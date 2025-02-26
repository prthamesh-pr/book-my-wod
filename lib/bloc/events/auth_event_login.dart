import 'package:bookmywod_admin/bloc/events/auth_event.dart';

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  AuthEventLogin({
    required this.email,
    required this.password,
  });
}
