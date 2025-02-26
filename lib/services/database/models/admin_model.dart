import 'dart:convert';

class AdminModel {
  final String adminId;
  final String uid;
  final List<Map<String, dynamic>> uidList;
  final String? avatarUrl;
  final String? fullName;

  AdminModel({
    required this.adminId,
    required this.uid,
    required this.uidList,
    this.avatarUrl,
    this.fullName,
  });

  // Convert from Map
  factory AdminModel.fromMap(Map<String, dynamic> data) {
    return AdminModel(
      adminId: data['admin_id'] ?? '', // Ensure it’s not null
      uid: data['uid'] ?? '',
      uidList: data['uid_list'] != null
          ? List<Map<String, dynamic>>.from(data['uid_list'])
          : [],
      avatarUrl: data['avatar_url'], // Optional field
      fullName: data['full_name'], // Optional field
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'admin_id': adminId,
      'uid': uid,
      'uid_list': uidList,
      'avatar_url': avatarUrl,
      'full_name': fullName, // Ensure it matches the database field name
    };
  }

  // Convert from JSON
  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source));

  // Convert to JSON
  String toJson() => json.encode(toMap());
}
