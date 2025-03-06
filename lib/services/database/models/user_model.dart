import 'package:bookmywod_admin/services/database/models/app_model.dart';
import 'package:bookmywod_admin/services/database/models/model_constant.dart';

class UserModel implements AppModel {
  final String id;
  final String fullName;
  String? avatarUrl;
  final DateTime? updatedAt;

  // ✅ Use correct field names from ModelConstant
  final String? creatorId;
  final String? gymId;
  final String? catagoryId;

  UserModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.updatedAt,
    this.creatorId,
    this.gymId,
    this.catagoryId,
  });

  UserModel.newUser({
    required this.id,
    required this.fullName,
    this.creatorId,
    this.gymId,
    this.catagoryId,
  })  : avatarUrl = null,
        updatedAt = DateTime.now();

  UserModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    DateTime? updatedAt,
    String? creatorId,
    String? gymId,
    String? catagoryId,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: DateTime.now(),
      creatorId: creatorId ?? this.creatorId,
      gymId: gymId ?? this.gymId,
      catagoryId: catagoryId ?? this.catagoryId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ModelConstant.id: id,
      ModelConstant.name: fullName,
      ModelConstant.profileAvatar: avatarUrl,
      ModelConstant.updatedAt: updatedAt?.toIso8601String(),
      ModelConstant.sessionCreatedBy: creatorId,  // ✅ FIXED
      ModelConstant.gymId: gymId,                      // ✅ FIXED
      ModelConstant.catagoryId: catagoryId,            // ✅ FIXED
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    print("🔥 Raw Map Data: $map");  // ✅ Print entire map

    return UserModel(
      id: map[ModelConstant.id] ?? "",
      fullName: map[ModelConstant.name] ?? "",
      avatarUrl: map[ModelConstant.profileAvatar],
      updatedAt: map[ModelConstant.updatedAt] != null
          ? DateTime.parse(map[ModelConstant.updatedAt])
          : null,
      creatorId: map[ModelConstant.uuidOfCatagoryCreator]?.toString(),
      gymId: map[ModelConstant.gymId],                      // ✅ FIXED
      catagoryId: map[ModelConstant.catagoryId],            // ✅ FIXED
    );
  }
}
