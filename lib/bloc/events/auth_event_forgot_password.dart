import 'package:bookmywod_admin/bloc/events/auth_event.dart';

class AuthEventForgotPassword extends AuthEvent {
  final String? email;

  AuthEventForgotPassword({this.email});
}
