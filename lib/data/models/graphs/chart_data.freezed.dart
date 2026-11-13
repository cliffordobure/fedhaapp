// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChartResponse _$ChartResponseFromJson(Map<String, dynamic> json) {
  return _ChartResponse.fromJson(json);
}

/// @nodoc
mixin _$ChartResponse {
  @JsonKey(name: "date_range")
  String get dateRange => throw _privateConstructorUsedError;
  List<ChartData> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartResponseCopyWith<ChartResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartResponseCopyWith<$Res> {
  factory $ChartResponseCopyWith(
          ChartResponse value, $Res Function(ChartResponse) then) =
      _$ChartResponseCopyWithImpl<$Res, ChartResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "date_range") String dateRange, List<ChartData> data});
}

/// @nodoc
class _$ChartResponseCopyWithImpl<$Res, $Val extends ChartResponse>
    implements $ChartResponseCopyWith<$Res> {
  _$ChartResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateRange = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ChartData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartResponseImplCopyWith<$Res>
    implements $ChartResponseCopyWith<$Res> {
  factory _$$ChartResponseImplCopyWith(
          _$ChartResponseImpl value, $Res Function(_$ChartResponseImpl) then) =
      __$$ChartResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "date_range") String dateRange, List<ChartData> data});
}

/// @nodoc
class __$$ChartResponseImplCopyWithImpl<$Res>
    extends _$ChartResponseCopyWithImpl<$Res, _$ChartResponseImpl>
    implements _$$ChartResponseImplCopyWith<$Res> {
  __$$ChartResponseImplCopyWithImpl(
      _$ChartResponseImpl _value, $Res Function(_$ChartResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateRange = null,
    Object? data = null,
  }) {
    return _then(_$ChartResponseImpl(
      dateRange: null == dateRange
          ? _value.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ChartData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartResponseImpl implements _ChartResponse {
  const _$ChartResponseImpl(
      {@JsonKey(name: "date_range") required this.dateRange,
      required final List<ChartData> data})
      : _data = data;

  factory _$ChartResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartResponseImplFromJson(json);

  @override
  @JsonKey(name: "date_range")
  final String dateRange;
  final List<ChartData> _data;
  @override
  List<ChartData> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ChartResponse(dateRange: $dateRange, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartResponseImpl &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, dateRange, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartResponseImplCopyWith<_$ChartResponseImpl> get copyWith =>
      __$$ChartResponseImplCopyWithImpl<_$ChartResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartResponseImplToJson(
      this,
    );
  }
}

abstract class _ChartResponse implements ChartResponse {
  const factory _ChartResponse(
      {@JsonKey(name: "date_range") required final String dateRange,
      required final List<ChartData> data}) = _$ChartResponseImpl;

  factory _ChartResponse.fromJson(Map<String, dynamic> json) =
      _$ChartResponseImpl.fromJson;

  @override
  @JsonKey(name: "date_range")
  String get dateRange;
  @override
  List<ChartData> get data;
  @override
  @JsonKey(ignore: true)
  _$$ChartResponseImplCopyWith<_$ChartResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DonutData _$DonutDataFromJson(Map<String, dynamic> json) {
  return _DonutData.fromJson(json);
}

/// @nodoc
mixin _$DonutData {
  String get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DonutDataCopyWith<DonutData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DonutDataCopyWith<$Res> {
  factory $DonutDataCopyWith(DonutData value, $Res Function(DonutData) then) =
      _$DonutDataCopyWithImpl<$Res, DonutData>;
  @useResult
  $Res call({String x, double y});
}

/// @nodoc
class _$DonutDataCopyWithImpl<$Res, $Val extends DonutData>
    implements $DonutDataCopyWith<$Res> {
  _$DonutDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as String,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DonutDataImplCopyWith<$Res>
    implements $DonutDataCopyWith<$Res> {
  factory _$$DonutDataImplCopyWith(
          _$DonutDataImpl value, $Res Function(_$DonutDataImpl) then) =
      __$$DonutDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String x, double y});
}

/// @nodoc
class __$$DonutDataImplCopyWithImpl<$Res>
    extends _$DonutDataCopyWithImpl<$Res, _$DonutDataImpl>
    implements _$$DonutDataImplCopyWith<$Res> {
  __$$DonutDataImplCopyWithImpl(
      _$DonutDataImpl _value, $Res Function(_$DonutDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$DonutDataImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as String,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DonutDataImpl implements _DonutData {
  const _$DonutDataImpl({required this.x, required this.y});

  factory _$DonutDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DonutDataImplFromJson(json);

  @override
  final String x;
  @override
  final double y;

  @override
  String toString() {
    return 'DonutData(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DonutDataImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DonutDataImplCopyWith<_$DonutDataImpl> get copyWith =>
      __$$DonutDataImplCopyWithImpl<_$DonutDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DonutDataImplToJson(
      this,
    );
  }
}

abstract class _DonutData implements DonutData {
  const factory _DonutData({required final String x, required final double y}) =
      _$DonutDataImpl;

  factory _DonutData.fromJson(Map<String, dynamic> json) =
      _$DonutDataImpl.fromJson;

  @override
  String get x;
  @override
  double get y;
  @override
  @JsonKey(ignore: true)
  _$$DonutDataImplCopyWith<_$DonutDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChartData _$ChartDataFromJson(Map<String, dynamic> json) {
  return _ChartData.fromJson(json);
}

/// @nodoc
mixin _$ChartData {
  String get label => throw _privateConstructorUsedError;
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartDataCopyWith<ChartData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartDataCopyWith<$Res> {
  factory $ChartDataCopyWith(ChartData value, $Res Function(ChartData) then) =
      _$ChartDataCopyWithImpl<$Res, ChartData>;
  @useResult
  $Res call({String label, double income, double expense});
}

/// @nodoc
class _$ChartDataCopyWithImpl<$Res, $Val extends ChartData>
    implements $ChartDataCopyWith<$Res> {
  _$ChartDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? income = null,
    Object? expense = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartDataImplCopyWith<$Res>
    implements $ChartDataCopyWith<$Res> {
  factory _$$ChartDataImplCopyWith(
          _$ChartDataImpl value, $Res Function(_$ChartDataImpl) then) =
      __$$ChartDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double income, double expense});
}

/// @nodoc
class __$$ChartDataImplCopyWithImpl<$Res>
    extends _$ChartDataCopyWithImpl<$Res, _$ChartDataImpl>
    implements _$$ChartDataImplCopyWith<$Res> {
  __$$ChartDataImplCopyWithImpl(
      _$ChartDataImpl _value, $Res Function(_$ChartDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? income = null,
    Object? expense = null,
  }) {
    return _then(_$ChartDataImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartDataImpl implements _ChartData {
  const _$ChartDataImpl(
      {required this.label, required this.income, required this.expense});

  factory _$ChartDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartDataImplFromJson(json);

  @override
  final String label;
  @override
  final double income;
  @override
  final double expense;

  @override
  String toString() {
    return 'ChartData(label: $label, income: $income, expense: $expense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, income, expense);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartDataImplCopyWith<_$ChartDataImpl> get copyWith =>
      __$$ChartDataImplCopyWithImpl<_$ChartDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartDataImplToJson(
      this,
    );
  }
}

abstract class _ChartData implements ChartData {
  const factory _ChartData(
      {required final String label,
      required final double income,
      required final double expense}) = _$ChartDataImpl;

  factory _ChartData.fromJson(Map<String, dynamic> json) =
      _$ChartDataImpl.fromJson;

  @override
  String get label;
  @override
  double get income;
  @override
  double get expense;
  @override
  @JsonKey(ignore: true)
  _$$ChartDataImplCopyWith<_$ChartDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IncomeData {
  String get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IncomeDataCopyWith<IncomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeDataCopyWith<$Res> {
  factory $IncomeDataCopyWith(
          IncomeData value, $Res Function(IncomeData) then) =
      _$IncomeDataCopyWithImpl<$Res, IncomeData>;
  @useResult
  $Res call({String x, double y});
}

/// @nodoc
class _$IncomeDataCopyWithImpl<$Res, $Val extends IncomeData>
    implements $IncomeDataCopyWith<$Res> {
  _$IncomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as String,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeDataImplCopyWith<$Res>
    implements $IncomeDataCopyWith<$Res> {
  factory _$$IncomeDataImplCopyWith(
          _$IncomeDataImpl value, $Res Function(_$IncomeDataImpl) then) =
      __$$IncomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String x, double y});
}

/// @nodoc
class __$$IncomeDataImplCopyWithImpl<$Res>
    extends _$IncomeDataCopyWithImpl<$Res, _$IncomeDataImpl>
    implements _$$IncomeDataImplCopyWith<$Res> {
  __$$IncomeDataImplCopyWithImpl(
      _$IncomeDataImpl _value, $Res Function(_$IncomeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$IncomeDataImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as String,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$IncomeDataImpl implements _IncomeData {
  const _$IncomeDataImpl({required this.x, required this.y});

  @override
  final String x;
  @override
  final double y;

  @override
  String toString() {
    return 'IncomeData(x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeDataImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeDataImplCopyWith<_$IncomeDataImpl> get copyWith =>
      __$$IncomeDataImplCopyWithImpl<_$IncomeDataImpl>(this, _$identity);
}

abstract class _IncomeData implements IncomeData {
  const factory _IncomeData(
      {required final String x, required final double y}) = _$IncomeDataImpl;

  @override
  String get x;
  @override
  double get y;
  @override
  @JsonKey(ignore: true)
  _$$IncomeDataImplCopyWith<_$IncomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
