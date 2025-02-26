import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bookmywod_admin/services/database/models/chatmodel.dart';

class ChatRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<ChatMessage>> fetchMessages(String userId, String receiverId) async {
    final response = await supabase
        .from('chats')
        .select()
        .or('and(sender_id.eq.$userId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$userId)')
        .order('created_at', ascending: true);

    return response.map<ChatMessage>((msg) => ChatMessage.fromMap(msg)).toList();
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    await supabase.from('chats').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
