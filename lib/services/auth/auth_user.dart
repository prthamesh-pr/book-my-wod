import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;
  final String fullName;
  final String id;
  final String? profileImageUrl;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
    required this.fullName,
    this.profileImageUrl,
  });

  factory AuthUser.fromSupabase(User user) => AuthUser(
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] ?? '',
        isEmailVerified: user.emailConfirmedAt != null,
        id: user.id,
        profileImageUrl: user.userMetadata?['avatar_url'],
      );

  AuthUser copyWith({
    String? email,
    bool? isEmailVerified,
    String? fullName,
    String? id,
    String? profileImageUrl,
  }) {
    return AuthUser(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      id: id ?? this.id,
    );
  }
}
