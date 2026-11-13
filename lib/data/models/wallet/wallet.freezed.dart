// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Wallet _$WalletFromJson(Map<String, dynamic> json) {
  return _Wallet.fromJson(json);
}

/// @nodoc
mixin _$Wallet {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: "account_id")
  String? get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: "institution_name")
  String? get institutionName => throw _privateConstructorUsedError;
  @JsonKey(name: "account_name")
  String? get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String? get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: "account_type")
  String? get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance')
  String? get balance => throw _privateConstructorUsedError;
  @JsonKey(name: "currency")
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: "bank_id")
  int get bankId => throw _privateConstructorUsedError;
  @JsonKey(name: "img_url")
  String get img => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortname => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res, Wallet>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "account_id") String? accountId,
      @JsonKey(name: "institution_name") String? institutionName,
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: "account_type") String? accountType,
      @JsonKey(name: 'balance') String? balance,
      @JsonKey(name: "currency") String? currency,
      @JsonKey(name: "bank_id") int bankId,
      @JsonKey(name: "img_url") String img,
      String name,
      String shortname});
}

/// @nodoc
class _$WalletCopyWithImpl<$Res, $Val extends Wallet>
    implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = freezed,
    Object? institutionName = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? bankId = null,
    Object? img = null,
    Object? name = null,
    Object? shortname = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      institutionName: freezed == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
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
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortname: null == shortname
          ? _value.shortname
          : shortname // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletImplCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$$WalletImplCopyWith(
          _$WalletImpl value, $Res Function(_$WalletImpl) then) =
      __$$WalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "account_id") String? accountId,
      @JsonKey(name: "institution_name") String? institutionName,
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: "account_type") String? accountType,
      @JsonKey(name: 'balance') String? balance,
      @JsonKey(name: "currency") String? currency,
      @JsonKey(name: "bank_id") int bankId,
      @JsonKey(name: "img_url") String img,
      String name,
      String shortname});
}

/// @nodoc
class __$$WalletImplCopyWithImpl<$Res>
    extends _$WalletCopyWithImpl<$Res, _$WalletImpl>
    implements _$$WalletImplCopyWith<$Res> {
  __$$WalletImplCopyWithImpl(
      _$WalletImpl _value, $Res Function(_$WalletImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accountId = freezed,
    Object? institutionName = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? bankId = null,
    Object? img = null,
    Object? name = null,
    Object? shortname = null,
  }) {
    return _then(_$WalletImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      institutionName: freezed == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
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
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bankId: null == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortname: null == shortname
          ? _value.shortname
          : shortname // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletImpl implements _Wallet {
  const _$WalletImpl(
      {required this.id,
      @JsonKey(name: "account_id") this.accountId = "",
      @JsonKey(name: "institution_name") this.institutionName,
      @JsonKey(name: "account_name") this.accountName,
      @JsonKey(name: 'account_number') this.accountNumber,
      @JsonKey(name: "account_type") this.accountType,
      @JsonKey(name: 'balance') this.balance,
      @JsonKey(name: "currency") this.currency,
      @JsonKey(name: "bank_id") required this.bankId,
      @JsonKey(name: "img_url") this.img = "",
      required this.name,
      required this.shortname});

  factory _$WalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: "account_id")
  final String? accountId;
  @override
  @JsonKey(name: "institution_name")
  final String? institutionName;
  @override
  @JsonKey(name: "account_name")
  final String? accountName;
  @override
  @JsonKey(name: 'account_number')
  final String? accountNumber;
  @override
  @JsonKey(name: "account_type")
  final String? accountType;
  @override
  @JsonKey(name: 'balance')
  final String? balance;
  @override
  @JsonKey(name: "currency")
  final String? currency;
  @override
  @JsonKey(name: "bank_id")
  final int bankId;
  @override
  @JsonKey(name: "img_url")
  final String img;
  @override
  final String name;
  @override
  final String shortname;

  @override
  String toString() {
    return 'Wallet(id: $id, accountId: $accountId, institutionName: $institutionName, accountName: $accountName, accountNumber: $accountNumber, accountType: $accountType, balance: $balance, currency: $currency, bankId: $bankId, img: $img, name: $name, shortname: $shortname)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.institutionName, institutionName) ||
                other.institutionName == institutionName) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortname, shortname) ||
                other.shortname == shortname));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountId,
      institutionName,
      accountName,
      accountNumber,
      accountType,
      balance,
      currency,
      bankId,
      img,
      name,
      shortname);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      __$$WalletImplCopyWithImpl<_$WalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletImplToJson(
      this,
    );
  }
}

abstract class _Wallet implements Wallet {
  const factory _Wallet(
      {required final int id,
      @JsonKey(name: "account_id") final String? accountId,
      @JsonKey(name: "institution_name") final String? institutionName,
      @JsonKey(name: "account_name") final String? accountName,
      @JsonKey(name: 'account_number') final String? accountNumber,
      @JsonKey(name: "account_type") final String? accountType,
      @JsonKey(name: 'balance') final String? balance,
      @JsonKey(name: "currency") final String? currency,
      @JsonKey(name: "bank_id") required final int bankId,
      @JsonKey(name: "img_url") final String img,
      required final String name,
      required final String shortname}) = _$WalletImpl;

  factory _Wallet.fromJson(Map<String, dynamic> json) = _$WalletImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: "account_id")
  String? get accountId;
  @override
  @JsonKey(name: "institution_name")
  String? get institutionName;
  @override
  @JsonKey(name: "account_name")
  String? get accountName;
  @override
  @JsonKey(name: 'account_number')
  String? get accountNumber;
  @override
  @JsonKey(name: "account_type")
  String? get accountType;
  @override
  @JsonKey(name: 'balance')
  String? get balance;
  @override
  @JsonKey(name: "currency")
  String? get currency;
  @override
  @JsonKey(name: "bank_id")
  int get bankId;
  @override
  @JsonKey(name: "img_url")
  String get img;
  @override
  String get name;
  @override
  String get shortname;
  @override
  @JsonKey(ignore: true)
  _$$WalletImplCopyWith<_$WalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WalletType _$WalletTypeFromJson(Map<String, dynamic> json) {
  return _WalletType.fromJson(json);
}

/// @nodoc
mixin _$WalletType {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletTypeCopyWith<WalletType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletTypeCopyWith<$Res> {
  factory $WalletTypeCopyWith(
          WalletType value, $Res Function(WalletType) then) =
      _$WalletTypeCopyWithImpl<$Res, WalletType>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$WalletTypeCopyWithImpl<$Res, $Val extends WalletType>
    implements $WalletTypeCopyWith<$Res> {
  _$WalletTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletTypeImplCopyWith<$Res>
    implements $WalletTypeCopyWith<$Res> {
  factory _$$WalletTypeImplCopyWith(
          _$WalletTypeImpl value, $Res Function(_$WalletTypeImpl) then) =
      __$$WalletTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$WalletTypeImplCopyWithImpl<$Res>
    extends _$WalletTypeCopyWithImpl<$Res, _$WalletTypeImpl>
    implements _$$WalletTypeImplCopyWith<$Res> {
  __$$WalletTypeImplCopyWithImpl(
      _$WalletTypeImpl _value, $Res Function(_$WalletTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$WalletTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletTypeImpl implements _WalletType {
  const _$WalletTypeImpl({required this.id, required this.name});

  factory _$WalletTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletTypeImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'WalletType(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletTypeImplCopyWith<_$WalletTypeImpl> get copyWith =>
      __$$WalletTypeImplCopyWithImpl<_$WalletTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletTypeImplToJson(
      this,
    );
  }
}

abstract class _WalletType implements WalletType {
  const factory _WalletType(
      {required final int id, required final String name}) = _$WalletTypeImpl;

  factory _WalletType.fromJson(Map<String, dynamic> json) =
      _$WalletTypeImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$WalletTypeImplCopyWith<_$WalletTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return _Currency.fromJson(json);
}

/// @nodoc
mixin _$Currency {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CurrencyCopyWith<Currency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyCopyWith<$Res> {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) then) =
      _$CurrencyCopyWithImpl<$Res, Currency>;
  @useResult
  $Res call({int id, String name, String symbol});
}

/// @nodoc
class _$CurrencyCopyWithImpl<$Res, $Val extends Currency>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
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
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyImplCopyWith<$Res>
    implements $CurrencyCopyWith<$Res> {
  factory _$$CurrencyImplCopyWith(
          _$CurrencyImpl value, $Res Function(_$CurrencyImpl) then) =
      __$$CurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String symbol});
}

/// @nodoc
class __$$CurrencyImplCopyWithImpl<$Res>
    extends _$CurrencyCopyWithImpl<$Res, _$CurrencyImpl>
    implements _$$CurrencyImplCopyWith<$Res> {
  __$$CurrencyImplCopyWithImpl(
      _$CurrencyImpl _value, $Res Function(_$CurrencyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? symbol = null,
  }) {
    return _then(_$CurrencyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyImpl implements _Currency {
  const _$CurrencyImpl(
      {required this.id, required this.name, required this.symbol});

  factory _$CurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String symbol;

  @override
  String toString() {
    return 'Currency(id: $id, name: $name, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, symbol);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyImplToJson(
      this,
    );
  }
}

abstract class _Currency implements Currency {
  const factory _Currency(
      {required final int id,
      required final String name,
      required final String symbol}) = _$CurrencyImpl;

  factory _Currency.fromJson(Map<String, dynamic> json) =
      _$CurrencyImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get symbol;
  @override
  @JsonKey(ignore: true)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
