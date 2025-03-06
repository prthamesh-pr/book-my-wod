import 'package:bookmywod_admin/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get getCurrentUser;

  AuthUser? get user;

  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String fullName,
  });

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({
    required String toEmail,
  });

  Future<AuthUser?> refreshUser();

  Future<void> updatePassword({
    required String newPassword,
  });

  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> signInWithFacebook();
}
