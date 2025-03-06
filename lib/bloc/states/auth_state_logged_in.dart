import 'package:bookmywod_admin/bloc/state_message.dart';
import 'package:bookmywod_admin/bloc/states/auth_state.dart';
import 'package:bookmywod_admin/services/auth/auth_user.dart';
import 'package:bookmywod_admin/services/database/supabase_storage/supabase_db.dart';

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  final SupabaseDb supabaseDb;
  final String? creatorId;
  final String? gymId;
  final String? catagoryId;

  // ✅ Convert positional parameters to named parameters
  const AuthStateLoggedIn({
    super.message,
    required this.authUser,
    required this.supabaseDb,
    this.creatorId,  // Changed to named parameter
    this.gymId,      // Changed to named parameter
    this.catagoryId, // Changed to named parameter
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoggedIn(
      authUser: authUser,
      supabaseDb: supabaseDb,
      message: message ?? this.message,
      creatorId: creatorId ?? creatorId,  // ✅ Keep existing value if null
      gymId: gymId ?? gymId,              // ✅ Keep existing value if null
      catagoryId: catagoryId ?? catagoryId, // ✅ Keep existing value if null
    );
  }
}
