// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_update_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileUpdateData _$ProfileUpdateDataFromJson(Map<String, dynamic> json) {
  return _ProfileUpdateData.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpdateData {
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: "phone_number")
  String? get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileUpdateDataCopyWith<ProfileUpdateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpdateDataCopyWith<$Res> {
  factory $ProfileUpdateDataCopyWith(
          ProfileUpdateData value, $Res Function(ProfileUpdateData) then) =
      _$ProfileUpdateDataCopyWithImpl<$Res, ProfileUpdateData>;
  @useResult
  $Res call(
      {@JsonKey(name: "name") String? name,
      String? email,
      @JsonKey(name: "phone_number") String? phone});
}

/// @nodoc
class _$ProfileUpdateDataCopyWithImpl<$Res, $Val extends ProfileUpdateData>
    implements $ProfileUpdateDataCopyWith<$Res> {
  _$ProfileUpdateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileUpdateDataImplCopyWith<$Res>
    implements $ProfileUpdateDataCopyWith<$Res> {
  factory _$$ProfileUpdateDataImplCopyWith(_$ProfileUpdateDataImpl value,
          $Res Function(_$ProfileUpdateDataImpl) then) =
      __$$ProfileUpdateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "name") String? name,
      String? email,
      @JsonKey(name: "phone_number") String? phone});
}

/// @nodoc
class __$$ProfileUpdateDataImplCopyWithImpl<$Res>
    extends _$ProfileUpdateDataCopyWithImpl<$Res, _$ProfileUpdateDataImpl>
    implements _$$ProfileUpdateDataImplCopyWith<$Res> {
  __$$ProfileUpdateDataImplCopyWithImpl(_$ProfileUpdateDataImpl _value,
      $Res Function(_$ProfileUpdateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? email = freezed,
    Object? phone = freezed,
  }) {
    return _then(_$ProfileUpdateDataImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileUpdateDataImpl implements _ProfileUpdateData {
  _$ProfileUpdateDataImpl(
      {@JsonKey(name: "name") this.name,
      this.email,
      @JsonKey(name: "phone_number") this.phone});

  factory _$ProfileUpdateDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpdateDataImplFromJson(json);

  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  final String? email;
  @override
  @JsonKey(name: "phone_number")
  final String? phone;

  @override
  String toString() {
    return 'ProfileUpdateData(name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpdateDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpdateDataImplCopyWith<_$ProfileUpdateDataImpl> get copyWith =>
      __$$ProfileUpdateDataImplCopyWithImpl<_$ProfileUpdateDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpdateDataImplToJson(
      this,
    );
  }
}

abstract class _ProfileUpdateData implements ProfileUpdateData {
  factory _ProfileUpdateData(
          {@JsonKey(name: "name") final String? name,
          final String? email,
          @JsonKey(name: "phone_number") final String? phone}) =
      _$ProfileUpdateDataImpl;

  factory _ProfileUpdateData.fromJson(Map<String, dynamic> json) =
      _$ProfileUpdateDataImpl.fromJson;

  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  String? get email;
  @override
  @JsonKey(name: "phone_number")
  String? get phone;
  @override
  @JsonKey(ignore: true)
  _$$ProfileUpdateDataImplCopyWith<_$ProfileUpdateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
