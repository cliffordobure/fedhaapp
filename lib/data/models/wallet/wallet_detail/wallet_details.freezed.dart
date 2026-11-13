// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletDetail _$WalletDetailFromJson(Map<String, dynamic> json) {
  return _WalletDetail.fromJson(json);
}

/// @nodoc
mixin _$WalletDetail {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: "user_id")
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: "account_id")
  dynamic get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: "institution_name")
  String get institutionName => throw _privateConstructorUsedError;
  @JsonKey(name: "bank_code")
  String? get bankCode => throw _privateConstructorUsedError;
  @JsonKey(name: "account_name")
  String? get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: "account_number")
  String? get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: "account_type")
  String? get accountType => throw _privateConstructorUsedError;
  int get balance =>
      throw _privateConstructorUsedError; // Changed from String? to int
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: "bvn_last_4")
  String? get bvnLast4 => throw _privateConstructorUsedError;
  @JsonKey(name: "bank_id")
  int get bankId => throw _privateConstructorUsedError;
  @JsonKey(name: "created_at")
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "updated_at")
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletDetailCopyWith<WalletDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletDetailCopyWith<$Res> {
  factory $WalletDetailCopyWith(
          WalletDetail value, $Res Function(WalletDetail) then) =
      _$WalletDetailCopyWithImpl<$Res, WalletDetail>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "user_id") int userId,
      @JsonKey(name: "account_id") dynamic accountId,
      @JsonKey(name: "institution_name") String institutionName,
      @JsonKey(name: "bank_code") String? bankCode,
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: "account_number") String? accountNumber,
      @JsonKey(name: "account_type") String? accountType,
      int balance,
      String? currency,
      @JsonKey(name: "bvn_last_4") String? bvnLast4,
      @JsonKey(name: "bank_id") int bankId,
      @JsonKey(name: "created_at") String createdAt,
      @JsonKey(name: "updated_at") String updatedAt});
}

/// @nodoc
class _$WalletDetailCopyWithImpl<$Res, $Val extends WalletDetail>
    implements $WalletDetailCopyWith<$Res> {
  _$WalletDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? accountId = freezed,
    Object? institutionName = null,
    Object? bankCode = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? balance = null,
    Object? currency = freezed,
    Object? bvnLast4 = freezed,
    Object? bankId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
      bankCode: freezed == bankCode
          ? _value.bankCode
          : bankCode // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bvnLast4: freezed == bvnLast4
          ? _value.bvnLast4
          : bvnLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletDetailImplCopyWith<$Res>
    implements $WalletDetailCopyWith<$Res> {
  factory _$$WalletDetailImplCopyWith(
          _$WalletDetailImpl value, $Res Function(_$WalletDetailImpl) then) =
      __$$WalletDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "user_id") int userId,
      @JsonKey(name: "account_id") dynamic accountId,
      @JsonKey(name: "institution_name") String institutionName,
      @JsonKey(name: "bank_code") String? bankCode,
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: "account_number") String? accountNumber,
      @JsonKey(name: "account_type") String? accountType,
      int balance,
      String? currency,
      @JsonKey(name: "bvn_last_4") String? bvnLast4,
      @JsonKey(name: "bank_id") int bankId,
      @JsonKey(name: "created_at") String createdAt,
      @JsonKey(name: "updated_at") String updatedAt});
}

/// @nodoc
class __$$WalletDetailImplCopyWithImpl<$Res>
    extends _$WalletDetailCopyWithImpl<$Res, _$WalletDetailImpl>
    implements _$$WalletDetailImplCopyWith<$Res> {
  __$$WalletDetailImplCopyWithImpl(
      _$WalletDetailImpl _value, $Res Function(_$WalletDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? accountId = freezed,
    Object? institutionName = null,
    Object? bankCode = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? balance = null,
    Object? currency = freezed,
    Object? bvnLast4 = freezed,
    Object? bankId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WalletDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
      bankCode: freezed == bankCode
          ? _value.bankCode
          : bankCode // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bvnLast4: freezed == bvnLast4
          ? _value.bvnLast4
          : bvnLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletDetailImpl implements _WalletDetail {
  const _$WalletDetailImpl(
      {required this.id,
      @JsonKey(name: "user_id") required this.userId,
      @JsonKey(name: "account_id") this.accountId,
      @JsonKey(name: "institution_name") required this.institutionName,
      @JsonKey(name: "bank_code") this.bankCode,
      @JsonKey(name: "account_name") this.accountName,
      @JsonKey(name: "account_number") this.accountNumber,
      @JsonKey(name: "account_type") this.accountType,
      required this.balance,
      this.currency,
      @JsonKey(name: "bvn_last_4") this.bvnLast4,
      @JsonKey(name: "bank_id") required this.bankId,
      @JsonKey(name: "created_at") required this.createdAt,
      @JsonKey(name: "updated_at") required this.updatedAt});

  factory _$WalletDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletDetailImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: "user_id")
  final int userId;
  @override
  @JsonKey(name: "account_id")
  final dynamic accountId;
  @override
  @JsonKey(name: "institution_name")
  final String institutionName;
  @override
  @JsonKey(name: "bank_code")
  final String? bankCode;
  @override
  @JsonKey(name: "account_name")
  final String? accountName;
  @override
  @JsonKey(name: "account_number")
  final String? accountNumber;
  @override
  @JsonKey(name: "account_type")
  final String? accountType;
  @override
  final int balance;
// Changed from String? to int
  @override
  final String? currency;
  @override
  @JsonKey(name: "bvn_last_4")
  final String? bvnLast4;
  @override
  @JsonKey(name: "bank_id")
  final int bankId;
  @override
  @JsonKey(name: "created_at")
  final String createdAt;
  @override
  @JsonKey(name: "updated_at")
  final String updatedAt;

  @override
  String toString() {
    return 'WalletDetail(id: $id, userId: $userId, accountId: $accountId, institutionName: $institutionName, bankCode: $bankCode, accountName: $accountName, accountNumber: $accountNumber, accountType: $accountType, balance: $balance, currency: $currency, bvnLast4: $bvnLast4, bankId: $bankId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other.accountId, accountId) &&
            (identical(other.institutionName, institutionName) ||
                other.institutionName == institutionName) &&
            (identical(other.bankCode, bankCode) ||
                other.bankCode == bankCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bvnLast4, bvnLast4) ||
                other.bvnLast4 == bvnLast4) &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
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
      userId,
      const DeepCollectionEquality().hash(accountId),
      institutionName,
      bankCode,
      accountName,
      accountNumber,
      accountType,
      balance,
      currency,
      bvnLast4,
      bankId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletDetailImplCopyWith<_$WalletDetailImpl> get copyWith =>
      __$$WalletDetailImplCopyWithImpl<_$WalletDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletDetailImplToJson(
      this,
    );
  }
}

abstract class _WalletDetail implements WalletDetail {
  const factory _WalletDetail(
      {required final int id,
      @JsonKey(name: "user_id") required final int userId,
      @JsonKey(name: "account_id") final dynamic accountId,
      @JsonKey(name: "institution_name") required final String institutionName,
      @JsonKey(name: "bank_code") final String? bankCode,
      @JsonKey(name: "account_name") final String? accountName,
      @JsonKey(name: "account_number") final String? accountNumber,
      @JsonKey(name: "account_type") final String? accountType,
      required final int balance,
      final String? currency,
      @JsonKey(name: "bvn_last_4") final String? bvnLast4,
      @JsonKey(name: "bank_id") required final int bankId,
      @JsonKey(name: "created_at") required final String createdAt,
      @JsonKey(name: "updated_at")
      required final String updatedAt}) = _$WalletDetailImpl;

  factory _WalletDetail.fromJson(Map<String, dynamic> json) =
      _$WalletDetailImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: "user_id")
  int get userId;
  @override
  @JsonKey(name: "account_id")
  dynamic get accountId;
  @override
  @JsonKey(name: "institution_name")
  String get institutionName;
  @override
  @JsonKey(name: "bank_code")
  String? get bankCode;
  @override
  @JsonKey(name: "account_name")
  String? get accountName;
  @override
  @JsonKey(name: "account_number")
  String? get accountNumber;
  @override
  @JsonKey(name: "account_type")
  String? get accountType;
  @override
  int get balance;
  @override // Changed from String? to int
  String? get currency;
  @override
  @JsonKey(name: "bvn_last_4")
  String? get bvnLast4;
  @override
  @JsonKey(name: "bank_id")
  int get bankId;
  @override
  @JsonKey(name: "created_at")
  String get createdAt;
  @override
  @JsonKey(name: "updated_at")
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WalletDetailImplCopyWith<_$WalletDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationLink _$PaginationLinkFromJson(Map<String, dynamic> json) {
  return _PaginationLink.fromJson(json);
}

/// @nodoc
mixin _$PaginationLink {
  String? get url => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationLinkCopyWith<PaginationLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationLinkCopyWith<$Res> {
  factory $PaginationLinkCopyWith(
          PaginationLink value, $Res Function(PaginationLink) then) =
      _$PaginationLinkCopyWithImpl<$Res, PaginationLink>;
  @useResult
  $Res call({String? url, String label, bool active});
}

/// @nodoc
class _$PaginationLinkCopyWithImpl<$Res, $Val extends PaginationLink>
    implements $PaginationLinkCopyWith<$Res> {
  _$PaginationLinkCopyWithImpl(this._value, this._then);

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
abstract class _$$PaginationLinkImplCopyWith<$Res>
    implements $PaginationLinkCopyWith<$Res> {
  factory _$$PaginationLinkImplCopyWith(_$PaginationLinkImpl value,
          $Res Function(_$PaginationLinkImpl) then) =
      __$$PaginationLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String label, bool active});
}

/// @nodoc
class __$$PaginationLinkImplCopyWithImpl<$Res>
    extends _$PaginationLinkCopyWithImpl<$Res, _$PaginationLinkImpl>
    implements _$$PaginationLinkImplCopyWith<$Res> {
  __$$PaginationLinkImplCopyWithImpl(
      _$PaginationLinkImpl _value, $Res Function(_$PaginationLinkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? label = null,
    Object? active = null,
  }) {
    return _then(_$PaginationLinkImpl(
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
class _$PaginationLinkImpl implements _PaginationLink {
  const _$PaginationLinkImpl(
      {this.url, required this.label, required this.active});

  factory _$PaginationLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationLinkImplFromJson(json);

  @override
  final String? url;
  @override
  final String label;
  @override
  final bool active;

  @override
  String toString() {
    return 'PaginationLink(url: $url, label: $label, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationLinkImpl &&
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
  _$$PaginationLinkImplCopyWith<_$PaginationLinkImpl> get copyWith =>
      __$$PaginationLinkImplCopyWithImpl<_$PaginationLinkImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationLinkImplToJson(
      this,
    );
  }
}

abstract class _PaginationLink implements PaginationLink {
  const factory _PaginationLink(
      {final String? url,
      required final String label,
      required final bool active}) = _$PaginationLinkImpl;

  factory _PaginationLink.fromJson(Map<String, dynamic> json) =
      _$PaginationLinkImpl.fromJson;

  @override
  String? get url;
  @override
  String get label;
  @override
  bool get active;
  @override
  @JsonKey(ignore: true)
  _$$PaginationLinkImplCopyWith<_$PaginationLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) {
  return _TransactionDetails.fromJson(json);
}

/// @nodoc
mixin _$TransactionDetails {
  List<Transaction> get data =>
      throw _privateConstructorUsedError; // Added default empty list
  @JsonKey(name: "current_page")
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: "first_page_url")
  String get firstPageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "last_page")
  int get lastPage => throw _privateConstructorUsedError;
  @JsonKey(name: "last_page_url")
  String get lastPageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "next_page_url")
  String? get nextPageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: "prev_page_url")
  String? get prevPageUrl => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError; // Added default value
  List<PaginationLink> get links => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionDetailsCopyWith<TransactionDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDetailsCopyWith<$Res> {
  factory $TransactionDetailsCopyWith(
          TransactionDetails value, $Res Function(TransactionDetails) then) =
      _$TransactionDetailsCopyWithImpl<$Res, TransactionDetails>;
  @useResult
  $Res call(
      {List<Transaction> data,
      @JsonKey(name: "current_page") int currentPage,
      @JsonKey(name: "first_page_url") String firstPageUrl,
      @JsonKey(name: "last_page") int lastPage,
      @JsonKey(name: "last_page_url") String lastPageUrl,
      @JsonKey(name: "next_page_url") String? nextPageUrl,
      @JsonKey(name: "prev_page_url") String? prevPageUrl,
      int total,
      List<PaginationLink> links});
}

/// @nodoc
class _$TransactionDetailsCopyWithImpl<$Res, $Val extends TransactionDetails>
    implements $TransactionDetailsCopyWith<$Res> {
  _$TransactionDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? firstPageUrl = null,
    Object? lastPage = null,
    Object? lastPageUrl = null,
    Object? nextPageUrl = freezed,
    Object? prevPageUrl = freezed,
    Object? total = null,
    Object? links = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      prevPageUrl: freezed == prevPageUrl
          ? _value.prevPageUrl
          : prevPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<PaginationLink>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionDetailsImplCopyWith<$Res>
    implements $TransactionDetailsCopyWith<$Res> {
  factory _$$TransactionDetailsImplCopyWith(_$TransactionDetailsImpl value,
          $Res Function(_$TransactionDetailsImpl) then) =
      __$$TransactionDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Transaction> data,
      @JsonKey(name: "current_page") int currentPage,
      @JsonKey(name: "first_page_url") String firstPageUrl,
      @JsonKey(name: "last_page") int lastPage,
      @JsonKey(name: "last_page_url") String lastPageUrl,
      @JsonKey(name: "next_page_url") String? nextPageUrl,
      @JsonKey(name: "prev_page_url") String? prevPageUrl,
      int total,
      List<PaginationLink> links});
}

/// @nodoc
class __$$TransactionDetailsImplCopyWithImpl<$Res>
    extends _$TransactionDetailsCopyWithImpl<$Res, _$TransactionDetailsImpl>
    implements _$$TransactionDetailsImplCopyWith<$Res> {
  __$$TransactionDetailsImplCopyWithImpl(_$TransactionDetailsImpl _value,
      $Res Function(_$TransactionDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? currentPage = null,
    Object? firstPageUrl = null,
    Object? lastPage = null,
    Object? lastPageUrl = null,
    Object? nextPageUrl = freezed,
    Object? prevPageUrl = freezed,
    Object? total = null,
    Object? links = null,
  }) {
    return _then(_$TransactionDetailsImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      prevPageUrl: freezed == prevPageUrl
          ? _value.prevPageUrl
          : prevPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<PaginationLink>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionDetailsImpl implements _TransactionDetails {
  const _$TransactionDetailsImpl(
      {final List<Transaction> data = const [],
      @JsonKey(name: "current_page") required this.currentPage,
      @JsonKey(name: "first_page_url") required this.firstPageUrl,
      @JsonKey(name: "last_page") required this.lastPage,
      @JsonKey(name: "last_page_url") required this.lastPageUrl,
      @JsonKey(name: "next_page_url") this.nextPageUrl,
      @JsonKey(name: "prev_page_url") this.prevPageUrl,
      this.total = 0,
      required final List<PaginationLink> links})
      : _data = data,
        _links = links;

  factory _$TransactionDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionDetailsImplFromJson(json);

  final List<Transaction> _data;
  @override
  @JsonKey()
  List<Transaction> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

// Added default empty list
  @override
  @JsonKey(name: "current_page")
  final int currentPage;
  @override
  @JsonKey(name: "first_page_url")
  final String firstPageUrl;
  @override
  @JsonKey(name: "last_page")
  final int lastPage;
  @override
  @JsonKey(name: "last_page_url")
  final String lastPageUrl;
  @override
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;
  @override
  @JsonKey(name: "prev_page_url")
  final String? prevPageUrl;
  @override
  @JsonKey()
  final int total;
// Added default value
  final List<PaginationLink> _links;
// Added default value
  @override
  List<PaginationLink> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @override
  String toString() {
    return 'TransactionDetails(data: $data, currentPage: $currentPage, firstPageUrl: $firstPageUrl, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, prevPageUrl: $prevPageUrl, total: $total, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDetailsImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.firstPageUrl, firstPageUrl) ||
                other.firstPageUrl == firstPageUrl) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.lastPageUrl, lastPageUrl) ||
                other.lastPageUrl == lastPageUrl) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.prevPageUrl, prevPageUrl) ||
                other.prevPageUrl == prevPageUrl) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      currentPage,
      firstPageUrl,
      lastPage,
      lastPageUrl,
      nextPageUrl,
      prevPageUrl,
      total,
      const DeepCollectionEquality().hash(_links));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDetailsImplCopyWith<_$TransactionDetailsImpl> get copyWith =>
      __$$TransactionDetailsImplCopyWithImpl<_$TransactionDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionDetailsImplToJson(
      this,
    );
  }
}

abstract class _TransactionDetails implements TransactionDetails {
  const factory _TransactionDetails(
      {final List<Transaction> data,
      @JsonKey(name: "current_page") required final int currentPage,
      @JsonKey(name: "first_page_url") required final String firstPageUrl,
      @JsonKey(name: "last_page") required final int lastPage,
      @JsonKey(name: "last_page_url") required final String lastPageUrl,
      @JsonKey(name: "next_page_url") final String? nextPageUrl,
      @JsonKey(name: "prev_page_url") final String? prevPageUrl,
      final int total,
      required final List<PaginationLink> links}) = _$TransactionDetailsImpl;

  factory _TransactionDetails.fromJson(Map<String, dynamic> json) =
      _$TransactionDetailsImpl.fromJson;

  @override
  List<Transaction> get data;
  @override // Added default empty list
  @JsonKey(name: "current_page")
  int get currentPage;
  @override
  @JsonKey(name: "first_page_url")
  String get firstPageUrl;
  @override
  @JsonKey(name: "last_page")
  int get lastPage;
  @override
  @JsonKey(name: "last_page_url")
  String get lastPageUrl;
  @override
  @JsonKey(name: "next_page_url")
  String? get nextPageUrl;
  @override
  @JsonKey(name: "prev_page_url")
  String? get prevPageUrl;
  @override
  int get total;
  @override // Added default value
  List<PaginationLink> get links;
  @override
  @JsonKey(ignore: true)
  _$$TransactionDetailsImplCopyWith<_$TransactionDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WalletDetailData _$WalletDetailDataFromJson(Map<String, dynamic> json) {
  return _WalletDetailData.fromJson(json);
}

/// @nodoc
mixin _$WalletDetailData {
  @JsonKey(name: "wallet_details")
  WalletDetail get walletDetails => throw _privateConstructorUsedError;
  TransactionDetails get transactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletDetailDataCopyWith<WalletDetailData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletDetailDataCopyWith<$Res> {
  factory $WalletDetailDataCopyWith(
          WalletDetailData value, $Res Function(WalletDetailData) then) =
      _$WalletDetailDataCopyWithImpl<$Res, WalletDetailData>;
  @useResult
  $Res call(
      {@JsonKey(name: "wallet_details") WalletDetail walletDetails,
      TransactionDetails transactions});

  $WalletDetailCopyWith<$Res> get walletDetails;
  $TransactionDetailsCopyWith<$Res> get transactions;
}

/// @nodoc
class _$WalletDetailDataCopyWithImpl<$Res, $Val extends WalletDetailData>
    implements $WalletDetailDataCopyWith<$Res> {
  _$WalletDetailDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletDetails = null,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      walletDetails: null == walletDetails
          ? _value.walletDetails
          : walletDetails // ignore: cast_nullable_to_non_nullable
              as WalletDetail,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as TransactionDetails,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WalletDetailCopyWith<$Res> get walletDetails {
    return $WalletDetailCopyWith<$Res>(_value.walletDetails, (value) {
      return _then(_value.copyWith(walletDetails: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TransactionDetailsCopyWith<$Res> get transactions {
    return $TransactionDetailsCopyWith<$Res>(_value.transactions, (value) {
      return _then(_value.copyWith(transactions: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletDetailDataImplCopyWith<$Res>
    implements $WalletDetailDataCopyWith<$Res> {
  factory _$$WalletDetailDataImplCopyWith(_$WalletDetailDataImpl value,
          $Res Function(_$WalletDetailDataImpl) then) =
      __$$WalletDetailDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "wallet_details") WalletDetail walletDetails,
      TransactionDetails transactions});

  @override
  $WalletDetailCopyWith<$Res> get walletDetails;
  @override
  $TransactionDetailsCopyWith<$Res> get transactions;
}

/// @nodoc
class __$$WalletDetailDataImplCopyWithImpl<$Res>
    extends _$WalletDetailDataCopyWithImpl<$Res, _$WalletDetailDataImpl>
    implements _$$WalletDetailDataImplCopyWith<$Res> {
  __$$WalletDetailDataImplCopyWithImpl(_$WalletDetailDataImpl _value,
      $Res Function(_$WalletDetailDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walletDetails = null,
    Object? transactions = null,
  }) {
    return _then(_$WalletDetailDataImpl(
      walletDetails: null == walletDetails
          ? _value.walletDetails
          : walletDetails // ignore: cast_nullable_to_non_nullable
              as WalletDetail,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as TransactionDetails,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletDetailDataImpl implements _WalletDetailData {
  const _$WalletDetailDataImpl(
      {@JsonKey(name: "wallet_details") required this.walletDetails,
      required this.transactions});

  factory _$WalletDetailDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletDetailDataImplFromJson(json);

  @override
  @JsonKey(name: "wallet_details")
  final WalletDetail walletDetails;
  @override
  final TransactionDetails transactions;

  @override
  String toString() {
    return 'WalletDetailData(walletDetails: $walletDetails, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletDetailDataImpl &&
            (identical(other.walletDetails, walletDetails) ||
                other.walletDetails == walletDetails) &&
            (identical(other.transactions, transactions) ||
                other.transactions == transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, walletDetails, transactions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletDetailDataImplCopyWith<_$WalletDetailDataImpl> get copyWith =>
      __$$WalletDetailDataImplCopyWithImpl<_$WalletDetailDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletDetailDataImplToJson(
      this,
    );
  }
}

abstract class _WalletDetailData implements WalletDetailData {
  const factory _WalletDetailData(
      {@JsonKey(name: "wallet_details")
      required final WalletDetail walletDetails,
      required final TransactionDetails transactions}) = _$WalletDetailDataImpl;

  factory _WalletDetailData.fromJson(Map<String, dynamic> json) =
      _$WalletDetailDataImpl.fromJson;

  @override
  @JsonKey(name: "wallet_details")
  WalletDetail get walletDetails;
  @override
  TransactionDetails get transactions;
  @override
  @JsonKey(ignore: true)
  _$$WalletDetailDataImplCopyWith<_$WalletDetailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
