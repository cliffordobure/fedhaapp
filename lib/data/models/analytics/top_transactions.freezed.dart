// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top_transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TopTransactionsResponse _$TopTransactionsResponseFromJson(
    Map<String, dynamic> json) {
  return _TopTransactionsResponse.fromJson(json);
}

/// @nodoc
mixin _$TopTransactionsResponse {
  int get status => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Data get data => throw _privateConstructorUsedError;
  Period get period => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopTransactionsResponseCopyWith<TopTransactionsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopTransactionsResponseCopyWith<$Res> {
  factory $TopTransactionsResponseCopyWith(TopTransactionsResponse value,
          $Res Function(TopTransactionsResponse) then) =
      _$TopTransactionsResponseCopyWithImpl<$Res, TopTransactionsResponse>;
  @useResult
  $Res call(
      {int status, bool success, String message, Data data, Period period});

  $DataCopyWith<$Res> get data;
  $PeriodCopyWith<$Res> get period;
}

/// @nodoc
class _$TopTransactionsResponseCopyWithImpl<$Res,
        $Val extends TopTransactionsResponse>
    implements $TopTransactionsResponseCopyWith<$Res> {
  _$TopTransactionsResponseCopyWithImpl(this._value, this._then);

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
              as Data,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Period,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataCopyWith<$Res> get data {
    return $DataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
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
abstract class _$$TopTransactionsResponseImplCopyWith<$Res>
    implements $TopTransactionsResponseCopyWith<$Res> {
  factory _$$TopTransactionsResponseImplCopyWith(
          _$TopTransactionsResponseImpl value,
          $Res Function(_$TopTransactionsResponseImpl) then) =
      __$$TopTransactionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int status, bool success, String message, Data data, Period period});

  @override
  $DataCopyWith<$Res> get data;
  @override
  $PeriodCopyWith<$Res> get period;
}

/// @nodoc
class __$$TopTransactionsResponseImplCopyWithImpl<$Res>
    extends _$TopTransactionsResponseCopyWithImpl<$Res,
        _$TopTransactionsResponseImpl>
    implements _$$TopTransactionsResponseImplCopyWith<$Res> {
  __$$TopTransactionsResponseImplCopyWithImpl(
      _$TopTransactionsResponseImpl _value,
      $Res Function(_$TopTransactionsResponseImpl) _then)
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
    return _then(_$TopTransactionsResponseImpl(
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
              as Data,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as Period,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopTransactionsResponseImpl implements _TopTransactionsResponse {
  const _$TopTransactionsResponseImpl(
      {required this.status,
      required this.success,
      required this.message,
      required this.data,
      required this.period});

  factory _$TopTransactionsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopTransactionsResponseImplFromJson(json);

  @override
  final int status;
  @override
  final bool success;
  @override
  final String message;
  @override
  final Data data;
  @override
  final Period period;

  @override
  String toString() {
    return 'TopTransactionsResponse(status: $status, success: $success, message: $message, data: $data, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopTransactionsResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, success, message, data, period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopTransactionsResponseImplCopyWith<_$TopTransactionsResponseImpl>
      get copyWith => __$$TopTransactionsResponseImplCopyWithImpl<
          _$TopTransactionsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopTransactionsResponseImplToJson(
      this,
    );
  }
}

abstract class _TopTransactionsResponse implements TopTransactionsResponse {
  const factory _TopTransactionsResponse(
      {required final int status,
      required final bool success,
      required final String message,
      required final Data data,
      required final Period period}) = _$TopTransactionsResponseImpl;

  factory _TopTransactionsResponse.fromJson(Map<String, dynamic> json) =
      _$TopTransactionsResponseImpl.fromJson;

  @override
  int get status;
  @override
  bool get success;
  @override
  String get message;
  @override
  Data get data;
  @override
  Period get period;
  @override
  @JsonKey(ignore: true)
  _$$TopTransactionsResponseImplCopyWith<_$TopTransactionsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Data _$DataFromJson(Map<String, dynamic> json) {
  return _Data.fromJson(json);
}

/// @nodoc
mixin _$Data {
  @JsonKey(name: 'top_incomes')
  List<Transaction> get topIncomes => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_expenses')
  List<Transaction> get topExpenses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataCopyWith<Data> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataCopyWith<$Res> {
  factory $DataCopyWith(Data value, $Res Function(Data) then) =
      _$DataCopyWithImpl<$Res, Data>;
  @useResult
  $Res call(
      {@JsonKey(name: 'top_incomes') List<Transaction> topIncomes,
      @JsonKey(name: 'top_expenses') List<Transaction> topExpenses});
}

/// @nodoc
class _$DataCopyWithImpl<$Res, $Val extends Data>
    implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topIncomes = null,
    Object? topExpenses = null,
  }) {
    return _then(_value.copyWith(
      topIncomes: null == topIncomes
          ? _value.topIncomes
          : topIncomes // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      topExpenses: null == topExpenses
          ? _value.topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataImplCopyWith<$Res> implements $DataCopyWith<$Res> {
  factory _$$DataImplCopyWith(
          _$DataImpl value, $Res Function(_$DataImpl) then) =
      __$$DataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'top_incomes') List<Transaction> topIncomes,
      @JsonKey(name: 'top_expenses') List<Transaction> topExpenses});
}

/// @nodoc
class __$$DataImplCopyWithImpl<$Res>
    extends _$DataCopyWithImpl<$Res, _$DataImpl>
    implements _$$DataImplCopyWith<$Res> {
  __$$DataImplCopyWithImpl(_$DataImpl _value, $Res Function(_$DataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topIncomes = null,
    Object? topExpenses = null,
  }) {
    return _then(_$DataImpl(
      topIncomes: null == topIncomes
          ? _value._topIncomes
          : topIncomes // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      topExpenses: null == topExpenses
          ? _value._topExpenses
          : topExpenses // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataImpl implements _Data {
  const _$DataImpl(
      {@JsonKey(name: 'top_incomes')
      required final List<Transaction> topIncomes,
      @JsonKey(name: 'top_expenses')
      required final List<Transaction> topExpenses})
      : _topIncomes = topIncomes,
        _topExpenses = topExpenses;

  factory _$DataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataImplFromJson(json);

  final List<Transaction> _topIncomes;
  @override
  @JsonKey(name: 'top_incomes')
  List<Transaction> get topIncomes {
    if (_topIncomes is EqualUnmodifiableListView) return _topIncomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topIncomes);
  }

  final List<Transaction> _topExpenses;
  @override
  @JsonKey(name: 'top_expenses')
  List<Transaction> get topExpenses {
    if (_topExpenses is EqualUnmodifiableListView) return _topExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topExpenses);
  }

  @override
  String toString() {
    return 'Data(topIncomes: $topIncomes, topExpenses: $topExpenses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl &&
            const DeepCollectionEquality()
                .equals(other._topIncomes, _topIncomes) &&
            const DeepCollectionEquality()
                .equals(other._topExpenses, _topExpenses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_topIncomes),
      const DeepCollectionEquality().hash(_topExpenses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      __$$DataImplCopyWithImpl<_$DataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataImplToJson(
      this,
    );
  }
}

abstract class _Data implements Data {
  const factory _Data(
      {@JsonKey(name: 'top_incomes')
      required final List<Transaction> topIncomes,
      @JsonKey(name: 'top_expenses')
      required final List<Transaction> topExpenses}) = _$DataImpl;

  factory _Data.fromJson(Map<String, dynamic> json) = _$DataImpl.fromJson;

  @override
  @JsonKey(name: 'top_incomes')
  List<Transaction> get topIncomes;
  @override
  @JsonKey(name: 'top_expenses')
  List<Transaction> get topExpenses;
  @override
  @JsonKey(ignore: true)
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
