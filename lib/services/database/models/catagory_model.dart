import 'package:bookmywod_admin/services/database/models/model_constant.dart';

class CatagoryModel {
  final String? catagoryId;
  final String name;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String uuidOfCreator;
  final String gymId;
  final List<String>? features;

  CatagoryModel({
    this.catagoryId,
    required this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
    required this.uuidOfCreator,
    required this.gymId,
    this.features,
  });

  CatagoryModel.newCatagory({
    required this.gymId,
    required this.uuidOfCreator,
    required this.name,
    this.image,
    this.features,
  })  : catagoryId = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      ModelConstant.categoryName: name,
      ModelConstant.categoryImage: image,
      ModelConstant.categoryCreatedAt: createdAt?.toIso8601String(),
      ModelConstant.categoryUpdatedAt: updatedAt?.toIso8601String(),
      ModelConstant.uuidOfCatagoryCreator: uuidOfCreator,
      ModelConstant.gymId: gymId,
      ModelConstant.categoryFeatures: features,
    };
  }

  factory CatagoryModel.fromMap(Map<String, dynamic> map) {
    return CatagoryModel(
      catagoryId: map[ModelConstant.catagoryIdPk],
      name: map[ModelConstant.categoryName],
      image: map[ModelConstant.categoryImage],
      createdAt: map[ModelConstant.categoryCreatedAt] != null
          ? DateTime.parse(map[ModelConstant.categoryCreatedAt])
          : null,
      updatedAt: map[ModelConstant.categoryUpdatedAt] != null
          ? DateTime.parse(map[ModelConstant.categoryUpdatedAt])
          : null,
      uuidOfCreator: map[ModelConstant.uuidOfCatagoryCreator],
      gymId: map[ModelConstant.gymId],
      features: map[ModelConstant.categoryFeatures] != null
          ? List<String>.from(map[ModelConstant.categoryFeatures])
          : [],
    );
  }

  CatagoryModel copyWith({
    String? catagoryId,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? uuidOfCreator,
    String? gymId,
    List<String>? features,
  }) {
    return CatagoryModel(
      catagoryId: catagoryId ?? this.catagoryId,
      name: name ?? this.name,
      image: image ?? this.image,
      updatedAt: DateTime.now(),
      createdAt: createdAt ?? this.createdAt ?? DateTime.now(),
      uuidOfCreator: uuidOfCreator ?? this.uuidOfCreator,
      gymId: gymId ?? this.gymId,
      features: features ?? this.features,
    );
  }
}
