// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_fetch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileResponseImpl _$$ProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileResponseImpl(
      user: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
      accountComplete: json['account_complete'] as bool?,
      section:
          (json['section'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ProfileResponseImplToJson(
        _$ProfileResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.user,
      'account_complete': instance.accountComplete,
      'section': instance.section,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String? ?? "Anonymous",
      lastName: json['last_name'] as String? ?? "",
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String? ?? "email unspecified",
      avatar: json['avatar'] as String?,
      activeStatus: json['active_status'] as String?,
      idNumber: json['id_number'] as String?,
      services: json['services'] as List<dynamic>?,
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'avatar': instance.avatar,
      'active_status': instance.activeStatus,
      'id_number': instance.idNumber,
      'services': instance.services,
      'profile': instance.profile,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      type: json['type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      businessName: json['business_name'] as String?,
      businessPhoneNumber: json['business_phone_number'] as String?,
      businessEmail: json['business_email'] as String?,
      businessRegistrationCertificate:
          json['business_registration_certificate'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'business_name': instance.businessName,
      'business_phone_number': instance.businessPhoneNumber,
      'business_email': instance.businessEmail,
      'business_registration_certificate':
          instance.businessRegistrationCertificate,
    };
