import 'package:intl/intl.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final String messageType; // New field for message type
  final DateTime createdAt;
  final String? audioPath; // Add audio path to distinguish audio messages

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.createdAt,
    this.audioPath,

  });
  bool get isAudio => audioPath != null; // Define isAudio getter

  // ✅ Convert Supabase response to ChatMessage object safely
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(map['created_at']);
    } catch (e) {
      parsedDate = DateTime.now(); // Fallback to current time
    }
    return ChatMessage(
      senderId: map['sender_id'].toString(),
      receiverId: map['receiver_id'].toString(),
      message: map['message'] ?? '',
      messageType: map.containsKey('message_type') ? map['message_type'] : 'text', // Default to 'text'
      createdAt: parsedDate,
    );
  }

  // ✅ Convert ChatMessage object to JSON (for sending data)
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'message_type': messageType,
      'created_at': createdAt.toUtc().toIso8601String(), // Use UTC format
    };
  }

  // ✅ Format date properly for UI display
  String getFormattedDate() {
    return DateFormat('dd MMM yyyy, hh:mm a').format(createdAt);
  }

  // ✅ Optional: Alias for JSON conversion
  Map<String, dynamic> toJson() => toMap();
}
