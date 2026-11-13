// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_budgets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserBudget _$UserBudgetFromJson(Map<String, dynamic> json) {
  return _UserBudget.fromJson(json);
}

/// @nodoc
mixin _$UserBudget {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _budgetAmountFromJson)
  String get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
  String? get budgetLimitAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'wallet_name')
  String? get associatedWallet => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'subcategory_name')
  String? get subcategoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'reset_period')
  String? get resetPeriod => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_name')
  String? get budgetName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBudgetCopyWith<UserBudget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBudgetCopyWith<$Res> {
  factory $UserBudgetCopyWith(
          UserBudget value, $Res Function(UserBudget) then) =
      _$UserBudgetCopyWithImpl<$Res, UserBudget>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(fromJson: _budgetAmountFromJson) String amount,
      @JsonKey(
          name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
      String? budgetLimitAmount,
      @JsonKey(name: 'wallet_name') String? associatedWallet,
      @JsonKey(name: 'category_name') String? category,
      @JsonKey(name: 'subcategory_name') String? subcategoryName,
      @JsonKey(name: 'reset_period') String? resetPeriod,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'budget_name') String? budgetName});
}

/// @nodoc
class _$UserBudgetCopyWithImpl<$Res, $Val extends UserBudget>
    implements $UserBudgetCopyWith<$Res> {
  _$UserBudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? amount = null,
    Object? budgetLimitAmount = freezed,
    Object? associatedWallet = freezed,
    Object? category = freezed,
    Object? subcategoryName = freezed,
    Object? resetPeriod = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? budgetName = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      budgetLimitAmount: freezed == budgetLimitAmount
          ? _value.budgetLimitAmount
          : budgetLimitAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedWallet: freezed == associatedWallet
          ? _value.associatedWallet
          : associatedWallet // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      resetPeriod: freezed == resetPeriod
          ? _value.resetPeriod
          : resetPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      budgetName: freezed == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBudgetImplCopyWith<$Res>
    implements $UserBudgetCopyWith<$Res> {
  factory _$$UserBudgetImplCopyWith(
          _$UserBudgetImpl value, $Res Function(_$UserBudgetImpl) then) =
      __$$UserBudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(fromJson: _budgetAmountFromJson) String amount,
      @JsonKey(
          name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
      String? budgetLimitAmount,
      @JsonKey(name: 'wallet_name') String? associatedWallet,
      @JsonKey(name: 'category_name') String? category,
      @JsonKey(name: 'subcategory_name') String? subcategoryName,
      @JsonKey(name: 'reset_period') String? resetPeriod,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'budget_name') String? budgetName});
}

/// @nodoc
class __$$UserBudgetImplCopyWithImpl<$Res>
    extends _$UserBudgetCopyWithImpl<$Res, _$UserBudgetImpl>
    implements _$$UserBudgetImplCopyWith<$Res> {
  __$$UserBudgetImplCopyWithImpl(
      _$UserBudgetImpl _value, $Res Function(_$UserBudgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? amount = null,
    Object? budgetLimitAmount = freezed,
    Object? associatedWallet = freezed,
    Object? category = freezed,
    Object? subcategoryName = freezed,
    Object? resetPeriod = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? budgetName = freezed,
  }) {
    return _then(_$UserBudgetImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      budgetLimitAmount: freezed == budgetLimitAmount
          ? _value.budgetLimitAmount
          : budgetLimitAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      associatedWallet: freezed == associatedWallet
          ? _value.associatedWallet
          : associatedWallet // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      resetPeriod: freezed == resetPeriod
          ? _value.resetPeriod
          : resetPeriod // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      budgetName: freezed == budgetName
          ? _value.budgetName
          : budgetName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBudgetImpl with DiagnosticableTreeMixin implements _UserBudget {
  const _$UserBudgetImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(fromJson: _budgetAmountFromJson) this.amount = "0",
      @JsonKey(
          name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
      this.budgetLimitAmount,
      @JsonKey(name: 'wallet_name') this.associatedWallet,
      @JsonKey(name: 'category_name') this.category,
      @JsonKey(name: 'subcategory_name') this.subcategoryName,
      @JsonKey(name: 'reset_period') this.resetPeriod,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'budget_name') this.budgetName});

  factory _$UserBudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBudgetImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(fromJson: _budgetAmountFromJson)
  final String amount;
  @override
  @JsonKey(name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
  final String? budgetLimitAmount;
  @override
  @JsonKey(name: 'wallet_name')
  final String? associatedWallet;
  @override
  @JsonKey(name: 'category_name')
  final String? category;
  @override
  @JsonKey(name: 'subcategory_name')
  final String? subcategoryName;
  @override
  @JsonKey(name: 'reset_period')
  final String? resetPeriod;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'budget_name')
  final String? budgetName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserBudget(id: $id, userId: $userId, amount: $amount, budgetLimitAmount: $budgetLimitAmount, associatedWallet: $associatedWallet, category: $category, subcategoryName: $subcategoryName, resetPeriod: $resetPeriod, createdAt: $createdAt, updatedAt: $updatedAt, budgetName: $budgetName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserBudget'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('budgetLimitAmount', budgetLimitAmount))
      ..add(DiagnosticsProperty('associatedWallet', associatedWallet))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('subcategoryName', subcategoryName))
      ..add(DiagnosticsProperty('resetPeriod', resetPeriod))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('budgetName', budgetName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.budgetLimitAmount, budgetLimitAmount) ||
                other.budgetLimitAmount == budgetLimitAmount) &&
            (identical(other.associatedWallet, associatedWallet) ||
                other.associatedWallet == associatedWallet) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.resetPeriod, resetPeriod) ||
                other.resetPeriod == resetPeriod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.budgetName, budgetName) ||
                other.budgetName == budgetName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      amount,
      budgetLimitAmount,
      associatedWallet,
      category,
      subcategoryName,
      resetPeriod,
      createdAt,
      updatedAt,
      budgetName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBudgetImplCopyWith<_$UserBudgetImpl> get copyWith =>
      __$$UserBudgetImplCopyWithImpl<_$UserBudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBudgetImplToJson(
      this,
    );
  }
}

abstract class _UserBudget implements UserBudget {
  const factory _UserBudget(
      {required final int? id,
      @JsonKey(name: 'user_id') required final int? userId,
      @JsonKey(fromJson: _budgetAmountFromJson) final String amount,
      @JsonKey(
          name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
      final String? budgetLimitAmount,
      @JsonKey(name: 'wallet_name') final String? associatedWallet,
      @JsonKey(name: 'category_name') final String? category,
      @JsonKey(name: 'subcategory_name') final String? subcategoryName,
      @JsonKey(name: 'reset_period') final String? resetPeriod,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'budget_name')
      final String? budgetName}) = _$UserBudgetImpl;

  factory _UserBudget.fromJson(Map<String, dynamic> json) =
      _$UserBudgetImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(fromJson: _budgetAmountFromJson)
  String get amount;
  @override
  @JsonKey(name: 'budget_limit_amount', fromJson: _budgetOptionalAmountFromJson)
  String? get budgetLimitAmount;
  @override
  @JsonKey(name: 'wallet_name')
  String? get associatedWallet;
  @override
  @JsonKey(name: 'category_name')
  String? get category;
  @override
  @JsonKey(name: 'subcategory_name')
  String? get subcategoryName;
  @override
  @JsonKey(name: 'reset_period')
  String? get resetPeriod;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'budget_name')
  String? get budgetName;
  @override
  @JsonKey(ignore: true)
  _$$UserBudgetImplCopyWith<_$UserBudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBudgets _$UserBudgetsFromJson(Map<String, dynamic> json) {
  return _UserBudgets.fromJson(json);
}

/// @nodoc
mixin _$UserBudgets {
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_budgets')
  List<UserBudget> get budgets => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBudgetsCopyWith<UserBudgets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBudgetsCopyWith<$Res> {
  factory $UserBudgetsCopyWith(
          UserBudgets value, $Res Function(UserBudgets) then) =
      _$UserBudgetsCopyWithImpl<$Res, UserBudgets>;
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'user_budgets') List<UserBudget> budgets});
}

/// @nodoc
class _$UserBudgetsCopyWithImpl<$Res, $Val extends UserBudgets>
    implements $UserBudgetsCopyWith<$Res> {
  _$UserBudgetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? budgets = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      budgets: null == budgets
          ? _value.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<UserBudget>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBudgetsImplCopyWith<$Res>
    implements $UserBudgetsCopyWith<$Res> {
  factory _$$UserBudgetsImplCopyWith(
          _$UserBudgetsImpl value, $Res Function(_$UserBudgetsImpl) then) =
      __$$UserBudgetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      @JsonKey(name: 'user_budgets') List<UserBudget> budgets});
}

/// @nodoc
class __$$UserBudgetsImplCopyWithImpl<$Res>
    extends _$UserBudgetsCopyWithImpl<$Res, _$UserBudgetsImpl>
    implements _$$UserBudgetsImplCopyWith<$Res> {
  __$$UserBudgetsImplCopyWithImpl(
      _$UserBudgetsImpl _value, $Res Function(_$UserBudgetsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? budgets = null,
  }) {
    return _then(_$UserBudgetsImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      budgets: null == budgets
          ? _value._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<UserBudget>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBudgetsImpl with DiagnosticableTreeMixin implements _UserBudgets {
  const _$UserBudgetsImpl(
      {required this.message,
      @JsonKey(name: 'user_budgets') required final List<UserBudget> budgets})
      : _budgets = budgets;

  factory _$UserBudgetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBudgetsImplFromJson(json);

  @override
  final String message;
  final List<UserBudget> _budgets;
  @override
  @JsonKey(name: 'user_budgets')
  List<UserBudget> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserBudgets(message: $message, budgets: $budgets)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserBudgets'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('budgets', budgets));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBudgetsImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._budgets, _budgets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_budgets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBudgetsImplCopyWith<_$UserBudgetsImpl> get copyWith =>
      __$$UserBudgetsImplCopyWithImpl<_$UserBudgetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBudgetsImplToJson(
      this,
    );
  }
}

abstract class _UserBudgets implements UserBudgets {
  const factory _UserBudgets(
      {required final String message,
      @JsonKey(name: 'user_budgets')
      required final List<UserBudget> budgets}) = _$UserBudgetsImpl;

  factory _UserBudgets.fromJson(Map<String, dynamic> json) =
      _$UserBudgetsImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(name: 'user_budgets')
  List<UserBudget> get budgets;
  @override
  @JsonKey(ignore: true)
  _$$UserBudgetsImplCopyWith<_$UserBudgetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateBudget _$CreateBudgetFromJson(Map<String, dynamic> json) {
  return _CreateBudget.fromJson(json);
}

/// @nodoc
mixin _$CreateBudget {
  int get budgetId => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_limit_amount')
  double get budgetLimitAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reset_period')
  String get resetPeriod => throw _privateConstructorUsedError;
  @JsonKey(name: 'associated_wallet')
  int get associatedWallet => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateBudgetCopyWith<CreateBudget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBudgetCopyWith<$Res> {
  factory $CreateBudgetCopyWith(
          CreateBudget value, $Res Function(CreateBudget) then) =
      _$CreateBudgetCopyWithImpl<$Res, CreateBudget>;
  @useResult
  $Res call(
      {int budgetId,
      int type,
      double amount,
      @JsonKey(name: 'budget_limit_amount') double budgetLimitAmount,
      @JsonKey(name: 'reset_period') String resetPeriod,
      @JsonKey(name: 'associated_wallet') int associatedWallet});
}

/// @nodoc
class _$CreateBudgetCopyWithImpl<$Res, $Val extends CreateBudget>
    implements $CreateBudgetCopyWith<$Res> {
  _$CreateBudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? type = null,
    Object? amount = null,
    Object? budgetLimitAmount = null,
    Object? resetPeriod = null,
    Object? associatedWallet = null,
  }) {
    return _then(_value.copyWith(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      budgetLimitAmount: null == budgetLimitAmount
          ? _value.budgetLimitAmount
          : budgetLimitAmount // ignore: cast_nullable_to_non_nullable
              as double,
      resetPeriod: null == resetPeriod
          ? _value.resetPeriod
          : resetPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      associatedWallet: null == associatedWallet
          ? _value.associatedWallet
          : associatedWallet // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateBudgetImplCopyWith<$Res>
    implements $CreateBudgetCopyWith<$Res> {
  factory _$$CreateBudgetImplCopyWith(
          _$CreateBudgetImpl value, $Res Function(_$CreateBudgetImpl) then) =
      __$$CreateBudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int budgetId,
      int type,
      double amount,
      @JsonKey(name: 'budget_limit_amount') double budgetLimitAmount,
      @JsonKey(name: 'reset_period') String resetPeriod,
      @JsonKey(name: 'associated_wallet') int associatedWallet});
}

/// @nodoc
class __$$CreateBudgetImplCopyWithImpl<$Res>
    extends _$CreateBudgetCopyWithImpl<$Res, _$CreateBudgetImpl>
    implements _$$CreateBudgetImplCopyWith<$Res> {
  __$$CreateBudgetImplCopyWithImpl(
      _$CreateBudgetImpl _value, $Res Function(_$CreateBudgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? type = null,
    Object? amount = null,
    Object? budgetLimitAmount = null,
    Object? resetPeriod = null,
    Object? associatedWallet = null,
  }) {
    return _then(_$CreateBudgetImpl(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      budgetLimitAmount: null == budgetLimitAmount
          ? _value.budgetLimitAmount
          : budgetLimitAmount // ignore: cast_nullable_to_non_nullable
              as double,
      resetPeriod: null == resetPeriod
          ? _value.resetPeriod
          : resetPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      associatedWallet: null == associatedWallet
          ? _value.associatedWallet
          : associatedWallet // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBudgetImpl with DiagnosticableTreeMixin implements _CreateBudget {
  const _$CreateBudgetImpl(
      {this.budgetId = 0,
      required this.type,
      required this.amount,
      @JsonKey(name: 'budget_limit_amount') required this.budgetLimitAmount,
      @JsonKey(name: 'reset_period') required this.resetPeriod,
      @JsonKey(name: 'associated_wallet') required this.associatedWallet});

  factory _$CreateBudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBudgetImplFromJson(json);

  @override
  @JsonKey()
  final int budgetId;
  @override
  final int type;
  @override
  final double amount;
  @override
  @JsonKey(name: 'budget_limit_amount')
  final double budgetLimitAmount;
  @override
  @JsonKey(name: 'reset_period')
  final String resetPeriod;
  @override
  @JsonKey(name: 'associated_wallet')
  final int associatedWallet;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreateBudget(budgetId: $budgetId, type: $type, amount: $amount, budgetLimitAmount: $budgetLimitAmount, resetPeriod: $resetPeriod, associatedWallet: $associatedWallet)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreateBudget'))
      ..add(DiagnosticsProperty('budgetId', budgetId))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('budgetLimitAmount', budgetLimitAmount))
      ..add(DiagnosticsProperty('resetPeriod', resetPeriod))
      ..add(DiagnosticsProperty('associatedWallet', associatedWallet));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBudgetImpl &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.budgetLimitAmount, budgetLimitAmount) ||
                other.budgetLimitAmount == budgetLimitAmount) &&
            (identical(other.resetPeriod, resetPeriod) ||
                other.resetPeriod == resetPeriod) &&
            (identical(other.associatedWallet, associatedWallet) ||
                other.associatedWallet == associatedWallet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, budgetId, type, amount,
      budgetLimitAmount, resetPeriod, associatedWallet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBudgetImplCopyWith<_$CreateBudgetImpl> get copyWith =>
      __$$CreateBudgetImplCopyWithImpl<_$CreateBudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBudgetImplToJson(
      this,
    );
  }
}

abstract class _CreateBudget implements CreateBudget {
  const factory _CreateBudget(
      {final int budgetId,
      required final int type,
      required final double amount,
      @JsonKey(name: 'budget_limit_amount')
      required final double budgetLimitAmount,
      @JsonKey(name: 'reset_period') required final String resetPeriod,
      @JsonKey(name: 'associated_wallet')
      required final int associatedWallet}) = _$CreateBudgetImpl;

  factory _CreateBudget.fromJson(Map<String, dynamic> json) =
      _$CreateBudgetImpl.fromJson;

  @override
  int get budgetId;
  @override
  int get type;
  @override
  double get amount;
  @override
  @JsonKey(name: 'budget_limit_amount')
  double get budgetLimitAmount;
  @override
  @JsonKey(name: 'reset_period')
  String get resetPeriod;
  @override
  @JsonKey(name: 'associated_wallet')
  int get associatedWallet;
  @override
  @JsonKey(ignore: true)
  _$$CreateBudgetImplCopyWith<_$CreateBudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SingleBudgetResponse _$SingleBudgetResponseFromJson(Map<String, dynamic> json) {
  return _SingleBudgetResponse.fromJson(json);
}

/// @nodoc
mixin _$SingleBudgetResponse {
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_budget')
  UserBudget get budget => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SingleBudgetResponseCopyWith<SingleBudgetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleBudgetResponseCopyWith<$Res> {
  factory $SingleBudgetResponseCopyWith(SingleBudgetResponse value,
          $Res Function(SingleBudgetResponse) then) =
      _$SingleBudgetResponseCopyWithImpl<$Res, SingleBudgetResponse>;
  @useResult
  $Res call({String message, @JsonKey(name: 'user_budget') UserBudget budget});

  $UserBudgetCopyWith<$Res> get budget;
}

/// @nodoc
class _$SingleBudgetResponseCopyWithImpl<$Res,
        $Val extends SingleBudgetResponse>
    implements $SingleBudgetResponseCopyWith<$Res> {
  _$SingleBudgetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? budget = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as UserBudget,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserBudgetCopyWith<$Res> get budget {
    return $UserBudgetCopyWith<$Res>(_value.budget, (value) {
      return _then(_value.copyWith(budget: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SingleBudgetResponseImplCopyWith<$Res>
    implements $SingleBudgetResponseCopyWith<$Res> {
  factory _$$SingleBudgetResponseImplCopyWith(_$SingleBudgetResponseImpl value,
          $Res Function(_$SingleBudgetResponseImpl) then) =
      __$$SingleBudgetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, @JsonKey(name: 'user_budget') UserBudget budget});

  @override
  $UserBudgetCopyWith<$Res> get budget;
}

/// @nodoc
class __$$SingleBudgetResponseImplCopyWithImpl<$Res>
    extends _$SingleBudgetResponseCopyWithImpl<$Res, _$SingleBudgetResponseImpl>
    implements _$$SingleBudgetResponseImplCopyWith<$Res> {
  __$$SingleBudgetResponseImplCopyWithImpl(_$SingleBudgetResponseImpl _value,
      $Res Function(_$SingleBudgetResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? budget = null,
  }) {
    return _then(_$SingleBudgetResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as UserBudget,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SingleBudgetResponseImpl
    with DiagnosticableTreeMixin
    implements _SingleBudgetResponse {
  const _$SingleBudgetResponseImpl(
      {required this.message,
      @JsonKey(name: 'user_budget') required this.budget});

  factory _$SingleBudgetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SingleBudgetResponseImplFromJson(json);

  @override
  final String message;
  @override
  @JsonKey(name: 'user_budget')
  final UserBudget budget;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SingleBudgetResponse(message: $message, budget: $budget)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SingleBudgetResponse'))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('budget', budget));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SingleBudgetResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.budget, budget) || other.budget == budget));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, budget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleBudgetResponseImplCopyWith<_$SingleBudgetResponseImpl>
      get copyWith =>
          __$$SingleBudgetResponseImplCopyWithImpl<_$SingleBudgetResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SingleBudgetResponseImplToJson(
      this,
    );
  }
}

abstract class _SingleBudgetResponse implements SingleBudgetResponse {
  const factory _SingleBudgetResponse(
          {required final String message,
          @JsonKey(name: 'user_budget') required final UserBudget budget}) =
      _$SingleBudgetResponseImpl;

  factory _SingleBudgetResponse.fromJson(Map<String, dynamic> json) =
      _$SingleBudgetResponseImpl.fromJson;

  @override
  String get message;
  @override
  @JsonKey(name: 'user_budget')
  UserBudget get budget;
  @override
  @JsonKey(ignore: true)
  _$$SingleBudgetResponseImplCopyWith<_$SingleBudgetResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
