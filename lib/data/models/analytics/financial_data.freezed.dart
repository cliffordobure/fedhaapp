// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinancialData _$FinancialDataFromJson(Map<String, dynamic> json) {
  return _FinancialData.fromJson(json);
}

/// @nodoc
mixin _$FinancialData {
  FinancialInfo get today => throw _privateConstructorUsedError;
  FinancialInfo get weekly => throw _privateConstructorUsedError;
  FinancialInfo get monthly => throw _privateConstructorUsedError;
  FinancialInfo get yearly => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialDataCopyWith<FinancialData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialDataCopyWith<$Res> {
  factory $FinancialDataCopyWith(
          FinancialData value, $Res Function(FinancialData) then) =
      _$FinancialDataCopyWithImpl<$Res, FinancialData>;
  @useResult
  $Res call(
      {FinancialInfo today,
      FinancialInfo weekly,
      FinancialInfo monthly,
      FinancialInfo yearly});

  $FinancialInfoCopyWith<$Res> get today;
  $FinancialInfoCopyWith<$Res> get weekly;
  $FinancialInfoCopyWith<$Res> get monthly;
  $FinancialInfoCopyWith<$Res> get yearly;
}

/// @nodoc
class _$FinancialDataCopyWithImpl<$Res, $Val extends FinancialData>
    implements $FinancialDataCopyWith<$Res> {
  _$FinancialDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? yearly = null,
  }) {
    return _then(_value.copyWith(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      yearly: null == yearly
          ? _value.yearly
          : yearly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialInfoCopyWith<$Res> get today {
    return $FinancialInfoCopyWith<$Res>(_value.today, (value) {
      return _then(_value.copyWith(today: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialInfoCopyWith<$Res> get weekly {
    return $FinancialInfoCopyWith<$Res>(_value.weekly, (value) {
      return _then(_value.copyWith(weekly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialInfoCopyWith<$Res> get monthly {
    return $FinancialInfoCopyWith<$Res>(_value.monthly, (value) {
      return _then(_value.copyWith(monthly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FinancialInfoCopyWith<$Res> get yearly {
    return $FinancialInfoCopyWith<$Res>(_value.yearly, (value) {
      return _then(_value.copyWith(yearly: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialDataImplCopyWith<$Res>
    implements $FinancialDataCopyWith<$Res> {
  factory _$$FinancialDataImplCopyWith(
          _$FinancialDataImpl value, $Res Function(_$FinancialDataImpl) then) =
      __$$FinancialDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FinancialInfo today,
      FinancialInfo weekly,
      FinancialInfo monthly,
      FinancialInfo yearly});

  @override
  $FinancialInfoCopyWith<$Res> get today;
  @override
  $FinancialInfoCopyWith<$Res> get weekly;
  @override
  $FinancialInfoCopyWith<$Res> get monthly;
  @override
  $FinancialInfoCopyWith<$Res> get yearly;
}

/// @nodoc
class __$$FinancialDataImplCopyWithImpl<$Res>
    extends _$FinancialDataCopyWithImpl<$Res, _$FinancialDataImpl>
    implements _$$FinancialDataImplCopyWith<$Res> {
  __$$FinancialDataImplCopyWithImpl(
      _$FinancialDataImpl _value, $Res Function(_$FinancialDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? yearly = null,
  }) {
    return _then(_$FinancialDataImpl(
      today: null == today
          ? _value.today
          : today // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
      yearly: null == yearly
          ? _value.yearly
          : yearly // ignore: cast_nullable_to_non_nullable
              as FinancialInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialDataImpl implements _FinancialData {
  const _$FinancialDataImpl(
      {required this.today,
      required this.weekly,
      required this.monthly,
      required this.yearly});

  factory _$FinancialDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialDataImplFromJson(json);

  @override
  final FinancialInfo today;
  @override
  final FinancialInfo weekly;
  @override
  final FinancialInfo monthly;
  @override
  final FinancialInfo yearly;

  @override
  String toString() {
    return 'FinancialData(today: $today, weekly: $weekly, monthly: $monthly, yearly: $yearly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialDataImpl &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.weekly, weekly) || other.weekly == weekly) &&
            (identical(other.monthly, monthly) || other.monthly == monthly) &&
            (identical(other.yearly, yearly) || other.yearly == yearly));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, today, weekly, monthly, yearly);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialDataImplCopyWith<_$FinancialDataImpl> get copyWith =>
      __$$FinancialDataImplCopyWithImpl<_$FinancialDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialDataImplToJson(
      this,
    );
  }
}

abstract class _FinancialData implements FinancialData {
  const factory _FinancialData(
      {required final FinancialInfo today,
      required final FinancialInfo weekly,
      required final FinancialInfo monthly,
      required final FinancialInfo yearly}) = _$FinancialDataImpl;

  factory _FinancialData.fromJson(Map<String, dynamic> json) =
      _$FinancialDataImpl.fromJson;

  @override
  FinancialInfo get today;
  @override
  FinancialInfo get weekly;
  @override
  FinancialInfo get monthly;
  @override
  FinancialInfo get yearly;
  @override
  @JsonKey(ignore: true)
  _$$FinancialDataImplCopyWith<_$FinancialDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialInfo _$FinancialInfoFromJson(Map<String, dynamic> json) {
  return _FinancialInfo.fromJson(json);
}

/// @nodoc
mixin _$FinancialInfo {
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;
  double get charges => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialInfoCopyWith<FinancialInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialInfoCopyWith<$Res> {
  factory $FinancialInfoCopyWith(
          FinancialInfo value, $Res Function(FinancialInfo) then) =
      _$FinancialInfoCopyWithImpl<$Res, FinancialInfo>;
  @useResult
  $Res call({double income, double expense, double charges, double balance});
}

/// @nodoc
class _$FinancialInfoCopyWithImpl<$Res, $Val extends FinancialInfo>
    implements $FinancialInfoCopyWith<$Res> {
  _$FinancialInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? charges = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      charges: null == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialInfoImplCopyWith<$Res>
    implements $FinancialInfoCopyWith<$Res> {
  factory _$$FinancialInfoImplCopyWith(
          _$FinancialInfoImpl value, $Res Function(_$FinancialInfoImpl) then) =
      __$$FinancialInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double income, double expense, double charges, double balance});
}

/// @nodoc
class __$$FinancialInfoImplCopyWithImpl<$Res>
    extends _$FinancialInfoCopyWithImpl<$Res, _$FinancialInfoImpl>
    implements _$$FinancialInfoImplCopyWith<$Res> {
  __$$FinancialInfoImplCopyWithImpl(
      _$FinancialInfoImpl _value, $Res Function(_$FinancialInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? charges = null,
    Object? balance = null,
  }) {
    return _then(_$FinancialInfoImpl(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      charges: null == charges
          ? _value.charges
          : charges // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialInfoImpl implements _FinancialInfo {
  const _$FinancialInfoImpl(
      {required this.income,
      required this.expense,
      required this.charges,
      required this.balance});

  factory _$FinancialInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialInfoImplFromJson(json);

  @override
  final double income;
  @override
  final double expense;
  @override
  final double charges;
  @override
  final double balance;

  @override
  String toString() {
    return 'FinancialInfo(income: $income, expense: $expense, charges: $charges, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialInfoImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.charges, charges) || other.charges == charges) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, income, expense, charges, balance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialInfoImplCopyWith<_$FinancialInfoImpl> get copyWith =>
      __$$FinancialInfoImplCopyWithImpl<_$FinancialInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialInfoImplToJson(
      this,
    );
  }
}

abstract class _FinancialInfo implements FinancialInfo {
  const factory _FinancialInfo(
      {required final double income,
      required final double expense,
      required final double charges,
      required final double balance}) = _$FinancialInfoImpl;

  factory _FinancialInfo.fromJson(Map<String, dynamic> json) =
      _$FinancialInfoImpl.fromJson;

  @override
  double get income;
  @override
  double get expense;
  @override
  double get charges;
  @override
  double get balance;
  @override
  @JsonKey(ignore: true)
  _$$FinancialInfoImplCopyWith<_$FinancialInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionAnalytics _$TransactionAnalyticsFromJson(Map<String, dynamic> json) {
  return _TransactionAnalytics.fromJson(json);
}

/// @nodoc
mixin _$TransactionAnalytics {
  String get message => throw _privateConstructorUsedError;
  AnalyticsData get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionAnalyticsCopyWith<TransactionAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionAnalyticsCopyWith<$Res> {
  factory $TransactionAnalyticsCopyWith(TransactionAnalytics value,
          $Res Function(TransactionAnalytics) then) =
      _$TransactionAnalyticsCopyWithImpl<$Res, TransactionAnalytics>;
  @useResult
  $Res call({String message, AnalyticsData data});

  $AnalyticsDataCopyWith<$Res> get data;
}

/// @nodoc
class _$TransactionAnalyticsCopyWithImpl<$Res,
        $Val extends TransactionAnalytics>
    implements $TransactionAnalyticsCopyWith<$Res> {
  _$TransactionAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AnalyticsData,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AnalyticsDataCopyWith<$Res> get data {
    return $AnalyticsDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionAnalyticsImplCopyWith<$Res>
    implements $TransactionAnalyticsCopyWith<$Res> {
  factory _$$TransactionAnalyticsImplCopyWith(_$TransactionAnalyticsImpl value,
          $Res Function(_$TransactionAnalyticsImpl) then) =
      __$$TransactionAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, AnalyticsData data});

  @override
  $AnalyticsDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$TransactionAnalyticsImplCopyWithImpl<$Res>
    extends _$TransactionAnalyticsCopyWithImpl<$Res, _$TransactionAnalyticsImpl>
    implements _$$TransactionAnalyticsImplCopyWith<$Res> {
  __$$TransactionAnalyticsImplCopyWithImpl(_$TransactionAnalyticsImpl _value,
      $Res Function(_$TransactionAnalyticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$TransactionAnalyticsImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AnalyticsData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionAnalyticsImpl implements _TransactionAnalytics {
  const _$TransactionAnalyticsImpl({required this.message, required this.data});

  factory _$TransactionAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionAnalyticsImplFromJson(json);

  @override
  final String message;
  @override
  final AnalyticsData data;

  @override
  String toString() {
    return 'TransactionAnalytics(message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionAnalyticsImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionAnalyticsImplCopyWith<_$TransactionAnalyticsImpl>
      get copyWith =>
          __$$TransactionAnalyticsImplCopyWithImpl<_$TransactionAnalyticsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _TransactionAnalytics implements TransactionAnalytics {
  const factory _TransactionAnalytics(
      {required final String message,
      required final AnalyticsData data}) = _$TransactionAnalyticsImpl;

  factory _TransactionAnalytics.fromJson(Map<String, dynamic> json) =
      _$TransactionAnalyticsImpl.fromJson;

  @override
  String get message;
  @override
  AnalyticsData get data;
  @override
  @JsonKey(ignore: true)
  _$$TransactionAnalyticsImplCopyWith<_$TransactionAnalyticsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_categories')
  List<TopCategory> get topCategories => throw _privateConstructorUsedError;
  Period get period => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
          AnalyticsData value, $Res Function(AnalyticsData) then) =
      _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'top_categories') List<TopCategory> topCategories,
      Period period});

  $PeriodCopyWith<$Res> get period;
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? topCategories = null,
    Object? period = null,
  }) {
    return _then(_value.copyWith(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      topCategories: null == topCategories
          ? _value.topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<TopCategory>,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Period,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PeriodCopyWith<$Res> get period {
    return $PeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
          _$AnalyticsDataImpl value, $Res Function(_$AnalyticsDataImpl) then) =
      __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'top_categories') List<TopCategory> topCategories,
      Period period});

  @override
  $PeriodCopyWith<$Res> get period;
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
      _$AnalyticsDataImpl _value, $Res Function(_$AnalyticsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? topCategories = null,
    Object? period = null,
  }) {
    return _then(_$AnalyticsDataImpl(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      topCategories: null == topCategories
          ? _value._topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<TopCategory>,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Period,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl(
      {@JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'top_categories')
      required final List<TopCategory> topCategories,
      required this.period})
      : _topCategories = topCategories;

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  final List<TopCategory> _topCategories;
  @override
  @JsonKey(name: 'top_categories')
  List<TopCategory> get topCategories {
    if (_topCategories is EqualUnmodifiableListView) return _topCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCategories);
  }

  @override
  final Period period;

  @override
  String toString() {
    return 'AnalyticsData(totalAmount: $totalAmount, topCategories: $topCategories, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._topCategories, _topCategories) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalAmount,
      const DeepCollectionEquality().hash(_topCategories), period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData(
      {@JsonKey(name: 'total_amount') required final int totalAmount,
      @JsonKey(name: 'top_categories')
      required final List<TopCategory> topCategories,
      required final Period period}) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount;
  @override
  @JsonKey(name: 'top_categories')
  List<TopCategory> get topCategories;
  @override
  Period get period;
  @override
  @JsonKey(ignore: true)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopCategory _$TopCategoryFromJson(Map<String, dynamic> json) {
  return _TopCategory.fromJson(json);
}

/// @nodoc
mixin _$TopCategory {
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  List<Transaction> get transactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopCategoryCopyWith<TopCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopCategoryCopyWith<$Res> {
  factory $TopCategoryCopyWith(
          TopCategory value, $Res Function(TopCategory) then) =
      _$TopCategoryCopyWithImpl<$Res, TopCategory>;
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'total_amount') int totalAmount,
      List<Transaction> transactions});
}

/// @nodoc
class _$TopCategoryCopyWithImpl<$Res, $Val extends TopCategory>
    implements $TopCategoryCopyWith<$Res> {
  _$TopCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalAmount = null,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopCategoryImplCopyWith<$Res>
    implements $TopCategoryCopyWith<$Res> {
  factory _$$TopCategoryImplCopyWith(
          _$TopCategoryImpl value, $Res Function(_$TopCategoryImpl) then) =
      __$$TopCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'category_name') String categoryName,
      @JsonKey(name: 'total_amount') int totalAmount,
      List<Transaction> transactions});
}

/// @nodoc
class __$$TopCategoryImplCopyWithImpl<$Res>
    extends _$TopCategoryCopyWithImpl<$Res, _$TopCategoryImpl>
    implements _$$TopCategoryImplCopyWith<$Res> {
  __$$TopCategoryImplCopyWithImpl(
      _$TopCategoryImpl _value, $Res Function(_$TopCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? totalAmount = null,
    Object? transactions = null,
  }) {
    return _then(_$TopCategoryImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopCategoryImpl implements _TopCategory {
  const _$TopCategoryImpl(
      {@JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'category_name') required this.categoryName,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      required final List<Transaction> transactions})
      : _transactions = transactions;

  factory _$TopCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopCategoryImplFromJson(json);

  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  final List<Transaction> _transactions;
  @override
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'TopCategory(categoryId: $categoryId, categoryName: $categoryName, totalAmount: $totalAmount, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryName,
      totalAmount, const DeepCollectionEquality().hash(_transactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopCategoryImplCopyWith<_$TopCategoryImpl> get copyWith =>
      __$$TopCategoryImplCopyWithImpl<_$TopCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopCategoryImplToJson(
      this,
    );
  }
}

abstract class _TopCategory implements TopCategory {
  const factory _TopCategory(
      {@JsonKey(name: 'category_id') required final int categoryId,
      @JsonKey(name: 'category_name') required final String categoryName,
      @JsonKey(name: 'total_amount') required final int totalAmount,
      required final List<Transaction> transactions}) = _$TopCategoryImpl;

  factory _TopCategory.fromJson(Map<String, dynamic> json) =
      _$TopCategoryImpl.fromJson;

  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount;
  @override
  List<Transaction> get transactions;
  @override
  @JsonKey(ignore: true)
  _$$TopCategoryImplCopyWith<_$TopCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Period _$PeriodFromJson(Map<String, dynamic> json) {
  return _Period.fromJson(json);
}

/// @nodoc
mixin _$Period {
  String? get periodType => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PeriodCopyWith<Period> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodCopyWith<$Res> {
  factory $PeriodCopyWith(Period value, $Res Function(Period) then) =
      _$PeriodCopyWithImpl<$Res, Period>;
  @useResult
  $Res call({String? periodType, DateTime? start, DateTime? end});
}

/// @nodoc
class _$PeriodCopyWithImpl<$Res, $Val extends Period>
    implements $PeriodCopyWith<$Res> {
  _$PeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodType = freezed,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_value.copyWith(
      periodType: freezed == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as String?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeriodImplCopyWith<$Res> implements $PeriodCopyWith<$Res> {
  factory _$$PeriodImplCopyWith(
          _$PeriodImpl value, $Res Function(_$PeriodImpl) then) =
      __$$PeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? periodType, DateTime? start, DateTime? end});
}

/// @nodoc
class __$$PeriodImplCopyWithImpl<$Res>
    extends _$PeriodCopyWithImpl<$Res, _$PeriodImpl>
    implements _$$PeriodImplCopyWith<$Res> {
  __$$PeriodImplCopyWithImpl(
      _$PeriodImpl _value, $Res Function(_$PeriodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodType = freezed,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_$PeriodImpl(
      periodType: freezed == periodType
          ? _value.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as String?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PeriodImpl implements _Period {
  const _$PeriodImpl({this.periodType, required this.start, required this.end});

  factory _$PeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeriodImplFromJson(json);

  @override
  final String? periodType;
  @override
  final DateTime? start;
  @override
  final DateTime? end;

  @override
  String toString() {
    return 'Period(periodType: $periodType, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodImpl &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, periodType, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodImplCopyWith<_$PeriodImpl> get copyWith =>
      __$$PeriodImplCopyWithImpl<_$PeriodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeriodImplToJson(
      this,
    );
  }
}

abstract class _Period implements Period {
  const factory _Period(
      {final String? periodType,
      required final DateTime? start,
      required final DateTime? end}) = _$PeriodImpl;

  factory _Period.fromJson(Map<String, dynamic> json) = _$PeriodImpl.fromJson;

  @override
  String? get periodType;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  @JsonKey(ignore: true)
  _$$PeriodImplCopyWith<_$PeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
