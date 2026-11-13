// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppMessageImpl _$$AppMessageImplFromJson(Map<String, dynamic> json) =>
    _$AppMessageImpl(
      id: json['id'] as String? ?? "",
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.NOTIFICATION,
      sender: json['sender'] as String?,
      recipient: json['recipient'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      payload:
          json['payload'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$$AppMessageImplToJson(_$AppMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'timestamp': instance.timestamp?.toIso8601String(),
      'payload': instance.payload,
    };

const _$MessageTypeEnumMap = {
  MessageType.CHAT_MESSAGE: 'CHAT_MESSAGE',
  MessageType.NOTIFICATION: 'NOTIFICATION',
  MessageType.PAYMENT_SUCCESS: 'PAYMENT_SUCCESS',
};

_$PushNotificationImpl _$$PushNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$PushNotificationImpl(
      title: json['title'] as String? ?? "Fedha Notification",
      body: json['body'] as String? ?? "You have a new Fedha notification",
      data: json['data'] == null
          ? const AppMessage(
              id: "",
              type: MessageType.NOTIFICATION,
              payload: <String, dynamic>{})
          : AppMessage.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PushNotificationImplToJson(
        _$PushNotificationImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
    };
