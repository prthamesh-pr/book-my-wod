import 'package:equatable/equatable.dart';

class StateMessage extends Equatable {
  final String message;
  final bool isError;

  const StateMessage(
    this.message, {
    this.isError = false,
  });
  @override
  List<Object?> get props => [message, isError];
}
