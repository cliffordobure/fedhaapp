// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_messages.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionMessage _$TransactionMessageFromJson(Map<String, dynamic> json) {
  return _TransactionMessage.fromJson(json);
}

/// @nodoc
mixin _$TransactionMessage {
  String? get reference => throw _privateConstructorUsedError;
  dynamic get amount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get datetime => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get from => throw _privateConstructorUsedError;
  String? get to => throw _privateConstructorUsedError;
  dynamic get balance => throw _privateConstructorUsedError;
  dynamic get cost => throw _privateConstructorUsedError;
  dynamic get fulizaAmount => throw _privateConstructorUsedError;
  dynamic get interest => throw _privateConstructorUsedError;
  dynamic get outstanding => throw _privateConstructorUsedError;
  dynamic get mShwariBalance => throw _privateConstructorUsedError;
  String? get account => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionMessageCopyWith<TransactionMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionMessageCopyWith<$Res> {
  factory $TransactionMessageCopyWith(
          TransactionMessage value, $Res Function(TransactionMessage) then) =
      _$TransactionMessageCopyWithImpl<$Res, TransactionMessage>;
  @useResult
  $Res call(
      {String? reference,
      dynamic amount,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? datetime,
      String? type,
      String? from,
      String? to,
      dynamic balance,
      dynamic cost,
      dynamic fulizaAmount,
      dynamic interest,
      dynamic outstanding,
      dynamic mShwariBalance,
      String? account,
      String? currency});
}

/// @nodoc
class _$TransactionMessageCopyWithImpl<$Res, $Val extends TransactionMessage>
    implements $TransactionMessageCopyWith<$Res> {
  _$TransactionMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reference = freezed,
    Object? amount = freezed,
    Object? datetime = freezed,
    Object? type = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? balance = freezed,
    Object? cost = freezed,
    Object? fulizaAmount = freezed,
    Object? interest = freezed,
    Object? outstanding = freezed,
    Object? mShwariBalance = freezed,
    Object? account = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      from: freezed == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String?,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as dynamic,
      fulizaAmount: freezed == fulizaAmount
          ? _value.fulizaAmount
          : fulizaAmount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      interest: freezed == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as dynamic,
      outstanding: freezed == outstanding
          ? _value.outstanding
          : outstanding // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mShwariBalance: freezed == mShwariBalance
          ? _value.mShwariBalance
          : mShwariBalance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionMessageImplCopyWith<$Res>
    implements $TransactionMessageCopyWith<$Res> {
  factory _$$TransactionMessageImplCopyWith(_$TransactionMessageImpl value,
          $Res Function(_$TransactionMessageImpl) then) =
      __$$TransactionMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? reference,
      dynamic amount,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? datetime,
      String? type,
      String? from,
      String? to,
      dynamic balance,
      dynamic cost,
      dynamic fulizaAmount,
      dynamic interest,
      dynamic outstanding,
      dynamic mShwariBalance,
      String? account,
      String? currency});
}

/// @nodoc
class __$$TransactionMessageImplCopyWithImpl<$Res>
    extends _$TransactionMessageCopyWithImpl<$Res, _$TransactionMessageImpl>
    implements _$$TransactionMessageImplCopyWith<$Res> {
  __$$TransactionMessageImplCopyWithImpl(_$TransactionMessageImpl _value,
      $Res Function(_$TransactionMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reference = freezed,
    Object? amount = freezed,
    Object? datetime = freezed,
    Object? type = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? balance = freezed,
    Object? cost = freezed,
    Object? fulizaAmount = freezed,
    Object? interest = freezed,
    Object? outstanding = freezed,
    Object? mShwariBalance = freezed,
    Object? account = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$TransactionMessageImpl(
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      from: freezed == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String?,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      cost: freezed == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as dynamic,
      fulizaAmount: freezed == fulizaAmount
          ? _value.fulizaAmount
          : fulizaAmount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      interest: freezed == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as dynamic,
      outstanding: freezed == outstanding
          ? _value.outstanding
          : outstanding // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mShwariBalance: freezed == mShwariBalance
          ? _value.mShwariBalance
          : mShwariBalance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionMessageImpl implements _TransactionMessage {
  const _$TransactionMessageImpl(
      {this.reference,
      this.amount,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.datetime,
      this.type,
      this.from,
      this.to,
      this.balance,
      this.cost,
      this.fulizaAmount,
      this.interest,
      this.outstanding,
      this.mShwariBalance,
      this.account,
      this.currency = 'KES'});

  factory _$TransactionMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionMessageImplFromJson(json);

  @override
  final String? reference;
  @override
  final dynamic amount;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? datetime;
  @override
  final String? type;
  @override
  final String? from;
  @override
  final String? to;
  @override
  final dynamic balance;
  @override
  final dynamic cost;
  @override
  final dynamic fulizaAmount;
  @override
  final dynamic interest;
  @override
  final dynamic outstanding;
  @override
  final dynamic mShwariBalance;
  @override
  final String? account;
  @override
  @JsonKey()
  final String? currency;

  @override
  String toString() {
    return 'TransactionMessage(reference: $reference, amount: $amount, datetime: $datetime, type: $type, from: $from, to: $to, balance: $balance, cost: $cost, fulizaAmount: $fulizaAmount, interest: $interest, outstanding: $outstanding, mShwariBalance: $mShwariBalance, account: $account, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionMessageImpl &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            const DeepCollectionEquality().equals(other.amount, amount) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            const DeepCollectionEquality().equals(other.balance, balance) &&
            const DeepCollectionEquality().equals(other.cost, cost) &&
            const DeepCollectionEquality()
                .equals(other.fulizaAmount, fulizaAmount) &&
            const DeepCollectionEquality().equals(other.interest, interest) &&
            const DeepCollectionEquality()
                .equals(other.outstanding, outstanding) &&
            const DeepCollectionEquality()
                .equals(other.mShwariBalance, mShwariBalance) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reference,
      const DeepCollectionEquality().hash(amount),
      datetime,
      type,
      from,
      to,
      const DeepCollectionEquality().hash(balance),
      const DeepCollectionEquality().hash(cost),
      const DeepCollectionEquality().hash(fulizaAmount),
      const DeepCollectionEquality().hash(interest),
      const DeepCollectionEquality().hash(outstanding),
      const DeepCollectionEquality().hash(mShwariBalance),
      account,
      currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionMessageImplCopyWith<_$TransactionMessageImpl> get copyWith =>
      __$$TransactionMessageImplCopyWithImpl<_$TransactionMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionMessageImplToJson(
      this,
    );
  }
}

abstract class _TransactionMessage implements TransactionMessage {
  const factory _TransactionMessage(
      {final String? reference,
      final dynamic amount,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? datetime,
      final String? type,
      final String? from,
      final String? to,
      final dynamic balance,
      final dynamic cost,
      final dynamic fulizaAmount,
      final dynamic interest,
      final dynamic outstanding,
      final dynamic mShwariBalance,
      final String? account,
      final String? currency}) = _$TransactionMessageImpl;

  factory _TransactionMessage.fromJson(Map<String, dynamic> json) =
      _$TransactionMessageImpl.fromJson;

  @override
  String? get reference;
  @override
  dynamic get amount;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get datetime;
  @override
  String? get type;
  @override
  String? get from;
  @override
  String? get to;
  @override
  dynamic get balance;
  @override
  dynamic get cost;
  @override
  dynamic get fulizaAmount;
  @override
  dynamic get interest;
  @override
  dynamic get outstanding;
  @override
  dynamic get mShwariBalance;
  @override
  String? get account;
  @override
  String? get currency;
  @override
  @JsonKey(ignore: true)
  _$$TransactionMessageImplCopyWith<_$TransactionMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionMessageList _$TransactionMessageListFromJson(
    Map<String, dynamic> json) {
  return _TransactionsList.fromJson(json);
}

/// @nodoc
mixin _$TransactionMessageList {
  List<TransactionMessage> get transactions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionMessageListCopyWith<TransactionMessageList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionMessageListCopyWith<$Res> {
  factory $TransactionMessageListCopyWith(TransactionMessageList value,
          $Res Function(TransactionMessageList) then) =
      _$TransactionMessageListCopyWithImpl<$Res, TransactionMessageList>;
  @useResult
  $Res call({List<TransactionMessage> transactions});
}

/// @nodoc
class _$TransactionMessageListCopyWithImpl<$Res,
        $Val extends TransactionMessageList>
    implements $TransactionMessageListCopyWith<$Res> {
  _$TransactionMessageListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionMessage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionsListImplCopyWith<$Res>
    implements $TransactionMessageListCopyWith<$Res> {
  factory _$$TransactionsListImplCopyWith(_$TransactionsListImpl value,
          $Res Function(_$TransactionsListImpl) then) =
      __$$TransactionsListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransactionMessage> transactions});
}

/// @nodoc
class __$$TransactionsListImplCopyWithImpl<$Res>
    extends _$TransactionMessageListCopyWithImpl<$Res, _$TransactionsListImpl>
    implements _$$TransactionsListImplCopyWith<$Res> {
  __$$TransactionsListImplCopyWithImpl(_$TransactionsListImpl _value,
      $Res Function(_$TransactionsListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
  }) {
    return _then(_$TransactionsListImpl(
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionMessage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionsListImpl implements _TransactionsList {
  const _$TransactionsListImpl(
      {required final List<TransactionMessage> transactions})
      : _transactions = transactions;

  factory _$TransactionsListImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionsListImplFromJson(json);

  final List<TransactionMessage> _transactions;
  @override
  List<TransactionMessage> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'TransactionMessageList(transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionsListImpl &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_transactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionsListImplCopyWith<_$TransactionsListImpl> get copyWith =>
      __$$TransactionsListImplCopyWithImpl<_$TransactionsListImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionsListImplToJson(
      this,
    );
  }
}

abstract class _TransactionsList implements TransactionMessageList {
  const factory _TransactionsList(
          {required final List<TransactionMessage> transactions}) =
      _$TransactionsListImpl;

  factory _TransactionsList.fromJson(Map<String, dynamic> json) =
      _$TransactionsListImpl.fromJson;

  @override
  List<TransactionMessage> get transactions;
  @override
  @JsonKey(ignore: true)
  _$$TransactionsListImplCopyWith<_$TransactionsListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
