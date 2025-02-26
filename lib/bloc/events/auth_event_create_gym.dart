import 'package:bookmywod_admin/bloc/events/auth_event.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';

class AuthEventCreateGym extends AuthEvent {
  final AuthUser authUser;
  final String gymName;
  final String gymAddress;

  AuthEventCreateGym({
    required this.authUser,
    required this.gymName,
    required this.gymAddress,
  });
}
