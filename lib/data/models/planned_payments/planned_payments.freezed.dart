// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_payments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlannedPayments _$PlannedPaymentsFromJson(Map<String, dynamic> json) {
  return _PlannedPayments.fromJson(json);
}

/// @nodoc
mixin _$PlannedPayments {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_date')
  String? get paymentDate => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  List<PaymentHistory>? get paymentHistories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlannedPaymentsCopyWith<PlannedPayments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedPaymentsCopyWith<$Res> {
  factory $PlannedPaymentsCopyWith(
          PlannedPayments value, $Res Function(PlannedPayments) then) =
      _$PlannedPaymentsCopyWithImpl<$Res, PlannedPayments>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? category,
      double? amount,
      @JsonKey(name: 'payment_date') String? paymentDate,
      String? frequency,
      List<PaymentHistory>? paymentHistories,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$PlannedPaymentsCopyWithImpl<$Res, $Val extends PlannedPayments>
    implements $PlannedPaymentsCopyWith<$Res> {
  _$PlannedPaymentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? amount = freezed,
    Object? paymentDate = freezed,
    Object? frequency = freezed,
    Object? paymentHistories = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentHistories: freezed == paymentHistories
          ? _value.paymentHistories
          : paymentHistories // ignore: cast_nullable_to_non_nullable
              as List<PaymentHistory>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedPaymentsImplCopyWith<$Res>
    implements $PlannedPaymentsCopyWith<$Res> {
  factory _$$PlannedPaymentsImplCopyWith(_$PlannedPaymentsImpl value,
          $Res Function(_$PlannedPaymentsImpl) then) =
      __$$PlannedPaymentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      String? category,
      double? amount,
      @JsonKey(name: 'payment_date') String? paymentDate,
      String? frequency,
      List<PaymentHistory>? paymentHistories,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$PlannedPaymentsImplCopyWithImpl<$Res>
    extends _$PlannedPaymentsCopyWithImpl<$Res, _$PlannedPaymentsImpl>
    implements _$$PlannedPaymentsImplCopyWith<$Res> {
  __$$PlannedPaymentsImplCopyWithImpl(
      _$PlannedPaymentsImpl _value, $Res Function(_$PlannedPaymentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? amount = freezed,
    Object? paymentDate = freezed,
    Object? frequency = freezed,
    Object? paymentHistories = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PlannedPaymentsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentHistories: freezed == paymentHistories
          ? _value._paymentHistories
          : paymentHistories // ignore: cast_nullable_to_non_nullable
              as List<PaymentHistory>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedPaymentsImpl implements _PlannedPayments {
  const _$PlannedPaymentsImpl(
      {this.id,
      this.name,
      this.category,
      this.amount,
      @JsonKey(name: 'payment_date') this.paymentDate,
      this.frequency,
      final List<PaymentHistory>? paymentHistories,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _paymentHistories = paymentHistories;

  factory _$PlannedPaymentsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedPaymentsImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? category;
  @override
  final double? amount;
  @override
  @JsonKey(name: 'payment_date')
  final String? paymentDate;
  @override
  final String? frequency;
  final List<PaymentHistory>? _paymentHistories;
  @override
  List<PaymentHistory>? get paymentHistories {
    final value = _paymentHistories;
    if (value == null) return null;
    if (_paymentHistories is EqualUnmodifiableListView)
      return _paymentHistories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'PlannedPayments(id: $id, name: $name, category: $category, amount: $amount, paymentDate: $paymentDate, frequency: $frequency, paymentHistories: $paymentHistories, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedPaymentsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality()
                .equals(other._paymentHistories, _paymentHistories) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      category,
      amount,
      paymentDate,
      frequency,
      const DeepCollectionEquality().hash(_paymentHistories),
      userId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedPaymentsImplCopyWith<_$PlannedPaymentsImpl> get copyWith =>
      __$$PlannedPaymentsImplCopyWithImpl<_$PlannedPaymentsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedPaymentsImplToJson(
      this,
    );
  }
}

abstract class _PlannedPayments implements PlannedPayments {
  const factory _PlannedPayments(
          {final int? id,
          final String? name,
          final String? category,
          final double? amount,
          @JsonKey(name: 'payment_date') final String? paymentDate,
          final String? frequency,
          final List<PaymentHistory>? paymentHistories,
          @JsonKey(name: 'user_id') final int? userId,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'updated_at') final String? updatedAt}) =
      _$PlannedPaymentsImpl;

  factory _PlannedPayments.fromJson(Map<String, dynamic> json) =
      _$PlannedPaymentsImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get category;
  @override
  double? get amount;
  @override
  @JsonKey(name: 'payment_date')
  String? get paymentDate;
  @override
  String? get frequency;
  @override
  List<PaymentHistory>? get paymentHistories;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlannedPaymentsImplCopyWith<_$PlannedPaymentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
