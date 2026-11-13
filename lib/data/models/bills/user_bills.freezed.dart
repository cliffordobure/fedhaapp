// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bills.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserBill _$UserBillFromJson(Map<String, dynamic> json) {
  return _UserBill.fromJson(json);
}

/// @nodoc
mixin _$UserBill {
  @JsonKey(name: 'all_total_amount')
  int get allTotalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Weekly')
  BillSpan get weekly => throw _privateConstructorUsedError;
  @JsonKey(name: 'Monthly')
  BillSpan get monthly => throw _privateConstructorUsedError;
  @JsonKey(name: 'Annually')
  BillSpan get annually => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBillCopyWith<UserBill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBillCopyWith<$Res> {
  factory $UserBillCopyWith(UserBill value, $Res Function(UserBill) then) =
      _$UserBillCopyWithImpl<$Res, UserBill>;
  @useResult
  $Res call(
      {@JsonKey(name: 'all_total_amount') int allTotalAmount,
      @JsonKey(name: 'Weekly') BillSpan weekly,
      @JsonKey(name: 'Monthly') BillSpan monthly,
      @JsonKey(name: 'Annually') BillSpan annually});

  $BillSpanCopyWith<$Res> get weekly;
  $BillSpanCopyWith<$Res> get monthly;
  $BillSpanCopyWith<$Res> get annually;
}

/// @nodoc
class _$UserBillCopyWithImpl<$Res, $Val extends UserBill>
    implements $UserBillCopyWith<$Res> {
  _$UserBillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTotalAmount = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? annually = null,
  }) {
    return _then(_value.copyWith(
      allTotalAmount: null == allTotalAmount
          ? _value.allTotalAmount
          : allTotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as BillSpan,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as BillSpan,
      annually: null == annually
          ? _value.annually
          : annually // ignore: cast_nullable_to_non_nullable
              as BillSpan,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BillSpanCopyWith<$Res> get weekly {
    return $BillSpanCopyWith<$Res>(_value.weekly, (value) {
      return _then(_value.copyWith(weekly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BillSpanCopyWith<$Res> get monthly {
    return $BillSpanCopyWith<$Res>(_value.monthly, (value) {
      return _then(_value.copyWith(monthly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BillSpanCopyWith<$Res> get annually {
    return $BillSpanCopyWith<$Res>(_value.annually, (value) {
      return _then(_value.copyWith(annually: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBillImplCopyWith<$Res>
    implements $UserBillCopyWith<$Res> {
  factory _$$UserBillImplCopyWith(
          _$UserBillImpl value, $Res Function(_$UserBillImpl) then) =
      __$$UserBillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'all_total_amount') int allTotalAmount,
      @JsonKey(name: 'Weekly') BillSpan weekly,
      @JsonKey(name: 'Monthly') BillSpan monthly,
      @JsonKey(name: 'Annually') BillSpan annually});

  @override
  $BillSpanCopyWith<$Res> get weekly;
  @override
  $BillSpanCopyWith<$Res> get monthly;
  @override
  $BillSpanCopyWith<$Res> get annually;
}

/// @nodoc
class __$$UserBillImplCopyWithImpl<$Res>
    extends _$UserBillCopyWithImpl<$Res, _$UserBillImpl>
    implements _$$UserBillImplCopyWith<$Res> {
  __$$UserBillImplCopyWithImpl(
      _$UserBillImpl _value, $Res Function(_$UserBillImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTotalAmount = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? annually = null,
  }) {
    return _then(_$UserBillImpl(
      allTotalAmount: null == allTotalAmount
          ? _value.allTotalAmount
          : allTotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as BillSpan,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as BillSpan,
      annually: null == annually
          ? _value.annually
          : annually // ignore: cast_nullable_to_non_nullable
              as BillSpan,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBillImpl implements _UserBill {
  const _$UserBillImpl(
      {@JsonKey(name: 'all_total_amount') required this.allTotalAmount,
      @JsonKey(name: 'Weekly') required this.weekly,
      @JsonKey(name: 'Monthly') required this.monthly,
      @JsonKey(name: 'Annually') required this.annually});

  factory _$UserBillImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBillImplFromJson(json);

  @override
  @JsonKey(name: 'all_total_amount')
  final int allTotalAmount;
  @override
  @JsonKey(name: 'Weekly')
  final BillSpan weekly;
  @override
  @JsonKey(name: 'Monthly')
  final BillSpan monthly;
  @override
  @JsonKey(name: 'Annually')
  final BillSpan annually;

  @override
  String toString() {
    return 'UserBill(allTotalAmount: $allTotalAmount, weekly: $weekly, monthly: $monthly, annually: $annually)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBillImpl &&
            (identical(other.allTotalAmount, allTotalAmount) ||
                other.allTotalAmount == allTotalAmount) &&
            (identical(other.weekly, weekly) || other.weekly == weekly) &&
            (identical(other.monthly, monthly) || other.monthly == monthly) &&
            (identical(other.annually, annually) ||
                other.annually == annually));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, allTotalAmount, weekly, monthly, annually);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBillImplCopyWith<_$UserBillImpl> get copyWith =>
      __$$UserBillImplCopyWithImpl<_$UserBillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBillImplToJson(
      this,
    );
  }
}

abstract class _UserBill implements UserBill {
  const factory _UserBill(
          {@JsonKey(name: 'all_total_amount') required final int allTotalAmount,
          @JsonKey(name: 'Weekly') required final BillSpan weekly,
          @JsonKey(name: 'Monthly') required final BillSpan monthly,
          @JsonKey(name: 'Annually') required final BillSpan annually}) =
      _$UserBillImpl;

  factory _UserBill.fromJson(Map<String, dynamic> json) =
      _$UserBillImpl.fromJson;

  @override
  @JsonKey(name: 'all_total_amount')
  int get allTotalAmount;
  @override
  @JsonKey(name: 'Weekly')
  BillSpan get weekly;
  @override
  @JsonKey(name: 'Monthly')
  BillSpan get monthly;
  @override
  @JsonKey(name: 'Annually')
  BillSpan get annually;
  @override
  @JsonKey(ignore: true)
  _$$UserBillImplCopyWith<_$UserBillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillSpan _$BillSpanFromJson(Map<String, dynamic> json) {
  return _BillSpan.fromJson(json);
}

/// @nodoc
mixin _$BillSpan {
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  List<Bill> get bills => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BillSpanCopyWith<BillSpan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillSpanCopyWith<$Res> {
  factory $BillSpanCopyWith(BillSpan value, $Res Function(BillSpan) then) =
      _$BillSpanCopyWithImpl<$Res, BillSpan>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') double totalAmount, List<Bill> bills});
}

/// @nodoc
class _$BillSpanCopyWithImpl<$Res, $Val extends BillSpan>
    implements $BillSpanCopyWith<$Res> {
  _$BillSpanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? bills = null,
  }) {
    return _then(_value.copyWith(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bills: null == bills
          ? _value.bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<Bill>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillSpanImplCopyWith<$Res>
    implements $BillSpanCopyWith<$Res> {
  factory _$$BillSpanImplCopyWith(
          _$BillSpanImpl value, $Res Function(_$BillSpanImpl) then) =
      __$$BillSpanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') double totalAmount, List<Bill> bills});
}

/// @nodoc
class __$$BillSpanImplCopyWithImpl<$Res>
    extends _$BillSpanCopyWithImpl<$Res, _$BillSpanImpl>
    implements _$$BillSpanImplCopyWith<$Res> {
  __$$BillSpanImplCopyWithImpl(
      _$BillSpanImpl _value, $Res Function(_$BillSpanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? bills = null,
  }) {
    return _then(_$BillSpanImpl(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bills: null == bills
          ? _value._bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<Bill>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillSpanImpl implements _BillSpan {
  const _$BillSpanImpl(
      {@JsonKey(name: 'total_amount') required this.totalAmount,
      required final List<Bill> bills})
      : _bills = bills;

  factory _$BillSpanImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillSpanImplFromJson(json);

  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  final List<Bill> _bills;
  @override
  List<Bill> get bills {
    if (_bills is EqualUnmodifiableListView) return _bills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bills);
  }

  @override
  String toString() {
    return 'BillSpan(totalAmount: $totalAmount, bills: $bills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillSpanImpl &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._bills, _bills));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalAmount, const DeepCollectionEquality().hash(_bills));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillSpanImplCopyWith<_$BillSpanImpl> get copyWith =>
      __$$BillSpanImplCopyWithImpl<_$BillSpanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillSpanImplToJson(
      this,
    );
  }
}

abstract class _BillSpan implements BillSpan {
  const factory _BillSpan(
      {@JsonKey(name: 'total_amount') required final double totalAmount,
      required final List<Bill> bills}) = _$BillSpanImpl;

  factory _BillSpan.fromJson(Map<String, dynamic> json) =
      _$BillSpanImpl.fromJson;

  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  List<Bill> get bills;
  @override
  @JsonKey(ignore: true)
  _$$BillSpanImplCopyWith<_$BillSpanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bill _$BillFromJson(Map<String, dynamic> json) {
  return _Bill.fromJson(json);
}

/// @nodoc
mixin _$Bill {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;
  String get wallet => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BillCopyWith<Bill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillCopyWith<$Res> {
  factory $BillCopyWith(Bill value, $Res Function(Bill) then) =
      _$BillCopyWithImpl<$Res, Bill>;
  @useResult
  $Res call({int id, String name, String img, String wallet, int amount});
}

/// @nodoc
class _$BillCopyWithImpl<$Res, $Val extends Bill>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = null,
    Object? wallet = null,
    Object? amount = null,
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
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillImplCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$$BillImplCopyWith(
          _$BillImpl value, $Res Function(_$BillImpl) then) =
      __$$BillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String img, String wallet, int amount});
}

/// @nodoc
class __$$BillImplCopyWithImpl<$Res>
    extends _$BillCopyWithImpl<$Res, _$BillImpl>
    implements _$$BillImplCopyWith<$Res> {
  __$$BillImplCopyWithImpl(_$BillImpl _value, $Res Function(_$BillImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = null,
    Object? wallet = null,
    Object? amount = null,
  }) {
    return _then(_$BillImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillImpl implements _Bill {
  const _$BillImpl(
      {required this.id,
      required this.name,
      required this.img,
      required this.wallet,
      required this.amount});

  factory _$BillImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String img;
  @override
  final String wallet;
  @override
  final int amount;

  @override
  String toString() {
    return 'Bill(id: $id, name: $name, img: $img, wallet: $wallet, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, img, wallet, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      __$$BillImplCopyWithImpl<_$BillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillImplToJson(
      this,
    );
  }
}

abstract class _Bill implements Bill {
  const factory _Bill(
      {required final int id,
      required final String name,
      required final String img,
      required final String wallet,
      required final int amount}) = _$BillImpl;

  factory _Bill.fromJson(Map<String, dynamic> json) = _$BillImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get img;
  @override
  String get wallet;
  @override
  int get amount;
  @override
  @JsonKey(ignore: true)
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
