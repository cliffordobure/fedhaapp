// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trend_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrendAnalysisResponse _$TrendAnalysisResponseFromJson(
    Map<String, dynamic> json) {
  return _TrendAnalysisResponse.fromJson(json);
}

/// @nodoc
mixin _$TrendAnalysisResponse {
  int get status => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<TrendData> get data => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrendAnalysisResponseCopyWith<TrendAnalysisResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendAnalysisResponseCopyWith<$Res> {
  factory $TrendAnalysisResponseCopyWith(TrendAnalysisResponse value,
          $Res Function(TrendAnalysisResponse) then) =
      _$TrendAnalysisResponseCopyWithImpl<$Res, TrendAnalysisResponse>;
  @useResult
  $Res call(
      {int status,
      bool success,
      String message,
      List<TrendData> data,
      String period});
}

/// @nodoc
class _$TrendAnalysisResponseCopyWithImpl<$Res,
        $Val extends TrendAnalysisResponse>
    implements $TrendAnalysisResponseCopyWith<$Res> {
  _$TrendAnalysisResponseCopyWithImpl(this._value, this._then);

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
    Object? data = null,
    Object? period = null,
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
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendAnalysisResponseImplCopyWith<$Res>
    implements $TrendAnalysisResponseCopyWith<$Res> {
  factory _$$TrendAnalysisResponseImplCopyWith(
          _$TrendAnalysisResponseImpl value,
          $Res Function(_$TrendAnalysisResponseImpl) then) =
      __$$TrendAnalysisResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int status,
      bool success,
      String message,
      List<TrendData> data,
      String period});
}

/// @nodoc
class __$$TrendAnalysisResponseImplCopyWithImpl<$Res>
    extends _$TrendAnalysisResponseCopyWithImpl<$Res,
        _$TrendAnalysisResponseImpl>
    implements _$$TrendAnalysisResponseImplCopyWith<$Res> {
  __$$TrendAnalysisResponseImplCopyWithImpl(_$TrendAnalysisResponseImpl _value,
      $Res Function(_$TrendAnalysisResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? success = null,
    Object? message = null,
    Object? data = null,
    Object? period = null,
  }) {
    return _then(_$TrendAnalysisResponseImpl(
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
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendAnalysisResponseImpl implements _TrendAnalysisResponse {
  const _$TrendAnalysisResponseImpl(
      {required this.status,
      required this.success,
      required this.message,
      required final List<TrendData> data,
      required this.period})
      : _data = data;

  factory _$TrendAnalysisResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendAnalysisResponseImplFromJson(json);

  @override
  final int status;
  @override
  final bool success;
  @override
  final String message;
  final List<TrendData> _data;
  @override
  List<TrendData> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String period;

  @override
  String toString() {
    return 'TrendAnalysisResponse(status: $status, success: $success, message: $message, data: $data, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendAnalysisResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, success, message,
      const DeepCollectionEquality().hash(_data), period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendAnalysisResponseImplCopyWith<_$TrendAnalysisResponseImpl>
      get copyWith => __$$TrendAnalysisResponseImplCopyWithImpl<
          _$TrendAnalysisResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendAnalysisResponseImplToJson(
      this,
    );
  }
}

abstract class _TrendAnalysisResponse implements TrendAnalysisResponse {
  const factory _TrendAnalysisResponse(
      {required final int status,
      required final bool success,
      required final String message,
      required final List<TrendData> data,
      required final String period}) = _$TrendAnalysisResponseImpl;

  factory _TrendAnalysisResponse.fromJson(Map<String, dynamic> json) =
      _$TrendAnalysisResponseImpl.fromJson;

  @override
  int get status;
  @override
  bool get success;
  @override
  String get message;
  @override
  List<TrendData> get data;
  @override
  String get period;
  @override
  @JsonKey(ignore: true)
  _$$TrendAnalysisResponseImplCopyWith<_$TrendAnalysisResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TrendData _$TrendDataFromJson(Map<String, dynamic> json) {
  return _TrendData.fromJson(json);
}

/// @nodoc
mixin _$TrendData {
  String? get month => throw _privateConstructorUsedError;
  String? get week => throw _privateConstructorUsedError;
  String get income => throw _privateConstructorUsedError;
  String get expense => throw _privateConstructorUsedError;
  String get net => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrendDataCopyWith<TrendData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendDataCopyWith<$Res> {
  factory $TrendDataCopyWith(TrendData value, $Res Function(TrendData) then) =
      _$TrendDataCopyWithImpl<$Res, TrendData>;
  @useResult
  $Res call(
      {String? month, String? week, String income, String expense, String net});
}

/// @nodoc
class _$TrendDataCopyWithImpl<$Res, $Val extends TrendData>
    implements $TrendDataCopyWith<$Res> {
  _$TrendDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = freezed,
    Object? week = freezed,
    Object? income = null,
    Object? expense = null,
    Object? net = null,
  }) {
    return _then(_value.copyWith(
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      week: freezed == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as String?,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as String,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as String,
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendDataImplCopyWith<$Res>
    implements $TrendDataCopyWith<$Res> {
  factory _$$TrendDataImplCopyWith(
          _$TrendDataImpl value, $Res Function(_$TrendDataImpl) then) =
      __$$TrendDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? month, String? week, String income, String expense, String net});
}

/// @nodoc
class __$$TrendDataImplCopyWithImpl<$Res>
    extends _$TrendDataCopyWithImpl<$Res, _$TrendDataImpl>
    implements _$$TrendDataImplCopyWith<$Res> {
  __$$TrendDataImplCopyWithImpl(
      _$TrendDataImpl _value, $Res Function(_$TrendDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = freezed,
    Object? week = freezed,
    Object? income = null,
    Object? expense = null,
    Object? net = null,
  }) {
    return _then(_$TrendDataImpl(
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String?,
      week: freezed == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as String?,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as String,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as String,
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendDataImpl implements _TrendData {
  const _$TrendDataImpl(
      {this.month,
      this.week,
      required this.income,
      required this.expense,
      required this.net});

  factory _$TrendDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendDataImplFromJson(json);

  @override
  final String? month;
  @override
  final String? week;
  @override
  final String income;
  @override
  final String expense;
  @override
  final String net;

  @override
  String toString() {
    return 'TrendData(month: $month, week: $week, income: $income, expense: $expense, net: $net)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendDataImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.net, net) || other.net == net));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, month, week, income, expense, net);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      __$$TrendDataImplCopyWithImpl<_$TrendDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendDataImplToJson(
      this,
    );
  }
}

abstract class _TrendData implements TrendData {
  const factory _TrendData(
      {final String? month,
      final String? week,
      required final String income,
      required final String expense,
      required final String net}) = _$TrendDataImpl;

  factory _TrendData.fromJson(Map<String, dynamic> json) =
      _$TrendDataImpl.fromJson;

  @override
  String? get month;
  @override
  String? get week;
  @override
  String get income;
  @override
  String get expense;
  @override
  String get net;
  @override
  @JsonKey(ignore: true)
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
