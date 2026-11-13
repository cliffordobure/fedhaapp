// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) {
  return _OtpVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyRequest {
  String get otp => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyRequestCopyWith<OtpVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyRequestCopyWith<$Res> {
  factory $OtpVerifyRequestCopyWith(
          OtpVerifyRequest value, $Res Function(OtpVerifyRequest) then) =
      _$OtpVerifyRequestCopyWithImpl<$Res, OtpVerifyRequest>;
  @useResult
  $Res call({String otp, String phone});
}

/// @nodoc
class _$OtpVerifyRequestCopyWithImpl<$Res, $Val extends OtpVerifyRequest>
    implements $OtpVerifyRequestCopyWith<$Res> {
  _$OtpVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? phone = null,
  }) {
    return _then(_value.copyWith(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyRequestImplCopyWith<$Res>
    implements $OtpVerifyRequestCopyWith<$Res> {
  factory _$$OtpVerifyRequestImplCopyWith(_$OtpVerifyRequestImpl value,
          $Res Function(_$OtpVerifyRequestImpl) then) =
      __$$OtpVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String otp, String phone});
}

/// @nodoc
class __$$OtpVerifyRequestImplCopyWithImpl<$Res>
    extends _$OtpVerifyRequestCopyWithImpl<$Res, _$OtpVerifyRequestImpl>
    implements _$$OtpVerifyRequestImplCopyWith<$Res> {
  __$$OtpVerifyRequestImplCopyWithImpl(_$OtpVerifyRequestImpl _value,
      $Res Function(_$OtpVerifyRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? phone = null,
  }) {
    return _then(_$OtpVerifyRequestImpl(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyRequestImpl implements _OtpVerifyRequest {
  const _$OtpVerifyRequestImpl({required this.otp, required this.phone});

  factory _$OtpVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyRequestImplFromJson(json);

  @override
  final String otp;
  @override
  final String phone;

  @override
  String toString() {
    return 'OtpVerifyRequest(otp: $otp, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyRequestImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, otp, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      __$$OtpVerifyRequestImplCopyWithImpl<_$OtpVerifyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyRequest implements OtpVerifyRequest {
  const factory _OtpVerifyRequest(
      {required final String otp,
      required final String phone}) = _$OtpVerifyRequestImpl;

  factory _OtpVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyRequestImpl.fromJson;

  @override
  String get otp;
  @override
  String get phone;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmailOtpRequest _$EmailOtpRequestFromJson(Map<String, dynamic> json) {
  return _EmailOtpRequest.fromJson(json);
}

/// @nodoc
mixin _$EmailOtpRequest {
  String get otp => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailOtpRequestCopyWith<EmailOtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailOtpRequestCopyWith<$Res> {
  factory $EmailOtpRequestCopyWith(
          EmailOtpRequest value, $Res Function(EmailOtpRequest) then) =
      _$EmailOtpRequestCopyWithImpl<$Res, EmailOtpRequest>;
  @useResult
  $Res call({String otp, String email});
}

/// @nodoc
class _$EmailOtpRequestCopyWithImpl<$Res, $Val extends EmailOtpRequest>
    implements $EmailOtpRequestCopyWith<$Res> {
  _$EmailOtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailOtpRequestImplCopyWith<$Res>
    implements $EmailOtpRequestCopyWith<$Res> {
  factory _$$EmailOtpRequestImplCopyWith(_$EmailOtpRequestImpl value,
          $Res Function(_$EmailOtpRequestImpl) then) =
      __$$EmailOtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String otp, String email});
}

/// @nodoc
class __$$EmailOtpRequestImplCopyWithImpl<$Res>
    extends _$EmailOtpRequestCopyWithImpl<$Res, _$EmailOtpRequestImpl>
    implements _$$EmailOtpRequestImplCopyWith<$Res> {
  __$$EmailOtpRequestImplCopyWithImpl(
      _$EmailOtpRequestImpl _value, $Res Function(_$EmailOtpRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? email = null,
  }) {
    return _then(_$EmailOtpRequestImpl(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailOtpRequestImpl implements _EmailOtpRequest {
  const _$EmailOtpRequestImpl({required this.otp, required this.email});

  factory _$EmailOtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailOtpRequestImplFromJson(json);

  @override
  final String otp;
  @override
  final String email;

  @override
  String toString() {
    return 'EmailOtpRequest(otp: $otp, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailOtpRequestImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, otp, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailOtpRequestImplCopyWith<_$EmailOtpRequestImpl> get copyWith =>
      __$$EmailOtpRequestImplCopyWithImpl<_$EmailOtpRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailOtpRequestImplToJson(
      this,
    );
  }
}

abstract class _EmailOtpRequest implements EmailOtpRequest {
  const factory _EmailOtpRequest(
      {required final String otp,
      required final String email}) = _$EmailOtpRequestImpl;

  factory _EmailOtpRequest.fromJson(Map<String, dynamic> json) =
      _$EmailOtpRequestImpl.fromJson;

  @override
  String get otp;
  @override
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$EmailOtpRequestImplCopyWith<_$EmailOtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
