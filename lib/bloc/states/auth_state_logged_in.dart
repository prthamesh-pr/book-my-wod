import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  final SupabaseDb supabaseDb;

  const AuthStateLoggedIn({
    super.message,
    required this.authUser,
    required this.supabaseDb,
  });
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoggedIn(
      authUser: authUser,
      supabaseDb: supabaseDb,
      message: message,
    );
  }
}
