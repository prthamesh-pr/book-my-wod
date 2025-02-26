import 'dart:convert';

class MembershipPlan {
  final String id;
  final String gymId;
  final String billingCycle;
  final String details;
  final double price;
  final Map<String, dynamic> benefits;
  final String addedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  MembershipPlan({
    required this.id,
    required this.gymId,
    required this.billingCycle,
    required this.details,
    required this.price,
    required this.benefits,
    required this.addedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'],
      gymId: json['gym_id'],
      billingCycle: json['billing_cycle'],
      details: json['details'],
      price: (json['price'] as num).toDouble(),
      benefits: jsonDecode(json['benefits']), // Convert JSONB to Map
      addedBy: json['added_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gym_id': gymId,
      'billing_cycle': billingCycle,
      'details': details,
      'price': price,
      'benefits': jsonEncode(benefits), // Convert Map to JSON string
      'added_by': addedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
