import 'package:bookmywod_admin/services/database/models/model_constant.dart';

class GymModel {
  final String? gymId;
  final String name;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? theme;

  GymModel({
    this.gymId,
    required this.name,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.theme,
  });

  GymModel.newGym({
    required this.name,
    required this.address,
  })  : gymId = null,
        theme = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      ModelConstant.gymName: name,
      ModelConstant.gymAddress: address,
      ModelConstant.gymCreatedAt: createdAt?.toIso8601String(),
      ModelConstant.gymUpdatedAt: updatedAt?.toIso8601String(),
      ModelConstant.gymTheme: theme,
    };
  }

  factory GymModel.fromMap(Map<String, dynamic> map) {
    return GymModel(
      gymId: map[ModelConstant.gymIdPK],
      name: map[ModelConstant.gymName],
      address: map[ModelConstant.gymAddress],
      createdAt: map[ModelConstant.gymCreatedAt] != null
          ? DateTime.parse(map[ModelConstant.gymCreatedAt])
          : null,
      updatedAt: map[ModelConstant.gymUpdatedAt] != null
          ? DateTime.parse(map[ModelConstant.gymUpdatedAt])
          : null,
      theme: map[ModelConstant.gymTheme],
    );
  }

  GymModel copyWith({
    String? gymId,
    String? name,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? theme,
  }) {
    return GymModel(
      gymId: gymId ?? this.gymId,
      name: name ?? this.name,
      address: address ?? this.address,
      updatedAt: DateTime.now(),
      createdAt: createdAt ?? this.createdAt ?? DateTime.now(),
      theme: theme ?? this.theme,
    );
  }
}
