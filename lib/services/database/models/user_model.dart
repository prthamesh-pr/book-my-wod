import 'package:bookmywod_admin/services/database/models/app_model.dart';
import 'package:bookmywod_admin/services/database/models/model_constant.dart';

class UserModel implements AppModel {
  final String id;
  final String fullName;
  String? avatarUrl;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.updatedAt,
  });

  UserModel.newUser({
    required this.id,
    required this.fullName,
  })  : avatarUrl = null,
        updatedAt = DateTime.now();

  UserModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ModelConstant.id: id,
      ModelConstant.name: fullName,
      ModelConstant.profileAvatar: avatarUrl,
      ModelConstant.updatedAt: updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[ModelConstant.id] ?? "",
      fullName: map[ModelConstant.name]?? "",
      avatarUrl: map[ModelConstant.profileAvatar],
      updatedAt: map[ModelConstant.updatedAt] != null
          ? DateTime.parse(map[ModelConstant.updatedAt])
          : null,
    );
  }
}
