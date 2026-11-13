// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_sign_in.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialSignInRequest _$SocialSignInRequestFromJson(Map<String, dynamic> json) {
  return _SocialSignInRequest.fromJson(json);
}

/// @nodoc
mixin _$SocialSignInRequest {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String get phone_number => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  bool get email_verified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialSignInRequestCopyWith<SocialSignInRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialSignInRequestCopyWith<$Res> {
  factory $SocialSignInRequestCopyWith(
          SocialSignInRequest value, $Res Function(SocialSignInRequest) then) =
      _$SocialSignInRequestCopyWithImpl<$Res, SocialSignInRequest>;
  @useResult
  $Res call(
      {String name,
      String email,
      String? role,
      String phone_number,
      String token,
      bool email_verified});
}

/// @nodoc
class _$SocialSignInRequestCopyWithImpl<$Res, $Val extends SocialSignInRequest>
    implements $SocialSignInRequestCopyWith<$Res> {
  _$SocialSignInRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? role = freezed,
    Object? phone_number = null,
    Object? token = null,
    Object? email_verified = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      phone_number: null == phone_number
          ? _value.phone_number
          : phone_number // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialSignInRequestImplCopyWith<$Res>
    implements $SocialSignInRequestCopyWith<$Res> {
  factory _$$SocialSignInRequestImplCopyWith(_$SocialSignInRequestImpl value,
          $Res Function(_$SocialSignInRequestImpl) then) =
      __$$SocialSignInRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String email,
      String? role,
      String phone_number,
      String token,
      bool email_verified});
}

/// @nodoc
class __$$SocialSignInRequestImplCopyWithImpl<$Res>
    extends _$SocialSignInRequestCopyWithImpl<$Res, _$SocialSignInRequestImpl>
    implements _$$SocialSignInRequestImplCopyWith<$Res> {
  __$$SocialSignInRequestImplCopyWithImpl(_$SocialSignInRequestImpl _value,
      $Res Function(_$SocialSignInRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? role = freezed,
    Object? phone_number = null,
    Object? token = null,
    Object? email_verified = null,
  }) {
    return _then(_$SocialSignInRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      phone_number: null == phone_number
          ? _value.phone_number
          : phone_number // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialSignInRequestImpl implements _SocialSignInRequest {
  const _$SocialSignInRequestImpl(
      {required this.name,
      required this.email,
      this.role,
      required this.phone_number,
      required this.token,
      required this.email_verified});

  factory _$SocialSignInRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialSignInRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String? role;
  @override
  final String phone_number;
  @override
  final String token;
  @override
  final bool email_verified;

  @override
  String toString() {
    return 'SocialSignInRequest(name: $name, email: $email, role: $role, phone_number: $phone_number, token: $token, email_verified: $email_verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialSignInRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.phone_number, phone_number) ||
                other.phone_number == phone_number) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.email_verified, email_verified) ||
                other.email_verified == email_verified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, email, role, phone_number, token, email_verified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialSignInRequestImplCopyWith<_$SocialSignInRequestImpl> get copyWith =>
      __$$SocialSignInRequestImplCopyWithImpl<_$SocialSignInRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialSignInRequestImplToJson(
      this,
    );
  }
}

abstract class _SocialSignInRequest implements SocialSignInRequest {
  const factory _SocialSignInRequest(
      {required final String name,
      required final String email,
      final String? role,
      required final String phone_number,
      required final String token,
      required final bool email_verified}) = _$SocialSignInRequestImpl;

  factory _SocialSignInRequest.fromJson(Map<String, dynamic> json) =
      _$SocialSignInRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String? get role;
  @override
  String get phone_number;
  @override
  String get token;
  @override
  bool get email_verified;
  @override
  @JsonKey(ignore: true)
  _$$SocialSignInRequestImplCopyWith<_$SocialSignInRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialSignInResponse _$SocialSignInResponseFromJson(Map<String, dynamic> json) {
  return _SocialSignInResponse.fromJson(json);
}

/// @nodoc
mixin _$SocialSignInResponse {
  User get user => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialSignInResponseCopyWith<SocialSignInResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialSignInResponseCopyWith<$Res> {
  factory $SocialSignInResponseCopyWith(SocialSignInResponse value,
          $Res Function(SocialSignInResponse) then) =
      _$SocialSignInResponseCopyWithImpl<$Res, SocialSignInResponse>;
  @useResult
  $Res call({User user, String token});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$SocialSignInResponseCopyWithImpl<$Res,
        $Val extends SocialSignInResponse>
    implements $SocialSignInResponseCopyWith<$Res> {
  _$SocialSignInResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SocialSignInResponseImplCopyWith<$Res>
    implements $SocialSignInResponseCopyWith<$Res> {
  factory _$$SocialSignInResponseImplCopyWith(_$SocialSignInResponseImpl value,
          $Res Function(_$SocialSignInResponseImpl) then) =
      __$$SocialSignInResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User user, String token});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$SocialSignInResponseImplCopyWithImpl<$Res>
    extends _$SocialSignInResponseCopyWithImpl<$Res, _$SocialSignInResponseImpl>
    implements _$$SocialSignInResponseImplCopyWith<$Res> {
  __$$SocialSignInResponseImplCopyWithImpl(_$SocialSignInResponseImpl _value,
      $Res Function(_$SocialSignInResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
  }) {
    return _then(_$SocialSignInResponseImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialSignInResponseImpl implements _SocialSignInResponse {
  const _$SocialSignInResponseImpl({required this.user, required this.token});

  factory _$SocialSignInResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialSignInResponseImplFromJson(json);

  @override
  final User user;
  @override
  final String token;

  @override
  String toString() {
    return 'SocialSignInResponse(user: $user, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialSignInResponseImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialSignInResponseImplCopyWith<_$SocialSignInResponseImpl>
      get copyWith =>
          __$$SocialSignInResponseImplCopyWithImpl<_$SocialSignInResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialSignInResponseImplToJson(
      this,
    );
  }
}

abstract class _SocialSignInResponse implements SocialSignInResponse {
  const factory _SocialSignInResponse(
      {required final User user,
      required final String token}) = _$SocialSignInResponseImpl;

  factory _SocialSignInResponse.fromJson(Map<String, dynamic> json) =
      _$SocialSignInResponseImpl.fromJson;

  @override
  User get user;
  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$SocialSignInResponseImplCopyWith<_$SocialSignInResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
