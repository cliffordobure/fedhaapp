part of 'bloc.dart';

class ChatState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status; // contats loading status
  final List<Chat> chats; // The currently selected chats
  final List<Message> messages;

  const ChatState({
    this.message,
    this.status = ServiceStatus.initial,
    this.chats = const [],
    this.messages = const [],
  });

  ChatState copyWith(
      {ApplicationMessage? message,
      ServiceStatus? status,
      List<Chat>? chats,
      List<Message>? messages}) {
    return ChatState(
      message: message,
      status: status ?? this.status,
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [message, status, chats, messages];
}
