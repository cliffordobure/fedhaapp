// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlannedPaymentRequest _$PlannedPaymentRequestFromJson(
    Map<String, dynamic> json) {
  return _PlannedPaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PlannedPaymentRequest {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_id')
  int get subcategoryId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_date')
  String get paymentDate => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlannedPaymentRequestCopyWith<PlannedPaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedPaymentRequestCopyWith<$Res> {
  factory $PlannedPaymentRequestCopyWith(PlannedPaymentRequest value,
          $Res Function(PlannedPaymentRequest) then) =
      _$PlannedPaymentRequestCopyWithImpl<$Res, PlannedPaymentRequest>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'subcategory_id') int subcategoryId,
      String amount,
      @JsonKey(name: 'payment_date') String paymentDate,
      String frequency});
}

/// @nodoc
class _$PlannedPaymentRequestCopyWithImpl<$Res,
        $Val extends PlannedPaymentRequest>
    implements $PlannedPaymentRequestCopyWith<$Res> {
  _$PlannedPaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? subcategoryId = null,
    Object? amount = null,
    Object? paymentDate = null,
    Object? frequency = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      subcategoryId: null == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedPaymentRequestImplCopyWith<$Res>
    implements $PlannedPaymentRequestCopyWith<$Res> {
  factory _$$PlannedPaymentRequestImplCopyWith(
          _$PlannedPaymentRequestImpl value,
          $Res Function(_$PlannedPaymentRequestImpl) then) =
      __$$PlannedPaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'subcategory_id') int subcategoryId,
      String amount,
      @JsonKey(name: 'payment_date') String paymentDate,
      String frequency});
}

/// @nodoc
class __$$PlannedPaymentRequestImplCopyWithImpl<$Res>
    extends _$PlannedPaymentRequestCopyWithImpl<$Res,
        _$PlannedPaymentRequestImpl>
    implements _$$PlannedPaymentRequestImplCopyWith<$Res> {
  __$$PlannedPaymentRequestImplCopyWithImpl(_$PlannedPaymentRequestImpl _value,
      $Res Function(_$PlannedPaymentRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? categoryId = null,
    Object? subcategoryId = null,
    Object? amount = null,
    Object? paymentDate = null,
    Object? frequency = null,
  }) {
    return _then(_$PlannedPaymentRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      subcategoryId: null == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: null == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedPaymentRequestImpl implements _PlannedPaymentRequest {
  const _$PlannedPaymentRequestImpl(
      {required this.name,
      @JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'subcategory_id') required this.subcategoryId,
      required this.amount,
      @JsonKey(name: 'payment_date') required this.paymentDate,
      required this.frequency});

  factory _$PlannedPaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedPaymentRequestImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'subcategory_id')
  final int subcategoryId;
  @override
  final String amount;
  @override
  @JsonKey(name: 'payment_date')
  final String paymentDate;
  @override
  final String frequency;

  @override
  String toString() {
    return 'PlannedPaymentRequest(name: $name, categoryId: $categoryId, subcategoryId: $subcategoryId, amount: $amount, paymentDate: $paymentDate, frequency: $frequency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedPaymentRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, categoryId, subcategoryId,
      amount, paymentDate, frequency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedPaymentRequestImplCopyWith<_$PlannedPaymentRequestImpl>
      get copyWith => __$$PlannedPaymentRequestImplCopyWithImpl<
          _$PlannedPaymentRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedPaymentRequestImplToJson(
      this,
    );
  }
}

abstract class _PlannedPaymentRequest implements PlannedPaymentRequest {
  const factory _PlannedPaymentRequest(
      {required final String name,
      @JsonKey(name: 'category_id') required final int categoryId,
      @JsonKey(name: 'subcategory_id') required final int subcategoryId,
      required final String amount,
      @JsonKey(name: 'payment_date') required final String paymentDate,
      required final String frequency}) = _$PlannedPaymentRequestImpl;

  factory _PlannedPaymentRequest.fromJson(Map<String, dynamic> json) =
      _$PlannedPaymentRequestImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'subcategory_id')
  int get subcategoryId;
  @override
  String get amount;
  @override
  @JsonKey(name: 'payment_date')
  String get paymentDate;
  @override
  String get frequency;
  @override
  @JsonKey(ignore: true)
  _$$PlannedPaymentRequestImplCopyWith<_$PlannedPaymentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
