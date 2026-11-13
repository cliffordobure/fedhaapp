// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'changepassword.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Changepassword _$ChangepasswordFromJson(Map<String, dynamic> json) {
  return _Changepassword.fromJson(json);
}

/// @nodoc
mixin _$Changepassword {
  @JsonKey(name: "current_password")
  String get currentPassword => throw _privateConstructorUsedError;
  @JsonKey(name: "new_password")
  String get newPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChangepasswordCopyWith<Changepassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangepasswordCopyWith<$Res> {
  factory $ChangepasswordCopyWith(
          Changepassword value, $Res Function(Changepassword) then) =
      _$ChangepasswordCopyWithImpl<$Res, Changepassword>;
  @useResult
  $Res call(
      {@JsonKey(name: "current_password") String currentPassword,
      @JsonKey(name: "new_password") String newPassword});
}

/// @nodoc
class _$ChangepasswordCopyWithImpl<$Res, $Val extends Changepassword>
    implements $ChangepasswordCopyWith<$Res> {
  _$ChangepasswordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangepasswordImplCopyWith<$Res>
    implements $ChangepasswordCopyWith<$Res> {
  factory _$$ChangepasswordImplCopyWith(_$ChangepasswordImpl value,
          $Res Function(_$ChangepasswordImpl) then) =
      __$$ChangepasswordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "current_password") String currentPassword,
      @JsonKey(name: "new_password") String newPassword});
}

/// @nodoc
class __$$ChangepasswordImplCopyWithImpl<$Res>
    extends _$ChangepasswordCopyWithImpl<$Res, _$ChangepasswordImpl>
    implements _$$ChangepasswordImplCopyWith<$Res> {
  __$$ChangepasswordImplCopyWithImpl(
      _$ChangepasswordImpl _value, $Res Function(_$ChangepasswordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_$ChangepasswordImpl(
      null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangepasswordImpl implements _Changepassword {
  _$ChangepasswordImpl(@JsonKey(name: "current_password") this.currentPassword,
      @JsonKey(name: "new_password") this.newPassword);

  factory _$ChangepasswordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangepasswordImplFromJson(json);

  @override
  @JsonKey(name: "current_password")
  final String currentPassword;
  @override
  @JsonKey(name: "new_password")
  final String newPassword;

  @override
  String toString() {
    return 'Changepassword(currentPassword: $currentPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangepasswordImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentPassword, newPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangepasswordImplCopyWith<_$ChangepasswordImpl> get copyWith =>
      __$$ChangepasswordImplCopyWithImpl<_$ChangepasswordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangepasswordImplToJson(
      this,
    );
  }
}

abstract class _Changepassword implements Changepassword {
  factory _Changepassword(
          @JsonKey(name: "current_password") final String currentPassword,
          @JsonKey(name: "new_password") final String newPassword) =
      _$ChangepasswordImpl;

  factory _Changepassword.fromJson(Map<String, dynamic> json) =
      _$ChangepasswordImpl.fromJson;

  @override
  @JsonKey(name: "current_password")
  String get currentPassword;
  @override
  @JsonKey(name: "new_password")
  String get newPassword;
  @override
  @JsonKey(ignore: true)
  _$$ChangepasswordImplCopyWith<_$ChangepasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
