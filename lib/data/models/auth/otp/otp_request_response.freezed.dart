// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_request_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpRequestResponse _$OtpRequestResponseFromJson(Map<String, dynamic> json) {
  return _OtpRequestResponse.fromJson(json);
}

/// @nodoc
mixin _$OtpRequestResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int get code => throw _privateConstructorUsedError;
  String get response => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpRequestResponseCopyWith<OtpRequestResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestResponseCopyWith<$Res> {
  factory $OtpRequestResponseCopyWith(
          OtpRequestResponse value, $Res Function(OtpRequestResponse) then) =
      _$OtpRequestResponseCopyWithImpl<$Res, OtpRequestResponse>;
  @useResult
  $Res call({bool success, String message, int code, String response});
}

/// @nodoc
class _$OtpRequestResponseCopyWithImpl<$Res, $Val extends OtpRequestResponse>
    implements $OtpRequestResponseCopyWith<$Res> {
  _$OtpRequestResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? code = null,
    Object? response = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestResponseImplCopyWith<$Res>
    implements $OtpRequestResponseCopyWith<$Res> {
  factory _$$OtpRequestResponseImplCopyWith(_$OtpRequestResponseImpl value,
          $Res Function(_$OtpRequestResponseImpl) then) =
      __$$OtpRequestResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, int code, String response});
}

/// @nodoc
class __$$OtpRequestResponseImplCopyWithImpl<$Res>
    extends _$OtpRequestResponseCopyWithImpl<$Res, _$OtpRequestResponseImpl>
    implements _$$OtpRequestResponseImplCopyWith<$Res> {
  __$$OtpRequestResponseImplCopyWithImpl(_$OtpRequestResponseImpl _value,
      $Res Function(_$OtpRequestResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? code = null,
    Object? response = null,
  }) {
    return _then(_$OtpRequestResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpRequestResponseImpl implements _OtpRequestResponse {
  const _$OtpRequestResponseImpl(
      {required this.success,
      required this.message,
      required this.code,
      required this.response});

  factory _$OtpRequestResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final int code;
  @override
  final String response;

  @override
  String toString() {
    return 'OtpRequestResponse(success: $success, message: $message, code: $code, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, message, code, response);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestResponseImplCopyWith<_$OtpRequestResponseImpl> get copyWith =>
      __$$OtpRequestResponseImplCopyWithImpl<_$OtpRequestResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestResponseImplToJson(
      this,
    );
  }
}

abstract class _OtpRequestResponse implements OtpRequestResponse {
  const factory _OtpRequestResponse(
      {required final bool success,
      required final String message,
      required final int code,
      required final String response}) = _$OtpRequestResponseImpl;

  factory _OtpRequestResponse.fromJson(Map<String, dynamic> json) =
      _$OtpRequestResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  int get code;
  @override
  String get response;
  @override
  @JsonKey(ignore: true)
  _$$OtpRequestResponseImplCopyWith<_$OtpRequestResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
