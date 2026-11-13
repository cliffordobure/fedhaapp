// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetResponse _$BudgetResponseFromJson(Map<String, dynamic> json) {
  return _BudgetResponse.fromJson(json);
}

/// @nodoc
mixin _$BudgetResponse {
  @JsonKey(name: 'all_total_amount')
  int get allTotalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Weekly')
  BudgetType get weekly => throw _privateConstructorUsedError;
  @JsonKey(name: 'Monthly')
  BudgetType get monthly => throw _privateConstructorUsedError;
  @JsonKey(name: 'Annually')
  BudgetType get annually => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetResponseCopyWith<BudgetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetResponseCopyWith<$Res> {
  factory $BudgetResponseCopyWith(
          BudgetResponse value, $Res Function(BudgetResponse) then) =
      _$BudgetResponseCopyWithImpl<$Res, BudgetResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'all_total_amount') int allTotalAmount,
      @JsonKey(name: 'Weekly') BudgetType weekly,
      @JsonKey(name: 'Monthly') BudgetType monthly,
      @JsonKey(name: 'Annually') BudgetType annually});

  $BudgetTypeCopyWith<$Res> get weekly;
  $BudgetTypeCopyWith<$Res> get monthly;
  $BudgetTypeCopyWith<$Res> get annually;
}

/// @nodoc
class _$BudgetResponseCopyWithImpl<$Res, $Val extends BudgetResponse>
    implements $BudgetResponseCopyWith<$Res> {
  _$BudgetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTotalAmount = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? annually = null,
  }) {
    return _then(_value.copyWith(
      allTotalAmount: null == allTotalAmount
          ? _value.allTotalAmount
          : allTotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      annually: null == annually
          ? _value.annually
          : annually // ignore: cast_nullable_to_non_nullable
              as BudgetType,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BudgetTypeCopyWith<$Res> get weekly {
    return $BudgetTypeCopyWith<$Res>(_value.weekly, (value) {
      return _then(_value.copyWith(weekly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BudgetTypeCopyWith<$Res> get monthly {
    return $BudgetTypeCopyWith<$Res>(_value.monthly, (value) {
      return _then(_value.copyWith(monthly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BudgetTypeCopyWith<$Res> get annually {
    return $BudgetTypeCopyWith<$Res>(_value.annually, (value) {
      return _then(_value.copyWith(annually: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BudgetResponseImplCopyWith<$Res>
    implements $BudgetResponseCopyWith<$Res> {
  factory _$$BudgetResponseImplCopyWith(_$BudgetResponseImpl value,
          $Res Function(_$BudgetResponseImpl) then) =
      __$$BudgetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'all_total_amount') int allTotalAmount,
      @JsonKey(name: 'Weekly') BudgetType weekly,
      @JsonKey(name: 'Monthly') BudgetType monthly,
      @JsonKey(name: 'Annually') BudgetType annually});

  @override
  $BudgetTypeCopyWith<$Res> get weekly;
  @override
  $BudgetTypeCopyWith<$Res> get monthly;
  @override
  $BudgetTypeCopyWith<$Res> get annually;
}

/// @nodoc
class __$$BudgetResponseImplCopyWithImpl<$Res>
    extends _$BudgetResponseCopyWithImpl<$Res, _$BudgetResponseImpl>
    implements _$$BudgetResponseImplCopyWith<$Res> {
  __$$BudgetResponseImplCopyWithImpl(
      _$BudgetResponseImpl _value, $Res Function(_$BudgetResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTotalAmount = null,
    Object? weekly = null,
    Object? monthly = null,
    Object? annually = null,
  }) {
    return _then(_$BudgetResponseImpl(
      allTotalAmount: null == allTotalAmount
          ? _value.allTotalAmount
          : allTotalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      weekly: null == weekly
          ? _value.weekly
          : weekly // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      monthly: null == monthly
          ? _value.monthly
          : monthly // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      annually: null == annually
          ? _value.annually
          : annually // ignore: cast_nullable_to_non_nullable
              as BudgetType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetResponseImpl implements _BudgetResponse {
  const _$BudgetResponseImpl(
      {@JsonKey(name: 'all_total_amount') required this.allTotalAmount,
      @JsonKey(name: 'Weekly') required this.weekly,
      @JsonKey(name: 'Monthly') required this.monthly,
      @JsonKey(name: 'Annually') required this.annually});

  factory _$BudgetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetResponseImplFromJson(json);

  @override
  @JsonKey(name: 'all_total_amount')
  final int allTotalAmount;
  @override
  @JsonKey(name: 'Weekly')
  final BudgetType weekly;
  @override
  @JsonKey(name: 'Monthly')
  final BudgetType monthly;
  @override
  @JsonKey(name: 'Annually')
  final BudgetType annually;

  @override
  String toString() {
    return 'BudgetResponse(allTotalAmount: $allTotalAmount, weekly: $weekly, monthly: $monthly, annually: $annually)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetResponseImpl &&
            (identical(other.allTotalAmount, allTotalAmount) ||
                other.allTotalAmount == allTotalAmount) &&
            (identical(other.weekly, weekly) || other.weekly == weekly) &&
            (identical(other.monthly, monthly) || other.monthly == monthly) &&
            (identical(other.annually, annually) ||
                other.annually == annually));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, allTotalAmount, weekly, monthly, annually);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetResponseImplCopyWith<_$BudgetResponseImpl> get copyWith =>
      __$$BudgetResponseImplCopyWithImpl<_$BudgetResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetResponseImplToJson(
      this,
    );
  }
}

abstract class _BudgetResponse implements BudgetResponse {
  const factory _BudgetResponse(
          {@JsonKey(name: 'all_total_amount') required final int allTotalAmount,
          @JsonKey(name: 'Weekly') required final BudgetType weekly,
          @JsonKey(name: 'Monthly') required final BudgetType monthly,
          @JsonKey(name: 'Annually') required final BudgetType annually}) =
      _$BudgetResponseImpl;

  factory _BudgetResponse.fromJson(Map<String, dynamic> json) =
      _$BudgetResponseImpl.fromJson;

  @override
  @JsonKey(name: 'all_total_amount')
  int get allTotalAmount;
  @override
  @JsonKey(name: 'Weekly')
  BudgetType get weekly;
  @override
  @JsonKey(name: 'Monthly')
  BudgetType get monthly;
  @override
  @JsonKey(name: 'Annually')
  BudgetType get annually;
  @override
  @JsonKey(ignore: true)
  _$$BudgetResponseImplCopyWith<_$BudgetResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BudgetType _$BudgetTypeFromJson(Map<String, dynamic> json) {
  return _BudgetType.fromJson(json);
}

/// @nodoc
mixin _$BudgetType {
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  List<Budget> get budgets => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetTypeCopyWith<BudgetType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetTypeCopyWith<$Res> {
  factory $BudgetTypeCopyWith(
          BudgetType value, $Res Function(BudgetType) then) =
      _$BudgetTypeCopyWithImpl<$Res, BudgetType>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') int totalAmount, List<Budget> budgets});
}

/// @nodoc
class _$BudgetTypeCopyWithImpl<$Res, $Val extends BudgetType>
    implements $BudgetTypeCopyWith<$Res> {
  _$BudgetTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? budgets = null,
  }) {
    return _then(_value.copyWith(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      budgets: null == budgets
          ? _value.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<Budget>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetTypeImplCopyWith<$Res>
    implements $BudgetTypeCopyWith<$Res> {
  factory _$$BudgetTypeImplCopyWith(
          _$BudgetTypeImpl value, $Res Function(_$BudgetTypeImpl) then) =
      __$$BudgetTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_amount') int totalAmount, List<Budget> budgets});
}

/// @nodoc
class __$$BudgetTypeImplCopyWithImpl<$Res>
    extends _$BudgetTypeCopyWithImpl<$Res, _$BudgetTypeImpl>
    implements _$$BudgetTypeImplCopyWith<$Res> {
  __$$BudgetTypeImplCopyWithImpl(
      _$BudgetTypeImpl _value, $Res Function(_$BudgetTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAmount = null,
    Object? budgets = null,
  }) {
    return _then(_$BudgetTypeImpl(
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      budgets: null == budgets
          ? _value._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<Budget>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetTypeImpl implements _BudgetType {
  const _$BudgetTypeImpl(
      {@JsonKey(name: 'total_amount') required this.totalAmount,
      required final List<Budget> budgets})
      : _budgets = budgets;

  factory _$BudgetTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetTypeImplFromJson(json);

  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  final List<Budget> _budgets;
  @override
  List<Budget> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  String toString() {
    return 'BudgetType(totalAmount: $totalAmount, budgets: $budgets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetTypeImpl &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._budgets, _budgets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalAmount, const DeepCollectionEquality().hash(_budgets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetTypeImplCopyWith<_$BudgetTypeImpl> get copyWith =>
      __$$BudgetTypeImplCopyWithImpl<_$BudgetTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetTypeImplToJson(
      this,
    );
  }
}

abstract class _BudgetType implements BudgetType {
  const factory _BudgetType(
      {@JsonKey(name: 'total_amount') required final int totalAmount,
      required final List<Budget> budgets}) = _$BudgetTypeImpl;

  factory _BudgetType.fromJson(Map<String, dynamic> json) =
      _$BudgetTypeImpl.fromJson;

  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount;
  @override
  List<Budget> get budgets;
  @override
  @JsonKey(ignore: true)
  _$$BudgetTypeImplCopyWith<_$BudgetTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Budget _$BudgetFromJson(Map<String, dynamic> json) {
  return _Budget.fromJson(json);
}

/// @nodoc
mixin _$Budget {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_name')
  String get budgetName => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetCopyWith<Budget> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) then) =
      _$BudgetCopyWithImpl<$Res, Budget>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'budget_name') String budgetName,
      int amount,
      String img,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res, $Val extends Budget>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetName = null,
    Object? amount = null,
    Object? img = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      budgetName: null == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$BudgetImplCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$$BudgetImplCopyWith(
          _$BudgetImpl value, $Res Function(_$BudgetImpl) then) =
      __$$BudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'budget_name') String budgetName,
      int amount,
      String img,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$BudgetImplCopyWithImpl<$Res>
    extends _$BudgetCopyWithImpl<$Res, _$BudgetImpl>
    implements _$$BudgetImplCopyWith<$Res> {
  __$$BudgetImplCopyWithImpl(
      _$BudgetImpl _value, $Res Function(_$BudgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetName = null,
    Object? amount = null,
    Object? img = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$BudgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      budgetName: null == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$BudgetImpl implements _Budget {
  const _$BudgetImpl(
      {required this.id,
      @JsonKey(name: 'budget_name') required this.budgetName,
      required this.amount,
      required this.img,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$BudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'budget_name')
  final String budgetName;
  @override
  final int amount;
  @override
  final String img;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'Budget(id: $id, budgetName: $budgetName, amount: $amount, img: $img, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetName, budgetName) ||
                other.budgetName == budgetName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, budgetName, amount, img, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      __$$BudgetImplCopyWithImpl<_$BudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetImplToJson(
      this,
    );
  }
}

abstract class _Budget implements Budget {
  const factory _Budget(
          {required final int id,
          @JsonKey(name: 'budget_name') required final String budgetName,
          required final int amount,
          required final String img,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$BudgetImpl;

  factory _Budget.fromJson(Map<String, dynamic> json) = _$BudgetImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'budget_name')
  String get budgetName;
  @override
  int get amount;
  @override
  String get img;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormBudgetSpan _$FormBudgetSpanFromJson(Map<String, dynamic> json) {
  return _FormBudgetSpan.fromJson(json);
}

/// @nodoc
mixin _$FormBudgetSpan {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormBudgetSpanCopyWith<FormBudgetSpan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormBudgetSpanCopyWith<$Res> {
  factory $FormBudgetSpanCopyWith(
          FormBudgetSpan value, $Res Function(FormBudgetSpan) then) =
      _$FormBudgetSpanCopyWithImpl<$Res, FormBudgetSpan>;
  @useResult
  $Res call(
      {int id,
      String name,
      int status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$FormBudgetSpanCopyWithImpl<$Res, $Val extends FormBudgetSpan>
    implements $FormBudgetSpanCopyWith<$Res> {
  _$FormBudgetSpanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FormBudgetSpanImplCopyWith<$Res>
    implements $FormBudgetSpanCopyWith<$Res> {
  factory _$$FormBudgetSpanImplCopyWith(_$FormBudgetSpanImpl value,
          $Res Function(_$FormBudgetSpanImpl) then) =
      __$$FormBudgetSpanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$FormBudgetSpanImplCopyWithImpl<$Res>
    extends _$FormBudgetSpanCopyWithImpl<$Res, _$FormBudgetSpanImpl>
    implements _$$FormBudgetSpanImplCopyWith<$Res> {
  __$$FormBudgetSpanImplCopyWithImpl(
      _$FormBudgetSpanImpl _value, $Res Function(_$FormBudgetSpanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$FormBudgetSpanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
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
class _$FormBudgetSpanImpl implements _FormBudgetSpan {
  const _$FormBudgetSpanImpl(
      {required this.id,
      required this.name,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$FormBudgetSpanImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormBudgetSpanImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int status;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'FormBudgetSpan(id: $id, name: $name, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormBudgetSpanImpl &&
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
  _$$FormBudgetSpanImplCopyWith<_$FormBudgetSpanImpl> get copyWith =>
      __$$FormBudgetSpanImplCopyWithImpl<_$FormBudgetSpanImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormBudgetSpanImplToJson(
      this,
    );
  }
}

abstract class _FormBudgetSpan implements FormBudgetSpan {
  const factory _FormBudgetSpan(
          {required final int id,
          required final String name,
          required final int status,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$FormBudgetSpanImpl;

  factory _FormBudgetSpan.fromJson(Map<String, dynamic> json) =
      _$FormBudgetSpanImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get status;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FormBudgetSpanImplCopyWith<_$FormBudgetSpanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FormBudgetType _$FormBudgetTypeFromJson(Map<String, dynamic> json) {
  return _FormBudgetType.fromJson(json);
}

/// @nodoc
mixin _$FormBudgetType {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get img => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormBudgetTypeCopyWith<FormBudgetType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormBudgetTypeCopyWith<$Res> {
  factory $FormBudgetTypeCopyWith(
          FormBudgetType value, $Res Function(FormBudgetType) then) =
      _$FormBudgetTypeCopyWithImpl<$Res, FormBudgetType>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? img,
      int? status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$FormBudgetTypeCopyWithImpl<$Res, $Val extends FormBudgetType>
    implements $FormBudgetTypeCopyWith<$Res> {
  _$FormBudgetTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
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
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$FormBudgetTypeImplCopyWith<$Res>
    implements $FormBudgetTypeCopyWith<$Res> {
  factory _$$FormBudgetTypeImplCopyWith(_$FormBudgetTypeImpl value,
          $Res Function(_$FormBudgetTypeImpl) then) =
      __$$FormBudgetTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? img,
      int? status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$FormBudgetTypeImplCopyWithImpl<$Res>
    extends _$FormBudgetTypeCopyWithImpl<$Res, _$FormBudgetTypeImpl>
    implements _$$FormBudgetTypeImplCopyWith<$Res> {
  __$$FormBudgetTypeImplCopyWithImpl(
      _$FormBudgetTypeImpl _value, $Res Function(_$FormBudgetTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FormBudgetTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$FormBudgetTypeImpl implements _FormBudgetType {
  const _$FormBudgetTypeImpl(
      {required this.id,
      required this.name,
      this.img,
      this.status,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$FormBudgetTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormBudgetTypeImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? img;
  @override
  final int? status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FormBudgetType(id: $id, name: $name, img: $img, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormBudgetTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, img, status, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormBudgetTypeImplCopyWith<_$FormBudgetTypeImpl> get copyWith =>
      __$$FormBudgetTypeImplCopyWithImpl<_$FormBudgetTypeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormBudgetTypeImplToJson(
      this,
    );
  }
}

abstract class _FormBudgetType implements FormBudgetType {
  const factory _FormBudgetType(
          {required final int id,
          required final String name,
          final String? img,
          final int? status,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$FormBudgetTypeImpl;

  factory _FormBudgetType.fromJson(Map<String, dynamic> json) =
      _$FormBudgetTypeImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get img;
  @override
  int? get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FormBudgetTypeImplCopyWith<_$FormBudgetTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
