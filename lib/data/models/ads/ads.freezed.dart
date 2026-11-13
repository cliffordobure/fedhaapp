// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ads.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ads _$AdsFromJson(Map<String, dynamic> json) {
  return _Ads.fromJson(json);
}

/// @nodoc
mixin _$Ads {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_path')
  String get imagePath => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  int get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'url')
  String? get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_type')
  String get mediaType => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_path')
  String get mediaPath => throw _privateConstructorUsedError;
  bool get autoplay => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdsCopyWith<Ads> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdsCopyWith<$Res> {
  factory $AdsCopyWith(Ads value, $Res Function(Ads) then) =
      _$AdsCopyWithImpl<$Res, Ads>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      @JsonKey(name: 'image_path') String imagePath,
      int status,
      @JsonKey(name: 'payment_status') int paymentStatus,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'url') String? link,
      @JsonKey(name: 'media_type') String mediaType,
      @JsonKey(name: 'media_path') String mediaPath,
      bool autoplay});
}

/// @nodoc
class _$AdsCopyWithImpl<$Res, $Val extends Ads> implements $AdsCopyWith<$Res> {
  _$AdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imagePath = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? link = freezed,
    Object? mediaType = null,
    Object? mediaPath = null,
    Object? autoplay = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaPath: null == mediaPath
          ? _value.mediaPath
          : mediaPath // ignore: cast_nullable_to_non_nullable
              as String,
      autoplay: null == autoplay
          ? _value.autoplay
          : autoplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdsImplCopyWith<$Res> implements $AdsCopyWith<$Res> {
  factory _$$AdsImplCopyWith(_$AdsImpl value, $Res Function(_$AdsImpl) then) =
      __$$AdsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      @JsonKey(name: 'image_path') String imagePath,
      int status,
      @JsonKey(name: 'payment_status') int paymentStatus,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'url') String? link,
      @JsonKey(name: 'media_type') String mediaType,
      @JsonKey(name: 'media_path') String mediaPath,
      bool autoplay});
}

/// @nodoc
class __$$AdsImplCopyWithImpl<$Res> extends _$AdsCopyWithImpl<$Res, _$AdsImpl>
    implements _$$AdsImplCopyWith<$Res> {
  __$$AdsImplCopyWithImpl(_$AdsImpl _value, $Res Function(_$AdsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imagePath = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? link = freezed,
    Object? mediaType = null,
    Object? mediaPath = null,
    Object? autoplay = null,
  }) {
    return _then(_$AdsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaPath: null == mediaPath
          ? _value.mediaPath
          : mediaPath // ignore: cast_nullable_to_non_nullable
              as String,
      autoplay: null == autoplay
          ? _value.autoplay
          : autoplay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdsImpl implements _Ads {
  const _$AdsImpl(
      {required this.id,
      required this.title,
      required this.description,
      @JsonKey(name: 'image_path') required this.imagePath,
      required this.status,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'url') this.link,
      @JsonKey(name: 'media_type') required this.mediaType,
      @JsonKey(name: 'media_path') required this.mediaPath,
      required this.autoplay});

  factory _$AdsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdsImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'image_path')
  final String imagePath;
  @override
  final int status;
  @override
  @JsonKey(name: 'payment_status')
  final int paymentStatus;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'url')
  final String? link;
  @override
  @JsonKey(name: 'media_type')
  final String mediaType;
  @override
  @JsonKey(name: 'media_path')
  final String mediaPath;
  @override
  final bool autoplay;

  @override
  String toString() {
    return 'Ads(id: $id, title: $title, description: $description, imagePath: $imagePath, status: $status, paymentStatus: $paymentStatus, createdAt: $createdAt, updatedAt: $updatedAt, link: $link, mediaType: $mediaType, mediaPath: $mediaPath, autoplay: $autoplay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.mediaPath, mediaPath) ||
                other.mediaPath == mediaPath) &&
            (identical(other.autoplay, autoplay) ||
                other.autoplay == autoplay));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      imagePath,
      status,
      paymentStatus,
      createdAt,
      updatedAt,
      link,
      mediaType,
      mediaPath,
      autoplay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdsImplCopyWith<_$AdsImpl> get copyWith =>
      __$$AdsImplCopyWithImpl<_$AdsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdsImplToJson(
      this,
    );
  }
}

abstract class _Ads implements Ads {
  const factory _Ads(
      {required final int id,
      required final String title,
      required final String description,
      @JsonKey(name: 'image_path') required final String imagePath,
      required final int status,
      @JsonKey(name: 'payment_status') required final int paymentStatus,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'url') final String? link,
      @JsonKey(name: 'media_type') required final String mediaType,
      @JsonKey(name: 'media_path') required final String mediaPath,
      required final bool autoplay}) = _$AdsImpl;

  factory _Ads.fromJson(Map<String, dynamic> json) = _$AdsImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'image_path')
  String get imagePath;
  @override
  int get status;
  @override
  @JsonKey(name: 'payment_status')
  int get paymentStatus;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'url')
  String? get link;
  @override
  @JsonKey(name: 'media_type')
  String get mediaType;
  @override
  @JsonKey(name: 'media_path')
  String get mediaPath;
  @override
  bool get autoplay;
  @override
  @JsonKey(ignore: true)
  _$$AdsImplCopyWith<_$AdsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
