import 'package:equatable/equatable.dart';
import 'package:bookmywod_admin/services/database/models/chatmodel.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state
class ChatInitial extends ChatState {}

// Loading state
class ChatLoading extends ChatState {}

// Loaded state
class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  ChatLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

// Error state
class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}
