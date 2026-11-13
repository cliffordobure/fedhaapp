import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_message.freezed.dart';
part 'remote_message.g.dart';

enum MessageType { CHAT_MESSAGE, NOTIFICATION, PAYMENT_SUCCESS }

@freezed
class AppMessage with _$AppMessage {
  const factory AppMessage({
    @Default("") String id,
    @Default(MessageType.NOTIFICATION) MessageType type,
    String? sender,
    String? recipient,
    DateTime? timestamp,
    @Default(<String, dynamic>{}) Map<String, dynamic> payload,
  }) = _AppMessage;

  factory AppMessage.fromJson(Map<String, dynamic> json) =>
      _$AppMessageFromJson(json);
}

@freezed
class PushNotification with _$PushNotification {
  factory PushNotification({
    @Default("Fedha Notification") String? title,
    @Default("You have a new Fedha notification") String? body,
    @Default(AppMessage(
        id: "",
        type: MessageType.NOTIFICATION,
        payload: <String, dynamic>{})) // Default payload is an empty Map
    AppMessage? data,
  }) = _PushNotification;

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);
}
