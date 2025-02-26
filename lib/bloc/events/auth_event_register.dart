import 'package:bookmywod_admin/bloc/events/auth_event.dart';

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String gymName;
  final String gymAddress;

  AuthEventRegister({
    required this.email,
    required this.password,
    required this.fullName,
    required this.gymName,
    required this.gymAddress,
  });
}
