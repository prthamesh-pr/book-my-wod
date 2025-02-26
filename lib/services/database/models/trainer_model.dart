import 'package:bookmywod_admin/services/database/models/model_constant.dart';

enum Roles {
  admin,
  trainer,
  manager,
}

enum TrainerStatus {
  active,
  disabled,
  pending,
}

class TrainerModel {
  final String? trainerId;
  final String authId;
  final String gymId;
  final String fullName;
  final String? username;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Roles? role;
  final List<String>? features;
  final String? about;
  final TrainerStatus? trainerStatus;

  TrainerModel({
    this.trainerId,
    required this.authId,
    required this.gymId,
    this.createdAt,
    this.features,
    required this.fullName,
    this.username,
    this.about,
    this.phoneNumber,
    this.avatarUrl,
    this.updatedAt,
    this.role,
    this.trainerStatus,
  });

  TrainerModel.newUser({
    required this.authId,
    required this.fullName,
    required this.gymId,
    this.role = Roles.admin,
    this.avatarUrl,
    this.trainerStatus = TrainerStatus.pending,
  })  : trainerId = null,
        username = null,
        phoneNumber = null,
        about = null,
        features = [],
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  TrainerModel copyWith({
    String? trainerId,
    String? authId,
    String? fullName,
    String? username,
    String? phoneNumber,
    String? avatarUrl,
    DateTime? updatedAt,
    DateTime? createdAt,
    Roles? role,
    List<String>? features,
    String? about,
    TrainerStatus? trainerStatus,
    String? gymId,
  }) {
    return TrainerModel(
      trainerId: trainerId ?? this.trainerId,
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      features: features ?? this.features,
      updatedAt: DateTime.now(),
      createdAt: createdAt ?? this.createdAt ?? DateTime.now(),
      role: role ?? this.role,
      about: about ?? this.about,
      trainerStatus: trainerStatus ?? this.trainerStatus,
      gymId: gymId ?? this.gymId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ModelConstant.authId: authId,
      ModelConstant.trainerName: fullName,
      ModelConstant.userName: username,
      ModelConstant.phoneNumber: phoneNumber,
      ModelConstant.avatarUrl: avatarUrl,
      ModelConstant.features: features,
      ModelConstant.updatedAt: updatedAt?.toIso8601String(),
      ModelConstant.createdAt: createdAt?.toIso8601String(),
      ModelConstant.trainerStatus: trainerStatus?.name,
      ModelConstant.gymId: gymId,
      ModelConstant.about: about,
      ModelConstant.trainerRole: role?.name,
    };
  }

  factory TrainerModel.fromMap(Map<String, dynamic> map) {
    return TrainerModel(
      trainerId: map[ModelConstant.trainerIdPk],
      authId: map[ModelConstant.authId],
      fullName: map[ModelConstant.trainerName],
      features: map[ModelConstant.features] != null
          ? List<String>.from(map[ModelConstant.features])
          : [],
      username: map[ModelConstant.userName],
      phoneNumber: map[ModelConstant.phoneNumber],
      avatarUrl: map[ModelConstant.avatarUrl],
      role: map[ModelConstant.trainerRole] != null
          ? Roles.values.firstWhere(
              (e) => e.name == map[ModelConstant.trainerRole],
              orElse: () => Roles.trainer)
          : null,
      trainerStatus: map[ModelConstant.trainerStatus] != null
          ? TrainerStatus.values.firstWhere(
              (e) => e.name == map[ModelConstant.trainerStatus],
              orElse: () => TrainerStatus.pending)
          : null,
      gymId: map[ModelConstant.gymId],
      about: map[ModelConstant.about],
      createdAt: map[ModelConstant.createdAt] != null
          ? DateTime.parse(map[ModelConstant.createdAt])
          : null,
      updatedAt: map[ModelConstant.updatedAt] != null
          ? DateTime.parse(map[ModelConstant.updatedAt])
          : null,
    );
  }
}
