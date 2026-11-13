// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionResponse {
  int get status => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: "total_amount", fromJson: _parseDouble)
  double? get totalAmount => throw _privateConstructorUsedError;
  List<Transaction> get data => throw _privateConstructorUsedError;
  @JsonKey(name: "next_page_url")
  String? get nextPageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "prev_page_url")
  String? get previousPageUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionResponseCopyWith<TransactionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionResponseCopyWith<$Res> {
  factory $TransactionResponseCopyWith(
          TransactionResponse value, $Res Function(TransactionResponse) then) =
      _$TransactionResponseCopyWithImpl<$Res, TransactionResponse>;
  @useResult
  $Res call(
      {int status,
      bool success,
      String message,
      @JsonKey(name: "total_amount", fromJson: _parseDouble)
      double? totalAmount,
      List<Transaction> data,
      @JsonKey(name: "next_page_url") String? nextPageUrl,
      @JsonKey(name: "prev_page_url") String? previousPageUrl});
}

/// @nodoc
class _$TransactionResponseCopyWithImpl<$Res, $Val extends TransactionResponse>
    implements $TransactionResponseCopyWith<$Res> {
  _$TransactionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? success = null,
    Object? message = null,
    Object? totalAmount = freezed,
    Object? data = null,
    Object? nextPageUrl = freezed,
    Object? previousPageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      previousPageUrl: freezed == previousPageUrl
          ? _value.previousPageUrl
          : previousPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionResponseImplCopyWith<$Res>
    implements $TransactionResponseCopyWith<$Res> {
  factory _$$TransactionResponseImplCopyWith(_$TransactionResponseImpl value,
          $Res Function(_$TransactionResponseImpl) then) =
      __$$TransactionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int status,
      bool success,
      String message,
      @JsonKey(name: "total_amount", fromJson: _parseDouble)
      double? totalAmount,
      List<Transaction> data,
      @JsonKey(name: "next_page_url") String? nextPageUrl,
      @JsonKey(name: "prev_page_url") String? previousPageUrl});
}

/// @nodoc
class __$$TransactionResponseImplCopyWithImpl<$Res>
    extends _$TransactionResponseCopyWithImpl<$Res, _$TransactionResponseImpl>
    implements _$$TransactionResponseImplCopyWith<$Res> {
  __$$TransactionResponseImplCopyWithImpl(_$TransactionResponseImpl _value,
      $Res Function(_$TransactionResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? success = null,
    Object? message = null,
    Object? totalAmount = freezed,
    Object? data = null,
    Object? nextPageUrl = freezed,
    Object? previousPageUrl = freezed,
  }) {
    return _then(_$TransactionResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      previousPageUrl: freezed == previousPageUrl
          ? _value.previousPageUrl
          : previousPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TransactionResponseImpl implements _TransactionResponse {
  const _$TransactionResponseImpl(
      {required this.status,
      required this.success,
      required this.message,
      @JsonKey(name: "total_amount", fromJson: _parseDouble) this.totalAmount,
      required final List<Transaction> data,
      @JsonKey(name: "next_page_url") this.nextPageUrl,
      @JsonKey(name: "prev_page_url") this.previousPageUrl})
      : _data = data;

  @override
  final int status;
  @override
  final bool success;
  @override
  final String message;
  @override
  @JsonKey(name: "total_amount", fromJson: _parseDouble)
  final double? totalAmount;
  final List<Transaction> _data;
  @override
  List<Transaction> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;
  @override
  @JsonKey(name: "prev_page_url")
  final String? previousPageUrl;

  @override
  String toString() {
    return 'TransactionResponse(status: $status, success: $success, message: $message, totalAmount: $totalAmount, data: $data, nextPageUrl: $nextPageUrl, previousPageUrl: $previousPageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.previousPageUrl, previousPageUrl) ||
                other.previousPageUrl == previousPageUrl));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      success,
      message,
      totalAmount,
      const DeepCollectionEquality().hash(_data),
      nextPageUrl,
      previousPageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionResponseImplCopyWith<_$TransactionResponseImpl> get copyWith =>
      __$$TransactionResponseImplCopyWithImpl<_$TransactionResponseImpl>(
          this, _$identity);
}

abstract class _TransactionResponse implements TransactionResponse {
  const factory _TransactionResponse(
          {required final int status,
          required final bool success,
          required final String message,
          @JsonKey(name: "total_amount", fromJson: _parseDouble)
          final double? totalAmount,
          required final List<Transaction> data,
          @JsonKey(name: "next_page_url") final String? nextPageUrl,
          @JsonKey(name: "prev_page_url") final String? previousPageUrl}) =
      _$TransactionResponseImpl;

  @override
  int get status;
  @override
  bool get success;
  @override
  String get message;
  @override
  @JsonKey(name: "total_amount", fromJson: _parseDouble)
  double? get totalAmount;
  @override
  List<Transaction> get data;
  @override
  @JsonKey(name: "next_page_url")
  String? get nextPageUrl;
  @override
  @JsonKey(name: "prev_page_url")
  String? get previousPageUrl;
  @override
  @JsonKey(ignore: true)
  _$$TransactionResponseImplCopyWith<_$TransactionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_id', fromJson: _parseInt)
  int? get subcategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'wallet_id')
  int? get walletId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_id')
  String get transactionId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseTransactionType)
  TransactionType get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get amount => throw _privateConstructorUsedError;
  String get narration => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get charges => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
  DateTime? get date => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get balance => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'created_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'updated_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(name: 'subcategory_id', fromJson: _parseInt) int? subcategoryId,
      @JsonKey(name: 'wallet_id') int? walletId,
      @JsonKey(name: 'transaction_id') String transactionId,
      @JsonKey(fromJson: _parseTransactionType) TransactionType type,
      @JsonKey(fromJson: _parseDouble) double amount,
      String narration,
      @JsonKey(fromJson: _parseDouble) double? charges,
      @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
      DateTime? date,
      @JsonKey(fromJson: _parseDouble) double? balance,
      String? currency,
      @JsonKey(
          name: 'created_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      DateTime? updatedAt});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? walletId = freezed,
    Object? transactionId = null,
    Object? type = null,
    Object? amount = null,
    Object? narration = null,
    Object? charges = freezed,
    Object? date = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      narration: null == narration
          ? _value.narration
          : narration // ignore: cast_nullable_to_non_nullable
              as String,
      charges: freezed == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(name: 'subcategory_id', fromJson: _parseInt) int? subcategoryId,
      @JsonKey(name: 'wallet_id') int? walletId,
      @JsonKey(name: 'transaction_id') String transactionId,
      @JsonKey(fromJson: _parseTransactionType) TransactionType type,
      @JsonKey(fromJson: _parseDouble) double amount,
      String narration,
      @JsonKey(fromJson: _parseDouble) double? charges,
      @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
      DateTime? date,
      @JsonKey(fromJson: _parseDouble) double? balance,
      String? currency,
      @JsonKey(
          name: 'created_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      DateTime? updatedAt});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? walletId = freezed,
    Object? transactionId = null,
    Object? type = null,
    Object? amount = null,
    Object? narration = null,
    Object? charges = freezed,
    Object? date = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      walletId: freezed == walletId
          ? _value.walletId
          : walletId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      narration: null == narration
          ? _value.narration
          : narration // ignore: cast_nullable_to_non_nullable
              as String,
      charges: freezed == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {this.id = -1,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'subcategory_id', fromJson: _parseInt) this.subcategoryId,
      @JsonKey(name: 'wallet_id') this.walletId,
      @JsonKey(name: 'transaction_id') required this.transactionId,
      @JsonKey(fromJson: _parseTransactionType) required this.type,
      @JsonKey(fromJson: _parseDouble) required this.amount,
      this.narration = "",
      @JsonKey(fromJson: _parseDouble) this.charges,
      @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
      this.date,
      @JsonKey(fromJson: _parseDouble) this.balance,
      this.currency = "KES",
      @JsonKey(
          name: 'created_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      this.createdAt,
      @JsonKey(
          name: 'updated_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      this.updatedAt});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @override
  @JsonKey(name: 'subcategory_id', fromJson: _parseInt)
  final int? subcategoryId;
  @override
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @override
  @JsonKey(name: 'transaction_id')
  final String transactionId;
  @override
  @JsonKey(fromJson: _parseTransactionType)
  final TransactionType type;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double amount;
  @override
  @JsonKey()
  final String narration;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? charges;
  @override
  @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
  final DateTime? date;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? balance;
  @override
  @JsonKey()
  final String? currency;
  @override
  @JsonKey(
      name: 'created_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  final DateTime? createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, categoryId: $categoryId, subcategoryId: $subcategoryId, walletId: $walletId, transactionId: $transactionId, type: $type, amount: $amount, narration: $narration, charges: $charges, date: $date, balance: $balance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.walletId, walletId) ||
                other.walletId == walletId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.narration, narration) ||
                other.narration == narration) &&
            (identical(other.charges, charges) || other.charges == charges) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      categoryId,
      subcategoryId,
      walletId,
      transactionId,
      type,
      amount,
      narration,
      charges,
      date,
      balance,
      currency,
      createdAt,
      updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {final int id,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'category_id') final int? categoryId,
      @JsonKey(name: 'subcategory_id', fromJson: _parseInt)
      final int? subcategoryId,
      @JsonKey(name: 'wallet_id') final int? walletId,
      @JsonKey(name: 'transaction_id') required final String transactionId,
      @JsonKey(fromJson: _parseTransactionType)
      required final TransactionType type,
      @JsonKey(fromJson: _parseDouble) required final double amount,
      final String narration,
      @JsonKey(fromJson: _parseDouble) final double? charges,
      @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
      final DateTime? date,
      @JsonKey(fromJson: _parseDouble) final double? balance,
      final String? currency,
      @JsonKey(
          name: 'created_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      final DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          toJson: _dateTimeToString,
          fromJson: _dateTimeFromString)
      final DateTime? updatedAt}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'category_id')
  int? get categoryId;
  @override
  @JsonKey(name: 'subcategory_id', fromJson: _parseInt)
  int? get subcategoryId;
  @override
  @JsonKey(name: 'wallet_id')
  int? get walletId;
  @override
  @JsonKey(name: 'transaction_id')
  String get transactionId;
  @override
  @JsonKey(fromJson: _parseTransactionType)
  TransactionType get type;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get amount;
  @override
  String get narration;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get charges;
  @override
  @JsonKey(toJson: _dateTimeToString, fromJson: _dateTimeFromString)
  DateTime? get date;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get balance;
  @override
  String? get currency;
  @override
  @JsonKey(
      name: 'created_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  DateTime? get createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      toJson: _dateTimeToString,
      fromJson: _dateTimeFromString)
  DateTime? get updatedAt;
  @override
  Map<String, dynamic> toJson();
  @override
  @JsonKey(ignore: true)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({int id, String name, String description});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String description});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
  }) {
    return _then(_$CategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {required this.id, required this.name, this.description = ''});

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(
      this,
    );
  }
}

abstract class _Category implements Category {
  const factory _Category(
      {required final int id,
      required final String name,
      final String description}) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomeType _$IncomeTypeFromJson(Map<String, dynamic> json) {
  return _IncomeType.fromJson(json);
}

/// @nodoc
mixin _$IncomeType {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncomeTypeCopyWith<IncomeType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeTypeCopyWith<$Res> {
  factory $IncomeTypeCopyWith(
          IncomeType value, $Res Function(IncomeType) then) =
      _$IncomeTypeCopyWithImpl<$Res, IncomeType>;
  @useResult
  $Res call(
      {int id,
      String name,
      int? status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
      DateTime? updatedAt});
}

/// @nodoc
class _$IncomeTypeCopyWithImpl<$Res, $Val extends IncomeType>
    implements $IncomeTypeCopyWith<$Res> {
  _$IncomeTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeTypeImplCopyWith<$Res>
    implements $IncomeTypeCopyWith<$Res> {
  factory _$$IncomeTypeImplCopyWith(
          _$IncomeTypeImpl value, $Res Function(_$IncomeTypeImpl) then) =
      __$$IncomeTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int? status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
      DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
      DateTime? updatedAt});
}

/// @nodoc
class __$$IncomeTypeImplCopyWithImpl<$Res>
    extends _$IncomeTypeCopyWithImpl<$Res, _$IncomeTypeImpl>
    implements _$$IncomeTypeImplCopyWith<$Res> {
  __$$IncomeTypeImplCopyWithImpl(
      _$IncomeTypeImpl _value, $Res Function(_$IncomeTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$IncomeTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomeTypeImpl implements _IncomeType {
  const _$IncomeTypeImpl(
      {required this.id,
      required this.name,
      this.status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
      this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
      this.updatedAt});

  factory _$IncomeTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomeTypeImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int? status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'IncomeType(id: $id, name: $name, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, status, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeTypeImplCopyWith<_$IncomeTypeImpl> get copyWith =>
      __$$IncomeTypeImplCopyWithImpl<_$IncomeTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomeTypeImplToJson(
      this,
    );
  }
}

abstract class _IncomeType implements IncomeType {
  const factory _IncomeType(
      {required final int id,
      required final String name,
      final int? status,
      @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
      final DateTime? updatedAt}) = _$IncomeTypeImpl;

  factory _IncomeType.fromJson(Map<String, dynamic> json) =
      _$IncomeTypeImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int? get status;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromString)
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromString)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$IncomeTypeImplCopyWith<_$IncomeTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) {
  return _TransactionData.fromJson(json);
}

/// @nodoc
mixin _$TransactionData {
  @JsonKey(name: "category_id")
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: "subcategory_id", fromJson: _parseInt)
  int? get subcategoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: "wallet_id")
  int get wallet => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double get charges => throw _privateConstructorUsedError;
  @JsonKey(name: "date", fromJson: _dateTimeFromString)
  DateTime? get datetime => throw _privateConstructorUsedError;
  @JsonKey(name: "transaction_id")
  String get code => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionDataCopyWith<TransactionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDataCopyWith<$Res> {
  factory $TransactionDataCopyWith(
          TransactionData value, $Res Function(TransactionData) then) =
      _$TransactionDataCopyWithImpl<$Res, TransactionData>;
  @useResult
  $Res call(
      {@JsonKey(name: "category_id") int? categoryId,
      @JsonKey(name: "subcategory_id", fromJson: _parseInt) int? subcategoryId,
      String name,
      @JsonKey(name: "wallet_id") int wallet,
      @JsonKey(fromJson: _parseDouble) double amount,
      @JsonKey(fromJson: _parseDouble) double charges,
      @JsonKey(name: "date", fromJson: _dateTimeFromString) DateTime? datetime,
      @JsonKey(name: "transaction_id") String code,
      String type,
      String? currency});
}

/// @nodoc
class _$TransactionDataCopyWithImpl<$Res, $Val extends TransactionData>
    implements $TransactionDataCopyWith<$Res> {
  _$TransactionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? wallet = null,
    Object? amount = null,
    Object? charges = null,
    Object? datetime = freezed,
    Object? code = null,
    Object? type = null,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      charges: null == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionDataImplCopyWith<$Res>
    implements $TransactionDataCopyWith<$Res> {
  factory _$$TransactionDataImplCopyWith(_$TransactionDataImpl value,
          $Res Function(_$TransactionDataImpl) then) =
      __$$TransactionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "category_id") int? categoryId,
      @JsonKey(name: "subcategory_id", fromJson: _parseInt) int? subcategoryId,
      String name,
      @JsonKey(name: "wallet_id") int wallet,
      @JsonKey(fromJson: _parseDouble) double amount,
      @JsonKey(fromJson: _parseDouble) double charges,
      @JsonKey(name: "date", fromJson: _dateTimeFromString) DateTime? datetime,
      @JsonKey(name: "transaction_id") String code,
      String type,
      String? currency});
}

/// @nodoc
class __$$TransactionDataImplCopyWithImpl<$Res>
    extends _$TransactionDataCopyWithImpl<$Res, _$TransactionDataImpl>
    implements _$$TransactionDataImplCopyWith<$Res> {
  __$$TransactionDataImplCopyWithImpl(
      _$TransactionDataImpl _value, $Res Function(_$TransactionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = freezed,
    Object? subcategoryId = freezed,
    Object? name = null,
    Object? wallet = null,
    Object? amount = null,
    Object? charges = null,
    Object? datetime = freezed,
    Object? code = null,
    Object? type = null,
    Object? currency = freezed,
  }) {
    return _then(_$TransactionDataImpl(
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      charges: null == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double,
      datetime: freezed == datetime
          ? _value.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionDataImpl implements _TransactionData {
  const _$TransactionDataImpl(
      {@JsonKey(name: "category_id") this.categoryId,
      @JsonKey(name: "subcategory_id", fromJson: _parseInt) this.subcategoryId,
      required this.name,
      @JsonKey(name: "wallet_id") required this.wallet,
      @JsonKey(fromJson: _parseDouble) required this.amount,
      @JsonKey(fromJson: _parseDouble) required this.charges,
      @JsonKey(name: "date", fromJson: _dateTimeFromString) this.datetime,
      @JsonKey(name: "transaction_id") required this.code,
      required this.type,
      this.currency = 'KES'});

  factory _$TransactionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionDataImplFromJson(json);

  @override
  @JsonKey(name: "category_id")
  final int? categoryId;
  @override
  @JsonKey(name: "subcategory_id", fromJson: _parseInt)
  final int? subcategoryId;
  @override
  final String name;
  @override
  @JsonKey(name: "wallet_id")
  final int wallet;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double amount;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double charges;
  @override
  @JsonKey(name: "date", fromJson: _dateTimeFromString)
  final DateTime? datetime;
  @override
  @JsonKey(name: "transaction_id")
  final String code;
  @override
  final String type;
  @override
  @JsonKey()
  final String? currency;

  @override
  String toString() {
    return 'TransactionData(categoryId: $categoryId, subcategoryId: $subcategoryId, name: $name, wallet: $wallet, amount: $amount, charges: $charges, datetime: $datetime, code: $code, type: $type, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDataImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.wallet, wallet) || other.wallet == wallet) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.charges, charges) || other.charges == charges) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId, subcategoryId, name,
      wallet, amount, charges, datetime, code, type, currency);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionDataImplToJson(
      this,
    );
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDataImplCopyWith<_$TransactionDataImpl> get copyWith =>
      __$$TransactionDataImplCopyWithImpl<_$TransactionDataImpl>(
          this, _$identity);
}

abstract class _TransactionData implements TransactionData {
  const factory _TransactionData(
      {@JsonKey(name: "category_id") final int? categoryId,
      @JsonKey(name: "subcategory_id", fromJson: _parseInt)
      final int? subcategoryId,
      required final String name,
      @JsonKey(name: "wallet_id") required final int wallet,
      @JsonKey(fromJson: _parseDouble) required final double amount,
      @JsonKey(fromJson: _parseDouble) required final double charges,
      @JsonKey(name: "date", fromJson: _dateTimeFromString)
      final DateTime? datetime,
      @JsonKey(name: "transaction_id") required final String code,
      required final String type,
      final String? currency}) = _$TransactionDataImpl;

  factory _TransactionData.fromJson(Map<String, dynamic> json) =
      _$TransactionDataImpl.fromJson;

  @override
  @JsonKey(name: "category_id")
  int? get categoryId;
  @override
  @JsonKey(name: "subcategory_id", fromJson: _parseInt)
  int? get subcategoryId;
  @override
  String get name;
  @override
  @JsonKey(name: "wallet_id")
  int get wallet;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get amount;
  @override
  @JsonKey(fromJson: _parseDouble)
  double get charges;
  @override
  @JsonKey(name: "date", fromJson: _dateTimeFromString)
  DateTime? get datetime;
  @override
  @JsonKey(name: "transaction_id")
  String get code;
  @override
  String get type;
  @override
  String? get currency;
  @override
  Map<String, dynamic> toJson();
  @override
  @JsonKey(ignore: true)
  _$$TransactionDataImplCopyWith<_$TransactionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupedTransactionsResponse _$GroupedTransactionsResponseFromJson(
    Map<String, dynamic> json) {
  return _GroupedTransactionsResponse.fromJson(json);
}

/// @nodoc
mixin _$GroupedTransactionsResponse {
  bool get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  GroupedTransactionsData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupedTransactionsResponseCopyWith<GroupedTransactionsResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedTransactionsResponseCopyWith<$Res> {
  factory $GroupedTransactionsResponseCopyWith(
          GroupedTransactionsResponse value,
          $Res Function(GroupedTransactionsResponse) then) =
      _$GroupedTransactionsResponseCopyWithImpl<$Res,
          GroupedTransactionsResponse>;
  @useResult
  $Res call({bool status, String message, GroupedTransactionsData data});

  $GroupedTransactionsDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GroupedTransactionsResponseCopyWithImpl<$Res,
        $Val extends GroupedTransactionsResponse>
    implements $GroupedTransactionsResponseCopyWith<$Res> {
  _$GroupedTransactionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GroupedTransactionsData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GroupedTransactionsDataCopyWith<$Res> get data {
    return $GroupedTransactionsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupedTransactionsResponseImplCopyWith<$Res>
    implements $GroupedTransactionsResponseCopyWith<$Res> {
  factory _$$GroupedTransactionsResponseImplCopyWith(
          _$GroupedTransactionsResponseImpl value,
          $Res Function(_$GroupedTransactionsResponseImpl) then) =
      __$$GroupedTransactionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool status, String message, GroupedTransactionsData data});

  @override
  $GroupedTransactionsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GroupedTransactionsResponseImplCopyWithImpl<$Res>
    extends _$GroupedTransactionsResponseCopyWithImpl<$Res,
        _$GroupedTransactionsResponseImpl>
    implements _$$GroupedTransactionsResponseImplCopyWith<$Res> {
  __$$GroupedTransactionsResponseImplCopyWithImpl(
      _$GroupedTransactionsResponseImpl _value,
      $Res Function(_$GroupedTransactionsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$GroupedTransactionsResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GroupedTransactionsData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupedTransactionsResponseImpl
    implements _GroupedTransactionsResponse {
  const _$GroupedTransactionsResponseImpl(
      {required this.status, required this.message, required this.data});

  factory _$GroupedTransactionsResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GroupedTransactionsResponseImplFromJson(json);

  @override
  final bool status;
  @override
  final String message;
  @override
  final GroupedTransactionsData data;

  @override
  String toString() {
    return 'GroupedTransactionsResponse(status: $status, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedTransactionsResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedTransactionsResponseImplCopyWith<_$GroupedTransactionsResponseImpl>
      get copyWith => __$$GroupedTransactionsResponseImplCopyWithImpl<
          _$GroupedTransactionsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupedTransactionsResponseImplToJson(
      this,
    );
  }
}

abstract class _GroupedTransactionsResponse
    implements GroupedTransactionsResponse {
  const factory _GroupedTransactionsResponse(
          {required final bool status,
          required final String message,
          required final GroupedTransactionsData data}) =
      _$GroupedTransactionsResponseImpl;

  factory _GroupedTransactionsResponse.fromJson(Map<String, dynamic> json) =
      _$GroupedTransactionsResponseImpl.fromJson;

  @override
  bool get status;
  @override
  String get message;
  @override
  GroupedTransactionsData get data;
  @override
  @JsonKey(ignore: true)
  _$$GroupedTransactionsResponseImplCopyWith<_$GroupedTransactionsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GroupedTransactionsData _$GroupedTransactionsDataFromJson(
    Map<String, dynamic> json) {
  return _GroupedTransactionsData.fromJson(json);
}

/// @nodoc
mixin _$GroupedTransactionsData {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  List<GroupedTransaction> get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_page_url')
  String get firstPageUrl => throw _privateConstructorUsedError;
  int get from => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page')
  int get lastPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page_url')
  String get lastPageUrl => throw _privateConstructorUsedError;
  List<PageLink> get links => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_page_url')
  String? get nextPageUrl => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'prev_page_url')
  String? get prevPageUrl => throw _privateConstructorUsedError;
  int get to => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupedTransactionsDataCopyWith<GroupedTransactionsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedTransactionsDataCopyWith<$Res> {
  factory $GroupedTransactionsDataCopyWith(GroupedTransactionsData value,
          $Res Function(GroupedTransactionsData) then) =
      _$GroupedTransactionsDataCopyWithImpl<$Res, GroupedTransactionsData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      List<GroupedTransaction> data,
      @JsonKey(name: 'first_page_url') String firstPageUrl,
      int from,
      @JsonKey(name: 'last_page') int lastPage,
      @JsonKey(name: 'last_page_url') String lastPageUrl,
      List<PageLink> links,
      @JsonKey(name: 'next_page_url') String? nextPageUrl,
      String path,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'prev_page_url') String? prevPageUrl,
      int to,
      int total});
}

/// @nodoc
class _$GroupedTransactionsDataCopyWithImpl<$Res,
        $Val extends GroupedTransactionsData>
    implements $GroupedTransactionsDataCopyWith<$Res> {
  _$GroupedTransactionsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? data = null,
    Object? firstPageUrl = null,
    Object? from = null,
    Object? lastPage = null,
    Object? lastPageUrl = null,
    Object? links = null,
    Object? nextPageUrl = freezed,
    Object? path = null,
    Object? perPage = null,
    Object? prevPageUrl = freezed,
    Object? to = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<GroupedTransaction>,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<PageLink>,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      prevPageUrl: freezed == prevPageUrl
          ? _value.prevPageUrl
          : prevPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupedTransactionsDataImplCopyWith<$Res>
    implements $GroupedTransactionsDataCopyWith<$Res> {
  factory _$$GroupedTransactionsDataImplCopyWith(
          _$GroupedTransactionsDataImpl value,
          $Res Function(_$GroupedTransactionsDataImpl) then) =
      __$$GroupedTransactionsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      List<GroupedTransaction> data,
      @JsonKey(name: 'first_page_url') String firstPageUrl,
      int from,
      @JsonKey(name: 'last_page') int lastPage,
      @JsonKey(name: 'last_page_url') String lastPageUrl,
      List<PageLink> links,
      @JsonKey(name: 'next_page_url') String? nextPageUrl,
      String path,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'prev_page_url') String? prevPageUrl,
      int to,
      int total});
}

/// @nodoc
class __$$GroupedTransactionsDataImplCopyWithImpl<$Res>
    extends _$GroupedTransactionsDataCopyWithImpl<$Res,
        _$GroupedTransactionsDataImpl>
    implements _$$GroupedTransactionsDataImplCopyWith<$Res> {
  __$$GroupedTransactionsDataImplCopyWithImpl(
      _$GroupedTransactionsDataImpl _value,
      $Res Function(_$GroupedTransactionsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? data = null,
    Object? firstPageUrl = null,
    Object? from = null,
    Object? lastPage = null,
    Object? lastPageUrl = null,
    Object? links = null,
    Object? nextPageUrl = freezed,
    Object? path = null,
    Object? perPage = null,
    Object? prevPageUrl = freezed,
    Object? to = null,
    Object? total = null,
  }) {
    return _then(_$GroupedTransactionsDataImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<GroupedTransaction>,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<PageLink>,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      prevPageUrl: freezed == prevPageUrl
          ? _value.prevPageUrl
          : prevPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupedTransactionsDataImpl implements _GroupedTransactionsData {
  const _$GroupedTransactionsDataImpl(
      {@JsonKey(name: 'current_page') required this.currentPage,
      required final List<GroupedTransaction> data,
      @JsonKey(name: 'first_page_url') required this.firstPageUrl,
      required this.from,
      @JsonKey(name: 'last_page') required this.lastPage,
      @JsonKey(name: 'last_page_url') required this.lastPageUrl,
      required final List<PageLink> links,
      @JsonKey(name: 'next_page_url') this.nextPageUrl,
      required this.path,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'prev_page_url') this.prevPageUrl,
      required this.to,
      required this.total})
      : _data = data,
        _links = links;

  factory _$GroupedTransactionsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupedTransactionsDataImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<GroupedTransaction> _data;
  @override
  List<GroupedTransaction> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey(name: 'first_page_url')
  final String firstPageUrl;
  @override
  final int from;
  @override
  @JsonKey(name: 'last_page')
  final int lastPage;
  @override
  @JsonKey(name: 'last_page_url')
  final String lastPageUrl;
  final List<PageLink> _links;
  @override
  List<PageLink> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @override
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  @override
  final String path;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;
  @override
  final int to;
  @override
  final int total;

  @override
  String toString() {
    return 'GroupedTransactionsData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, links: $links, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedTransactionsDataImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.firstPageUrl, firstPageUrl) ||
                other.firstPageUrl == firstPageUrl) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.lastPageUrl, lastPageUrl) ||
                other.lastPageUrl == lastPageUrl) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.prevPageUrl, prevPageUrl) ||
                other.prevPageUrl == prevPageUrl) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPage,
      const DeepCollectionEquality().hash(_data),
      firstPageUrl,
      from,
      lastPage,
      lastPageUrl,
      const DeepCollectionEquality().hash(_links),
      nextPageUrl,
      path,
      perPage,
      prevPageUrl,
      to,
      total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedTransactionsDataImplCopyWith<_$GroupedTransactionsDataImpl>
      get copyWith => __$$GroupedTransactionsDataImplCopyWithImpl<
          _$GroupedTransactionsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupedTransactionsDataImplToJson(
      this,
    );
  }
}

abstract class _GroupedTransactionsData implements GroupedTransactionsData {
  const factory _GroupedTransactionsData(
      {@JsonKey(name: 'current_page') required final int currentPage,
      required final List<GroupedTransaction> data,
      @JsonKey(name: 'first_page_url') required final String firstPageUrl,
      required final int from,
      @JsonKey(name: 'last_page') required final int lastPage,
      @JsonKey(name: 'last_page_url') required final String lastPageUrl,
      required final List<PageLink> links,
      @JsonKey(name: 'next_page_url') final String? nextPageUrl,
      required final String path,
      @JsonKey(name: 'per_page') required final int perPage,
      @JsonKey(name: 'prev_page_url') final String? prevPageUrl,
      required final int to,
      required final int total}) = _$GroupedTransactionsDataImpl;

  factory _GroupedTransactionsData.fromJson(Map<String, dynamic> json) =
      _$GroupedTransactionsDataImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  List<GroupedTransaction> get data;
  @override
  @JsonKey(name: 'first_page_url')
  String get firstPageUrl;
  @override
  int get from;
  @override
  @JsonKey(name: 'last_page')
  int get lastPage;
  @override
  @JsonKey(name: 'last_page_url')
  String get lastPageUrl;
  @override
  List<PageLink> get links;
  @override
  @JsonKey(name: 'next_page_url')
  String? get nextPageUrl;
  @override
  String get path;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'prev_page_url')
  String? get prevPageUrl;
  @override
  int get to;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$GroupedTransactionsDataImplCopyWith<_$GroupedTransactionsDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GroupedTransaction _$GroupedTransactionFromJson(Map<String, dynamic> json) {
  return _GroupedTransaction.fromJson(json);
}

/// @nodoc
mixin _$GroupedTransaction {
  String get date => throw _privateConstructorUsedError;
  List<Transaction> get transactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupedTransactionCopyWith<GroupedTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupedTransactionCopyWith<$Res> {
  factory $GroupedTransactionCopyWith(
          GroupedTransaction value, $Res Function(GroupedTransaction) then) =
      _$GroupedTransactionCopyWithImpl<$Res, GroupedTransaction>;
  @useResult
  $Res call({String date, List<Transaction> transactions});
}

/// @nodoc
class _$GroupedTransactionCopyWithImpl<$Res, $Val extends GroupedTransaction>
    implements $GroupedTransactionCopyWith<$Res> {
  _$GroupedTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupedTransactionImplCopyWith<$Res>
    implements $GroupedTransactionCopyWith<$Res> {
  factory _$$GroupedTransactionImplCopyWith(_$GroupedTransactionImpl value,
          $Res Function(_$GroupedTransactionImpl) then) =
      __$$GroupedTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, List<Transaction> transactions});
}

/// @nodoc
class __$$GroupedTransactionImplCopyWithImpl<$Res>
    extends _$GroupedTransactionCopyWithImpl<$Res, _$GroupedTransactionImpl>
    implements _$$GroupedTransactionImplCopyWith<$Res> {
  __$$GroupedTransactionImplCopyWithImpl(_$GroupedTransactionImpl _value,
      $Res Function(_$GroupedTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactions = null,
  }) {
    return _then(_$GroupedTransactionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupedTransactionImpl implements _GroupedTransaction {
  const _$GroupedTransactionImpl(
      {required this.date, required final List<Transaction> transactions})
      : _transactions = transactions;

  factory _$GroupedTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupedTransactionImplFromJson(json);

  @override
  final String date;
  final List<Transaction> _transactions;
  @override
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'GroupedTransaction(date: $date, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupedTransactionImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_transactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupedTransactionImplCopyWith<_$GroupedTransactionImpl> get copyWith =>
      __$$GroupedTransactionImplCopyWithImpl<_$GroupedTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupedTransactionImplToJson(
      this,
    );
  }
}

abstract class _GroupedTransaction implements GroupedTransaction {
  const factory _GroupedTransaction(
          {required final String date,
          required final List<Transaction> transactions}) =
      _$GroupedTransactionImpl;

  factory _GroupedTransaction.fromJson(Map<String, dynamic> json) =
      _$GroupedTransactionImpl.fromJson;

  @override
  String get date;
  @override
  List<Transaction> get transactions;
  @override
  @JsonKey(ignore: true)
  _$$GroupedTransactionImplCopyWith<_$GroupedTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PageLink _$PageLinkFromJson(Map<String, dynamic> json) {
  return _PageLink.fromJson(json);
}

/// @nodoc
mixin _$PageLink {
  String? get url => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageLinkCopyWith<PageLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageLinkCopyWith<$Res> {
  factory $PageLinkCopyWith(PageLink value, $Res Function(PageLink) then) =
      _$PageLinkCopyWithImpl<$Res, PageLink>;
  @useResult
  $Res call({String? url, String label, bool active});
}

/// @nodoc
class _$PageLinkCopyWithImpl<$Res, $Val extends PageLink>
    implements $PageLinkCopyWith<$Res> {
  _$PageLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? label = null,
    Object? active = null,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageLinkImplCopyWith<$Res>
    implements $PageLinkCopyWith<$Res> {
  factory _$$PageLinkImplCopyWith(
          _$PageLinkImpl value, $Res Function(_$PageLinkImpl) then) =
      __$$PageLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String label, bool active});
}

/// @nodoc
class __$$PageLinkImplCopyWithImpl<$Res>
    extends _$PageLinkCopyWithImpl<$Res, _$PageLinkImpl>
    implements _$$PageLinkImplCopyWith<$Res> {
  __$$PageLinkImplCopyWithImpl(
      _$PageLinkImpl _value, $Res Function(_$PageLinkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? label = null,
    Object? active = null,
  }) {
    return _then(_$PageLinkImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageLinkImpl implements _PageLink {
  const _$PageLinkImpl({this.url, required this.label, required this.active});

  factory _$PageLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageLinkImplFromJson(json);

  @override
  final String? url;
  @override
  final String label;
  @override
  final bool active;

  @override
  String toString() {
    return 'PageLink(url: $url, label: $label, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageLinkImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url, label, active);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageLinkImplCopyWith<_$PageLinkImpl> get copyWith =>
      __$$PageLinkImplCopyWithImpl<_$PageLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageLinkImplToJson(
      this,
    );
  }
}

abstract class _PageLink implements PageLink {
  const factory _PageLink(
      {final String? url,
      required final String label,
      required final bool active}) = _$PageLinkImpl;

  factory _PageLink.fromJson(Map<String, dynamic> json) =
      _$PageLinkImpl.fromJson;

  @override
  String? get url;
  @override
  String get label;
  @override
  bool get active;
  @override
  @JsonKey(ignore: true)
  _$$PageLinkImplCopyWith<_$PageLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
