import 'package:bookmywod_admin/services/database/models/model_constant.dart';

class SessionModel {
  final String? sessionId;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? coverImage;
  final String categoryId;
  final List<Map<String, String>> timeSlots;
  final List<String> days;
  final bool sessionRepeat;
  final String entryLimit;
  final String sessionCreatedBy;
  final String gymId;

  SessionModel({
    this.sessionId,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.coverImage,
    required this.categoryId,
    required this.timeSlots,
    required this.days,
    required this.sessionRepeat,
    required this.entryLimit,
    required this.sessionCreatedBy,
    required this.gymId,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConstant.sessionName: name,
      ModelConstant.sessionDescription: description,
      ModelConstant.sessionImage: coverImage,
      ModelConstant.catagoryId: categoryId,
      ModelConstant.timeSlots: timeSlots,
      ModelConstant.daysList: days,
      ModelConstant.sessionRepeat: sessionRepeat,
      ModelConstant.entryLimit: entryLimit,
      ModelConstant.sessionCreatedBy: sessionCreatedBy,
      ModelConstant.sessionCreatedAt: createdAt?.toIso8601String(),
      ModelConstant.sessionUpdatedAt: updatedAt?.toIso8601String(),
      ModelConstant.gymIdOfSessions: gymId,
    };
  }

  SessionModel.newSession({
    required this.name,
    required this.gymId,
    required this.categoryId,
    required this.timeSlots,
    required this.days,
    this.sessionRepeat = false,
    this.entryLimit = '0',
    required this.sessionCreatedBy,
    this.coverImage,
    this.description,
  })  : sessionId = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    final List<Map<String, String>> timeSlots = [];

    if (map[ModelConstant.timeSlots] != null) {
      final dynamic timeList = map[ModelConstant.timeSlots];

      if (timeList is List) {
        for (var slot in timeList) {
          if (slot is Map<String, dynamic>) {
            timeSlots.add(slot.map((key, value) => MapEntry(key, value.toString())));
          }
        }
      }
    }

    return SessionModel(
      sessionId: map[ModelConstant.sessionIdPk],
      gymId: map[ModelConstant.gymIdOfSessions],
      name: map[ModelConstant.sessionName],
      description: map[ModelConstant.sessionDescription],
      coverImage: map[ModelConstant.sessionImage],
      categoryId: map[ModelConstant.catagoryId],
      timeSlots: timeSlots,
      days: List<String>.from(map[ModelConstant.daysList] ?? []),
      sessionRepeat: map[ModelConstant.sessionRepeat] ?? false,
      entryLimit: map[ModelConstant.entryLimit] ?? '0',
      sessionCreatedBy: map[ModelConstant.sessionCreatedBy],
      createdAt: map[ModelConstant.sessionCreatedAt] != null
          ? DateTime.tryParse(map[ModelConstant.sessionCreatedAt] ?? '')
          : null,
      updatedAt: map[ModelConstant.sessionUpdatedAt] != null
          ? DateTime.tryParse(map[ModelConstant.sessionUpdatedAt] ?? '')
          : null,
    );
  }

  SessionModel copyWith({
    String? sessionId,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImage,
    String? categoryId,
    List<Map<String, String>>? timeSlots,
    List<String>? days,
    bool? sessionRepeat,
    String? entryLimit,
    String? sessionCreatedBy,
    String? gymId,
  }) {
    return SessionModel(
      sessionId: sessionId ?? this.sessionId,
      gymId: gymId ?? this.gymId,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      categoryId: categoryId ?? this.categoryId,
      timeSlots: timeSlots ?? this.timeSlots,
      days: days ?? this.days,
      sessionRepeat: sessionRepeat ?? this.sessionRepeat,
      entryLimit: entryLimit ?? this.entryLimit,
      sessionCreatedBy: sessionCreatedBy ?? this.sessionCreatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
