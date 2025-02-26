import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Load messages
class LoadMessages extends ChatEvent {
  final String userId;
  final String receiverId;

  LoadMessages({required this.userId, required this.receiverId});
}

// Send message
class SendMessage extends ChatEvent {
  final String userId;
  final String receiverId;
  final String message;

  SendMessage({required this.userId, required this.receiverId, required this.message});
}
class SendVoiceMessage extends ChatEvent {
  final String userId;
  final String receiverId;
  final String audioPath;

  SendVoiceMessage({required this.userId, required this.receiverId, required this.audioPath});
}
