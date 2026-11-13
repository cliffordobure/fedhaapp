// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscriptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FormSubscriptionSpans _$FormSubscriptionSpansFromJson(
    Map<String, dynamic> json) {
  return _FormSubscriptionSpans.fromJson(json);
}

/// @nodoc
mixin _$FormSubscriptionSpans {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormSubscriptionSpansCopyWith<FormSubscriptionSpans> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormSubscriptionSpansCopyWith<$Res> {
  factory $FormSubscriptionSpansCopyWith(FormSubscriptionSpans value,
          $Res Function(FormSubscriptionSpans) then) =
      _$FormSubscriptionSpansCopyWithImpl<$Res, FormSubscriptionSpans>;
  @useResult
  $Res call({int id, String name, int status});
}

/// @nodoc
class _$FormSubscriptionSpansCopyWithImpl<$Res,
        $Val extends FormSubscriptionSpans>
    implements $FormSubscriptionSpansCopyWith<$Res> {
  _$FormSubscriptionSpansCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormSubscriptionSpansImplCopyWith<$Res>
    implements $FormSubscriptionSpansCopyWith<$Res> {
  factory _$$FormSubscriptionSpansImplCopyWith(
          _$FormSubscriptionSpansImpl value,
          $Res Function(_$FormSubscriptionSpansImpl) then) =
      __$$FormSubscriptionSpansImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int status});
}

/// @nodoc
class __$$FormSubscriptionSpansImplCopyWithImpl<$Res>
    extends _$FormSubscriptionSpansCopyWithImpl<$Res,
        _$FormSubscriptionSpansImpl>
    implements _$$FormSubscriptionSpansImplCopyWith<$Res> {
  __$$FormSubscriptionSpansImplCopyWithImpl(_$FormSubscriptionSpansImpl _value,
      $Res Function(_$FormSubscriptionSpansImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_$FormSubscriptionSpansImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormSubscriptionSpansImpl implements _FormSubscriptionSpans {
  const _$FormSubscriptionSpansImpl(
      {required this.id, required this.name, required this.status});

  factory _$FormSubscriptionSpansImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormSubscriptionSpansImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int status;

  @override
  String toString() {
    return 'FormSubscriptionSpans(id: $id, name: $name, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormSubscriptionSpansImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormSubscriptionSpansImplCopyWith<_$FormSubscriptionSpansImpl>
      get copyWith => __$$FormSubscriptionSpansImplCopyWithImpl<
          _$FormSubscriptionSpansImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormSubscriptionSpansImplToJson(
      this,
    );
  }
}

abstract class _FormSubscriptionSpans implements FormSubscriptionSpans {
  const factory _FormSubscriptionSpans(
      {required final int id,
      required final String name,
      required final int status}) = _$FormSubscriptionSpansImpl;

  factory _FormSubscriptionSpans.fromJson(Map<String, dynamic> json) =
      _$FormSubscriptionSpansImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get status;
  @override
  @JsonKey(ignore: true)
  _$$FormSubscriptionSpansImplCopyWith<_$FormSubscriptionSpansImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FormSubscription _$FormSubscriptionFromJson(Map<String, dynamic> json) {
  return _FormSubscription.fromJson(json);
}

/// @nodoc
mixin _$FormSubscription {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get img => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  int? get amount => throw _privateConstructorUsedError;
  String? get wallet => throw _privateConstructorUsedError;
  DateTime? get paymentDate => throw _privateConstructorUsedError;
  DateTime? get nextPaymentDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormSubscriptionCopyWith<FormSubscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormSubscriptionCopyWith<$Res> {
  factory $FormSubscriptionCopyWith(
          FormSubscription value, $Res Function(FormSubscription) then) =
      _$FormSubscriptionCopyWithImpl<$Res, FormSubscription>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? img,
      int? status,
      int? amount,
      String? wallet,
      DateTime? paymentDate,
      DateTime? nextPaymentDate});
}

/// @nodoc
class _$FormSubscriptionCopyWithImpl<$Res, $Val extends FormSubscription>
    implements $FormSubscriptionCopyWith<$Res> {
  _$FormSubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
    Object? status = freezed,
    Object? amount = freezed,
    Object? wallet = freezed,
    Object? paymentDate = freezed,
    Object? nextPaymentDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      wallet: freezed == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextPaymentDate: freezed == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormSubscriptionImplCopyWith<$Res>
    implements $FormSubscriptionCopyWith<$Res> {
  factory _$$FormSubscriptionImplCopyWith(_$FormSubscriptionImpl value,
          $Res Function(_$FormSubscriptionImpl) then) =
      __$$FormSubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? img,
      int? status,
      int? amount,
      String? wallet,
      DateTime? paymentDate,
      DateTime? nextPaymentDate});
}

/// @nodoc
class __$$FormSubscriptionImplCopyWithImpl<$Res>
    extends _$FormSubscriptionCopyWithImpl<$Res, _$FormSubscriptionImpl>
    implements _$$FormSubscriptionImplCopyWith<$Res> {
  __$$FormSubscriptionImplCopyWithImpl(_$FormSubscriptionImpl _value,
      $Res Function(_$FormSubscriptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
    Object? status = freezed,
    Object? amount = freezed,
    Object? wallet = freezed,
    Object? paymentDate = freezed,
    Object? nextPaymentDate = freezed,
  }) {
    return _then(_$FormSubscriptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      wallet: freezed == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextPaymentDate: freezed == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormSubscriptionImpl implements _FormSubscription {
  const _$FormSubscriptionImpl(
      {required this.id,
      required this.name,
      this.img,
      this.status,
      this.amount,
      this.wallet,
      this.paymentDate,
      this.nextPaymentDate});

  factory _$FormSubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormSubscriptionImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? img;
  @override
  final int? status;
  @override
  final int? amount;
  @override
  final String? wallet;
  @override
  final DateTime? paymentDate;
  @override
  final DateTime? nextPaymentDate;

  @override
  String toString() {
    return 'FormSubscription(id: $id, name: $name, img: $img, status: $status, amount: $amount, wallet: $wallet, paymentDate: $paymentDate, nextPaymentDate: $nextPaymentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormSubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.nextPaymentDate, nextPaymentDate) ||
                other.nextPaymentDate == nextPaymentDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, img, status, amount,
      wallet, paymentDate, nextPaymentDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormSubscriptionImplCopyWith<_$FormSubscriptionImpl> get copyWith =>
      __$$FormSubscriptionImplCopyWithImpl<_$FormSubscriptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormSubscriptionImplToJson(
      this,
    );
  }
}

abstract class _FormSubscription implements FormSubscription {
  const factory _FormSubscription(
      {required final int id,
      required final String name,
      final String? img,
      final int? status,
      final int? amount,
      final String? wallet,
      final DateTime? paymentDate,
      final DateTime? nextPaymentDate}) = _$FormSubscriptionImpl;

  factory _FormSubscription.fromJson(Map<String, dynamic> json) =
      _$FormSubscriptionImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get img;
  @override
  int? get status;
  @override
  int? get amount;
  @override
  String? get wallet;
  @override
  DateTime? get paymentDate;
  @override
  DateTime? get nextPaymentDate;
  @override
  @JsonKey(ignore: true)
  _$$FormSubscriptionImplCopyWith<_$FormSubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
