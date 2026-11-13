// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipResponseImpl _$$MembershipResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipResponseImpl(
      currentUserPlan: json['current_user_plan'] as String? ?? "Basic",
      data: (json['data'] as List<dynamic>)
          .map((e) => MembershipOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MembershipResponseImplToJson(
        _$MembershipResponseImpl instance) =>
    <String, dynamic>{
      'current_user_plan': instance.currentUserPlan,
      'data': instance.data,
    };

_$MembershipOptionsImpl _$$MembershipOptionsImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipOptionsImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: json['price'] == null ? 0 : _priceFromJson(json['price']),
      status: (json['status'] as num?)?.toInt() ?? 1,
      features: (json['features'] as List<dynamic>?)
              ?.map(
                  (e) => MembershipFeature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MembershipOptionsImplToJson(
        _$MembershipOptionsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'status': instance.status,
      'features': instance.features,
    };

_$MembershipFeatureImpl _$$MembershipFeatureImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipFeatureImpl(
      id: (json['id'] as num).toInt(),
      packagesId: (json['packages_id'] as num).toInt(),
      feature: json['feature'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MembershipFeatureImplToJson(
        _$MembershipFeatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packages_id': instance.packagesId,
      'feature': instance.feature,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
