// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_analytic_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NewAnalyticEvent {
  String get period => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String period, DateTime? startDate, DateTime? endDate)
        fetched,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String period, DateTime? startDate, DateTime? endDate)?
        fetched,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String period, DateTime? startDate, DateTime? endDate)?
        fetched,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NewAnalyticFetched value) fetched,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NewAnalyticFetched value)? fetched,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NewAnalyticFetched value)? fetched,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewAnalyticEventCopyWith<NewAnalyticEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewAnalyticEventCopyWith<$Res> {
  factory $NewAnalyticEventCopyWith(
          NewAnalyticEvent value, $Res Function(NewAnalyticEvent) then) =
      _$NewAnalyticEventCopyWithImpl<$Res, NewAnalyticEvent>;
  @useResult
  $Res call({String period, DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class _$NewAnalyticEventCopyWithImpl<$Res, $Val extends NewAnalyticEvent>
    implements $NewAnalyticEventCopyWith<$Res> {
  _$NewAnalyticEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewAnalyticFetchedImplCopyWith<$Res>
    implements $NewAnalyticEventCopyWith<$Res> {
  factory _$$NewAnalyticFetchedImplCopyWith(_$NewAnalyticFetchedImpl value,
          $Res Function(_$NewAnalyticFetchedImpl) then) =
      __$$NewAnalyticFetchedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String period, DateTime? startDate, DateTime? endDate});
}

/// @nodoc
class __$$NewAnalyticFetchedImplCopyWithImpl<$Res>
    extends _$NewAnalyticEventCopyWithImpl<$Res, _$NewAnalyticFetchedImpl>
    implements _$$NewAnalyticFetchedImplCopyWith<$Res> {
  __$$NewAnalyticFetchedImplCopyWithImpl(_$NewAnalyticFetchedImpl _value,
      $Res Function(_$NewAnalyticFetchedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(_$NewAnalyticFetchedImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$NewAnalyticFetchedImpl implements _NewAnalyticFetched {
  const _$NewAnalyticFetchedImpl(
      {required this.period, this.startDate, this.endDate});

  @override
  final String period;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'NewAnalyticEvent.fetched(period: $period, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewAnalyticFetchedImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, period, startDate, endDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewAnalyticFetchedImplCopyWith<_$NewAnalyticFetchedImpl> get copyWith =>
      __$$NewAnalyticFetchedImplCopyWithImpl<_$NewAnalyticFetchedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String period, DateTime? startDate, DateTime? endDate)
        fetched,
  }) {
    return fetched(period, startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String period, DateTime? startDate, DateTime? endDate)?
        fetched,
  }) {
    return fetched?.call(period, startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String period, DateTime? startDate, DateTime? endDate)?
        fetched,
    required TResult orElse(),
  }) {
    if (fetched != null) {
      return fetched(period, startDate, endDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NewAnalyticFetched value) fetched,
  }) {
    return fetched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NewAnalyticFetched value)? fetched,
  }) {
    return fetched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NewAnalyticFetched value)? fetched,
    required TResult orElse(),
  }) {
    if (fetched != null) {
      return fetched(this);
    }
    return orElse();
  }
}

abstract class _NewAnalyticFetched implements NewAnalyticEvent {
  const factory _NewAnalyticFetched(
      {required final String period,
      final DateTime? startDate,
      final DateTime? endDate}) = _$NewAnalyticFetchedImpl;

  @override
  String get period;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  @JsonKey(ignore: true)
  _$$NewAnalyticFetchedImplCopyWith<_$NewAnalyticFetchedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NewAnalyticState {
  NewAnalyticStatus get status => throw _privateConstructorUsedError;
  List<FinancialWallet> get wallets => throw _privateConstructorUsedError;
  Failure? get failure => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewAnalyticStateCopyWith<NewAnalyticState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewAnalyticStateCopyWith<$Res> {
  factory $NewAnalyticStateCopyWith(
          NewAnalyticState value, $Res Function(NewAnalyticState) then) =
      _$NewAnalyticStateCopyWithImpl<$Res, NewAnalyticState>;
  @useResult
  $Res call(
      {NewAnalyticStatus status,
      List<FinancialWallet> wallets,
      Failure? failure});
}

/// @nodoc
class _$NewAnalyticStateCopyWithImpl<$Res, $Val extends NewAnalyticState>
    implements $NewAnalyticStateCopyWith<$Res> {
  _$NewAnalyticStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? wallets = null,
    Object? failure = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NewAnalyticStatus,
      wallets: null == wallets
          ? _value.wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as List<FinancialWallet>,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewAnalyticStateImplCopyWith<$Res>
    implements $NewAnalyticStateCopyWith<$Res> {
  factory _$$NewAnalyticStateImplCopyWith(_$NewAnalyticStateImpl value,
          $Res Function(_$NewAnalyticStateImpl) then) =
      __$$NewAnalyticStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NewAnalyticStatus status,
      List<FinancialWallet> wallets,
      Failure? failure});
}

/// @nodoc
class __$$NewAnalyticStateImplCopyWithImpl<$Res>
    extends _$NewAnalyticStateCopyWithImpl<$Res, _$NewAnalyticStateImpl>
    implements _$$NewAnalyticStateImplCopyWith<$Res> {
  __$$NewAnalyticStateImplCopyWithImpl(_$NewAnalyticStateImpl _value,
      $Res Function(_$NewAnalyticStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? wallets = null,
    Object? failure = freezed,
  }) {
    return _then(_$NewAnalyticStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as NewAnalyticStatus,
      wallets: null == wallets
          ? _value._wallets
          : wallets // ignore: cast_nullable_to_non_nullable
              as List<FinancialWallet>,
      failure: freezed == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ));
  }
}

/// @nodoc

class _$NewAnalyticStateImpl implements _NewAnalyticState {
  const _$NewAnalyticStateImpl(
      {this.status = NewAnalyticStatus.initial,
      final List<FinancialWallet> wallets = const [],
      this.failure})
      : _wallets = wallets;

  @override
  @JsonKey()
  final NewAnalyticStatus status;
  final List<FinancialWallet> _wallets;
  @override
  @JsonKey()
  List<FinancialWallet> get wallets {
    if (_wallets is EqualUnmodifiableListView) return _wallets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wallets);
  }

  @override
  final Failure? failure;

  @override
  String toString() {
    return 'NewAnalyticState(status: $status, wallets: $wallets, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewAnalyticStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._wallets, _wallets) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(_wallets), failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewAnalyticStateImplCopyWith<_$NewAnalyticStateImpl> get copyWith =>
      __$$NewAnalyticStateImplCopyWithImpl<_$NewAnalyticStateImpl>(
          this, _$identity);
}

abstract class _NewAnalyticState implements NewAnalyticState {
  const factory _NewAnalyticState(
      {final NewAnalyticStatus status,
      final List<FinancialWallet> wallets,
      final Failure? failure}) = _$NewAnalyticStateImpl;

  @override
  NewAnalyticStatus get status;
  @override
  List<FinancialWallet> get wallets;
  @override
  Failure? get failure;
  @override
  @JsonKey(ignore: true)
  _$$NewAnalyticStateImplCopyWith<_$NewAnalyticStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
