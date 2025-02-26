import 'package:bookmywod_admin/bloc/events/chat_event.dart';
import 'package:bookmywod_admin/bloc/states/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bookmywod_admin/services/database/models/chatmodel.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupabaseClient supabase = Supabase.instance.client;

  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<SendVoiceMessage>(_onSendVoiceMessage);

  }

  // Load messages from Supabase
  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      final response = await supabase
          .from('chats')
          .select()
          .or('and(sender_id.eq.${event.userId},receiver_id.eq.${event.receiverId})'
          ',and(sender_id.eq.${event.receiverId},receiver_id.eq.${event.userId})')
          .order('created_at', ascending: true);

      final messages = response.map<ChatMessage>((msg) => ChatMessage.fromMap(msg)).toList();
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  // Send message to Supabase
  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await supabase.from('chats').insert({
        'sender_id': event.userId,
        'receiver_id': event.receiverId,
        'message': event.message,
        'message_type': 'text', // Adding message type
        'created_at': DateTime.now().toIso8601String(),
      });

      add(LoadMessages(userId: event.userId, receiverId: event.receiverId));
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }
  Future<void> _onSendVoiceMessage(SendVoiceMessage event, Emitter<ChatState> emit) async {
    try {
      await supabase.from('chats').insert({
        'sender_id': event.userId,
        'receiver_id': event.receiverId,
        'message': event.audioPath, // Store file path or URL
        'message_type': 'voice', // Distinguish voice messages
        'created_at': DateTime.now().toIso8601String(),
      });

      add(LoadMessages(userId: event.userId, receiverId: event.receiverId));
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }


}
