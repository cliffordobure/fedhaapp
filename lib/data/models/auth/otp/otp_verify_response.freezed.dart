// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpVerifyResponse _$OtpVerifyResponseFromJson(Map<String, dynamic> json) {
  return _OtpVerifyResponse.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyResponse {
  String? get message => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyResponseCopyWith<OtpVerifyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyResponseCopyWith<$Res> {
  factory $OtpVerifyResponseCopyWith(
          OtpVerifyResponse value, $Res Function(OtpVerifyResponse) then) =
      _$OtpVerifyResponseCopyWithImpl<$Res, OtpVerifyResponse>;
  @useResult
  $Res call({String? message, bool? success});
}

/// @nodoc
class _$OtpVerifyResponseCopyWithImpl<$Res, $Val extends OtpVerifyResponse>
    implements $OtpVerifyResponseCopyWith<$Res> {
  _$OtpVerifyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyResponseImplCopyWith<$Res>
    implements $OtpVerifyResponseCopyWith<$Res> {
  factory _$$OtpVerifyResponseImplCopyWith(_$OtpVerifyResponseImpl value,
          $Res Function(_$OtpVerifyResponseImpl) then) =
      __$$OtpVerifyResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message, bool? success});
}

/// @nodoc
class __$$OtpVerifyResponseImplCopyWithImpl<$Res>
    extends _$OtpVerifyResponseCopyWithImpl<$Res, _$OtpVerifyResponseImpl>
    implements _$$OtpVerifyResponseImplCopyWith<$Res> {
  __$$OtpVerifyResponseImplCopyWithImpl(_$OtpVerifyResponseImpl _value,
      $Res Function(_$OtpVerifyResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_$OtpVerifyResponseImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyResponseImpl implements _OtpVerifyResponse {
  _$OtpVerifyResponseImpl({this.message, this.success});

  factory _$OtpVerifyResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyResponseImplFromJson(json);

  @override
  final String? message;
  @override
  final bool? success;

  @override
  String toString() {
    return 'OtpVerifyResponse(message: $message, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyResponseImplCopyWith<_$OtpVerifyResponseImpl> get copyWith =>
      __$$OtpVerifyResponseImplCopyWithImpl<_$OtpVerifyResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyResponseImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyResponse implements OtpVerifyResponse {
  factory _OtpVerifyResponse({final String? message, final bool? success}) =
      _$OtpVerifyResponseImpl;

  factory _OtpVerifyResponse.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyResponseImpl.fromJson;

  @override
  String? get message;
  @override
  bool? get success;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyResponseImplCopyWith<_$OtpVerifyResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
