// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialWallet _$FinancialWalletFromJson(Map<String, dynamic> json) {
  return _FinancialWallet.fromJson(json);
}

/// @nodoc
mixin _$FinancialWallet {
  @JsonKey(name: 'user_id')
  num get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_id')
  String? get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'institution_name')
  String? get institutionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String? get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String? get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  String? get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: "bank_id")
  int? get bankId => throw _privateConstructorUsedError;
  String? get balance => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  FinancialAnalyticsData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialWalletCopyWith<FinancialWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialWalletCopyWith<$Res> {
  factory $FinancialWalletCopyWith(
          FinancialWallet value, $Res Function(FinancialWallet) then) =
      _$FinancialWalletCopyWithImpl<$Res, FinancialWallet>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') num userId,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'institution_name') String? institutionName,
      @JsonKey(name: 'account_name') String? accountName,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: 'account_type') String? accountType,
      @JsonKey(name: "bank_id") int? bankId,
      String? balance,
      String? currency,
      FinancialAnalyticsData data});

  $FinancialAnalyticsDataCopyWith<$Res> get data;
}

/// @nodoc
class _$FinancialWalletCopyWithImpl<$Res, $Val extends FinancialWallet>
    implements $FinancialWalletCopyWith<$Res> {
  _$FinancialWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? institutionName = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? bankId = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as num,
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
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FinancialAnalyticsData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialAnalyticsDataCopyWith<$Res> get data {
    return $FinancialAnalyticsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialWalletImplCopyWith<$Res>
    implements $FinancialWalletCopyWith<$Res> {
  factory _$$FinancialWalletImplCopyWith(_$FinancialWalletImpl value,
          $Res Function(_$FinancialWalletImpl) then) =
      __$$FinancialWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') num userId,
      @JsonKey(name: 'account_id') String? accountId,
      @JsonKey(name: 'institution_name') String? institutionName,
      @JsonKey(name: 'account_name') String? accountName,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: 'account_type') String? accountType,
      @JsonKey(name: "bank_id") int? bankId,
      String? balance,
      String? currency,
      FinancialAnalyticsData data});

  @override
  $FinancialAnalyticsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$FinancialWalletImplCopyWithImpl<$Res>
    extends _$FinancialWalletCopyWithImpl<$Res, _$FinancialWalletImpl>
    implements _$$FinancialWalletImplCopyWith<$Res> {
  __$$FinancialWalletImplCopyWithImpl(
      _$FinancialWalletImpl _value, $Res Function(_$FinancialWalletImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? accountId = freezed,
    Object? institutionName = freezed,
    Object? accountName = freezed,
    Object? accountNumber = freezed,
    Object? accountType = freezed,
    Object? bankId = freezed,
    Object? balance = freezed,
    Object? currency = freezed,
    Object? data = null,
  }) {
    return _then(_$FinancialWalletImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as num,
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
      bankId: freezed == bankId
          ? _value.bankId
          : bankId // ignore: cast_nullable_to_non_nullable
              as int?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FinancialAnalyticsData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialWalletImpl implements _FinancialWallet {
  const _$FinancialWalletImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'account_id') this.accountId,
      @JsonKey(name: 'institution_name') this.institutionName,
      @JsonKey(name: 'account_name') this.accountName,
      @JsonKey(name: 'account_number') this.accountNumber,
      @JsonKey(name: 'account_type') this.accountType,
      @JsonKey(name: "bank_id") this.bankId,
      this.balance,
      this.currency,
      required this.data});

  factory _$FinancialWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialWalletImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final num userId;
  @override
  @JsonKey(name: 'account_id')
  final String? accountId;
  @override
  @JsonKey(name: 'institution_name')
  final String? institutionName;
  @override
  @JsonKey(name: 'account_name')
  final String? accountName;
  @override
  @JsonKey(name: 'account_number')
  final String? accountNumber;
  @override
  @JsonKey(name: 'account_type')
  final String? accountType;
  @override
  @JsonKey(name: "bank_id")
  final int? bankId;
  @override
  final String? balance;
  @override
  final String? currency;
  @override
  final FinancialAnalyticsData data;

  @override
  String toString() {
    return 'FinancialWallet(userId: $userId, accountId: $accountId, institutionName: $institutionName, accountName: $accountName, accountNumber: $accountNumber, accountType: $accountType, bankId: $bankId, balance: $balance, currency: $currency, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialWalletImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
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
            (identical(other.bankId, bankId) || other.bankId == bankId) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      accountId,
      institutionName,
      accountName,
      accountNumber,
      accountType,
      bankId,
      balance,
      currency,
      data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialWalletImplCopyWith<_$FinancialWalletImpl> get copyWith =>
      __$$FinancialWalletImplCopyWithImpl<_$FinancialWalletImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialWalletImplToJson(
      this,
    );
  }
}

abstract class _FinancialWallet implements FinancialWallet {
  const factory _FinancialWallet(
      {@JsonKey(name: 'user_id') required final num userId,
      @JsonKey(name: 'account_id') final String? accountId,
      @JsonKey(name: 'institution_name') final String? institutionName,
      @JsonKey(name: 'account_name') final String? accountName,
      @JsonKey(name: 'account_number') final String? accountNumber,
      @JsonKey(name: 'account_type') final String? accountType,
      @JsonKey(name: "bank_id") final int? bankId,
      final String? balance,
      final String? currency,
      required final FinancialAnalyticsData data}) = _$FinancialWalletImpl;

  factory _FinancialWallet.fromJson(Map<String, dynamic> json) =
      _$FinancialWalletImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  num get userId;
  @override
  @JsonKey(name: 'account_id')
  String? get accountId;
  @override
  @JsonKey(name: 'institution_name')
  String? get institutionName;
  @override
  @JsonKey(name: 'account_name')
  String? get accountName;
  @override
  @JsonKey(name: 'account_number')
  String? get accountNumber;
  @override
  @JsonKey(name: 'account_type')
  String? get accountType;
  @override
  @JsonKey(name: "bank_id")
  int? get bankId;
  @override
  String? get balance;
  @override
  String? get currency;
  @override
  FinancialAnalyticsData get data;
  @override
  @JsonKey(ignore: true)
  _$$FinancialWalletImplCopyWith<_$FinancialWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialAnalyticsData _$FinancialAnalyticsDataFromJson(
    Map<String, dynamic> json) {
  return _FinancialAnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$FinancialAnalyticsData {
  @JsonKey(name: 'data')
  Map<String, FinancialTimeSpanData> get data =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialAnalyticsDataCopyWith<FinancialAnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialAnalyticsDataCopyWith<$Res> {
  factory $FinancialAnalyticsDataCopyWith(FinancialAnalyticsData value,
          $Res Function(FinancialAnalyticsData) then) =
      _$FinancialAnalyticsDataCopyWithImpl<$Res, FinancialAnalyticsData>;
  @useResult
  $Res call({@JsonKey(name: 'data') Map<String, FinancialTimeSpanData> data});
}

/// @nodoc
class _$FinancialAnalyticsDataCopyWithImpl<$Res,
        $Val extends FinancialAnalyticsData>
    implements $FinancialAnalyticsDataCopyWith<$Res> {
  _$FinancialAnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, FinancialTimeSpanData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialAnalyticsDataImplCopyWith<$Res>
    implements $FinancialAnalyticsDataCopyWith<$Res> {
  factory _$$FinancialAnalyticsDataImplCopyWith(
          _$FinancialAnalyticsDataImpl value,
          $Res Function(_$FinancialAnalyticsDataImpl) then) =
      __$$FinancialAnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'data') Map<String, FinancialTimeSpanData> data});
}

/// @nodoc
class __$$FinancialAnalyticsDataImplCopyWithImpl<$Res>
    extends _$FinancialAnalyticsDataCopyWithImpl<$Res,
        _$FinancialAnalyticsDataImpl>
    implements _$$FinancialAnalyticsDataImplCopyWith<$Res> {
  __$$FinancialAnalyticsDataImplCopyWithImpl(
      _$FinancialAnalyticsDataImpl _value,
      $Res Function(_$FinancialAnalyticsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$FinancialAnalyticsDataImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, FinancialTimeSpanData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialAnalyticsDataImpl implements _FinancialAnalyticsData {
  const _$FinancialAnalyticsDataImpl(
      {@JsonKey(name: 'data')
      required final Map<String, FinancialTimeSpanData> data})
      : _data = data;

  factory _$FinancialAnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialAnalyticsDataImplFromJson(json);

  final Map<String, FinancialTimeSpanData> _data;
  @override
  @JsonKey(name: 'data')
  Map<String, FinancialTimeSpanData> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'FinancialAnalyticsData(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialAnalyticsDataImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialAnalyticsDataImplCopyWith<_$FinancialAnalyticsDataImpl>
      get copyWith => __$$FinancialAnalyticsDataImplCopyWithImpl<
          _$FinancialAnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialAnalyticsDataImplToJson(
      this,
    );
  }
}

abstract class _FinancialAnalyticsData implements FinancialAnalyticsData {
  const factory _FinancialAnalyticsData(
          {@JsonKey(name: 'data')
          required final Map<String, FinancialTimeSpanData> data}) =
      _$FinancialAnalyticsDataImpl;

  factory _FinancialAnalyticsData.fromJson(Map<String, dynamic> json) =
      _$FinancialAnalyticsDataImpl.fromJson;

  @override
  @JsonKey(name: 'data')
  Map<String, FinancialTimeSpanData> get data;
  @override
  @JsonKey(ignore: true)
  _$$FinancialAnalyticsDataImplCopyWith<_$FinancialAnalyticsDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FinancialTimeSpanData _$FinancialTimeSpanDataFromJson(
    Map<String, dynamic> json) {
  return _FinancialTimeSpanData.fromJson(json);
}

/// @nodoc
mixin _$FinancialTimeSpanData {
  @JsonKey(name: 'totalIncome')
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalExpense')
  double get totalExpense => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialTimeSpanDataCopyWith<FinancialTimeSpanData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialTimeSpanDataCopyWith<$Res> {
  factory $FinancialTimeSpanDataCopyWith(FinancialTimeSpanData value,
          $Res Function(FinancialTimeSpanData) then) =
      _$FinancialTimeSpanDataCopyWithImpl<$Res, FinancialTimeSpanData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'totalIncome') double totalIncome,
      @JsonKey(name: 'totalExpense') double totalExpense});
}

/// @nodoc
class _$FinancialTimeSpanDataCopyWithImpl<$Res,
        $Val extends FinancialTimeSpanData>
    implements $FinancialTimeSpanDataCopyWith<$Res> {
  _$FinancialTimeSpanDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialTimeSpanDataImplCopyWith<$Res>
    implements $FinancialTimeSpanDataCopyWith<$Res> {
  factory _$$FinancialTimeSpanDataImplCopyWith(
          _$FinancialTimeSpanDataImpl value,
          $Res Function(_$FinancialTimeSpanDataImpl) then) =
      __$$FinancialTimeSpanDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'totalIncome') double totalIncome,
      @JsonKey(name: 'totalExpense') double totalExpense});
}

/// @nodoc
class __$$FinancialTimeSpanDataImplCopyWithImpl<$Res>
    extends _$FinancialTimeSpanDataCopyWithImpl<$Res,
        _$FinancialTimeSpanDataImpl>
    implements _$$FinancialTimeSpanDataImplCopyWith<$Res> {
  __$$FinancialTimeSpanDataImplCopyWithImpl(_$FinancialTimeSpanDataImpl _value,
      $Res Function(_$FinancialTimeSpanDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
  }) {
    return _then(_$FinancialTimeSpanDataImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialTimeSpanDataImpl implements _FinancialTimeSpanData {
  const _$FinancialTimeSpanDataImpl(
      {@JsonKey(name: 'totalIncome') this.totalIncome = 0.0,
      @JsonKey(name: 'totalExpense') this.totalExpense = 0.0});

  factory _$FinancialTimeSpanDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialTimeSpanDataImplFromJson(json);

  @override
  @JsonKey(name: 'totalIncome')
  final double totalIncome;
  @override
  @JsonKey(name: 'totalExpense')
  final double totalExpense;

  @override
  String toString() {
    return 'FinancialTimeSpanData(totalIncome: $totalIncome, totalExpense: $totalExpense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialTimeSpanDataImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpense);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialTimeSpanDataImplCopyWith<_$FinancialTimeSpanDataImpl>
      get copyWith => __$$FinancialTimeSpanDataImplCopyWithImpl<
          _$FinancialTimeSpanDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialTimeSpanDataImplToJson(
      this,
    );
  }
}

abstract class _FinancialTimeSpanData implements FinancialTimeSpanData {
  const factory _FinancialTimeSpanData(
          {@JsonKey(name: 'totalIncome') final double totalIncome,
          @JsonKey(name: 'totalExpense') final double totalExpense}) =
      _$FinancialTimeSpanDataImpl;

  factory _FinancialTimeSpanData.fromJson(Map<String, dynamic> json) =
      _$FinancialTimeSpanDataImpl.fromJson;

  @override
  @JsonKey(name: 'totalIncome')
  double get totalIncome;
  @override
  @JsonKey(name: 'totalExpense')
  double get totalExpense;
  @override
  @JsonKey(ignore: true)
  _$$FinancialTimeSpanDataImplCopyWith<_$FinancialTimeSpanDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
