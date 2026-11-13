// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdsImpl _$$AdsImplFromJson(Map<String, dynamic> json) => _$AdsImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
      status: (json['status'] as num).toInt(),
      paymentStatus: (json['payment_status'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      link: json['url'] as String?,
      mediaType: json['media_type'] as String,
      mediaPath: json['media_path'] as String,
      autoplay: json['autoplay'] as bool,
    );

Map<String, dynamic> _$$AdsImplToJson(_$AdsImpl instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image_path': instance.imagePath,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'url': instance.link,
      'media_type': instance.mediaType,
      'media_path': instance.mediaPath,
      'autoplay': instance.autoplay,
    };
