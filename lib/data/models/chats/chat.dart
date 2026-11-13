import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
abstract class Chat with _$Chat {
  const factory Chat({
    required int id,
    @JsonKey(name: "sender_id") required int senderId,
    @JsonKey(name: "recipient_id") required int recipientId,
    required String message,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    required List<ChatResponse> response,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@freezed
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    required int id,
    @JsonKey(name: 'message_id') required int messageId,
    required String response,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
}

class Message {
  final String message;
  final DateTime created;
  final bool isResponse;

  Message(
      {required this.message, required this.created, required this.isResponse});

  factory Message.fromChat(Chat chat) {
    debugPrint("Chat received");
    return Message(
        message: chat.message, created: chat.createdAt, isResponse: false);
  }

  factory Message.fromResponse(ChatResponse chat) {
    debugPrint("Response received");
    return Message(
        message: chat.response, created: chat.createdAt, isResponse: true);
  }
}
