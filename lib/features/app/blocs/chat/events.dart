part of "bloc.dart";

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatOpened extends ChatEvent {}

class MessageSend extends ChatEvent {
  final String message;

  const MessageSend(
    this.message,
  );
  @override
  List<Object?> get props => [
        message,
      ];
}

class RefreshChats extends ChatEvent {}
