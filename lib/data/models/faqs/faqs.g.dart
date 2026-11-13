// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faqs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FaQImpl _$$FaQImplFromJson(Map<String, dynamic> json) => _$FaQImpl(
      id: (json['id'] as num).toInt(),
      question: json['question'] as String,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$$FaQImplToJson(_$FaQImpl instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
    };
