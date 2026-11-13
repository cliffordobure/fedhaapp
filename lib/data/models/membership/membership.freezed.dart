// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MembershipResponse _$MembershipResponseFromJson(Map<String, dynamic> json) {
  return _MembershipResponse.fromJson(json);
}

/// @nodoc
mixin _$MembershipResponse {
  @JsonKey(name: "current_user_plan")
  String get currentUserPlan => throw _privateConstructorUsedError;
  @JsonKey(name: "data")
  List<MembershipOptions> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipResponseCopyWith<MembershipResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipResponseCopyWith<$Res> {
  factory $MembershipResponseCopyWith(
          MembershipResponse value, $Res Function(MembershipResponse) then) =
      _$MembershipResponseCopyWithImpl<$Res, MembershipResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "current_user_plan") String currentUserPlan,
      @JsonKey(name: "data") List<MembershipOptions> data});
}

/// @nodoc
class _$MembershipResponseCopyWithImpl<$Res, $Val extends MembershipResponse>
    implements $MembershipResponseCopyWith<$Res> {
  _$MembershipResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserPlan = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      currentUserPlan: null == currentUserPlan
          ? _value.currentUserPlan
          : currentUserPlan // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MembershipOptions>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipResponseImplCopyWith<$Res>
    implements $MembershipResponseCopyWith<$Res> {
  factory _$$MembershipResponseImplCopyWith(_$MembershipResponseImpl value,
          $Res Function(_$MembershipResponseImpl) then) =
      __$$MembershipResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "current_user_plan") String currentUserPlan,
      @JsonKey(name: "data") List<MembershipOptions> data});
}

/// @nodoc
class __$$MembershipResponseImplCopyWithImpl<$Res>
    extends _$MembershipResponseCopyWithImpl<$Res, _$MembershipResponseImpl>
    implements _$$MembershipResponseImplCopyWith<$Res> {
  __$$MembershipResponseImplCopyWithImpl(_$MembershipResponseImpl _value,
      $Res Function(_$MembershipResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserPlan = null,
    Object? data = null,
  }) {
    return _then(_$MembershipResponseImpl(
      currentUserPlan: null == currentUserPlan
          ? _value.currentUserPlan
          : currentUserPlan // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MembershipOptions>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipResponseImpl implements _MembershipResponse {
  _$MembershipResponseImpl(
      {@JsonKey(name: "current_user_plan") this.currentUserPlan = "Basic",
      @JsonKey(name: "data") required final List<MembershipOptions> data})
      : _data = data;

  factory _$MembershipResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipResponseImplFromJson(json);

  @override
  @JsonKey(name: "current_user_plan")
  final String currentUserPlan;
  final List<MembershipOptions> _data;
  @override
  @JsonKey(name: "data")
  List<MembershipOptions> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'MembershipResponse(currentUserPlan: $currentUserPlan, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipResponseImpl &&
            (identical(other.currentUserPlan, currentUserPlan) ||
                other.currentUserPlan == currentUserPlan) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentUserPlan, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipResponseImplCopyWith<_$MembershipResponseImpl> get copyWith =>
      __$$MembershipResponseImplCopyWithImpl<_$MembershipResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipResponseImplToJson(
      this,
    );
  }
}

abstract class _MembershipResponse implements MembershipResponse {
  factory _MembershipResponse(
          {@JsonKey(name: "current_user_plan") final String currentUserPlan,
          @JsonKey(name: "data") required final List<MembershipOptions> data}) =
      _$MembershipResponseImpl;

  factory _MembershipResponse.fromJson(Map<String, dynamic> json) =
      _$MembershipResponseImpl.fromJson;

  @override
  @JsonKey(name: "current_user_plan")
  String get currentUserPlan;
  @override
  @JsonKey(name: "data")
  List<MembershipOptions> get data;
  @override
  @JsonKey(ignore: true)
  _$$MembershipResponseImplCopyWith<_$MembershipResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MembershipOptions _$MembershipOptionsFromJson(Map<String, dynamic> json) {
  return _MembershipOptions.fromJson(json);
}

/// @nodoc
mixin _$MembershipOptions {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _priceFromJson)
  double get price => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  List<MembershipFeature> get features => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipOptionsCopyWith<MembershipOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipOptionsCopyWith<$Res> {
  factory $MembershipOptionsCopyWith(
          MembershipOptions value, $Res Function(MembershipOptions) then) =
      _$MembershipOptionsCopyWithImpl<$Res, MembershipOptions>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(fromJson: _priceFromJson) double price,
      int status,
      List<MembershipFeature> features});
}

/// @nodoc
class _$MembershipOptionsCopyWithImpl<$Res, $Val extends MembershipOptions>
    implements $MembershipOptionsCopyWith<$Res> {
  _$MembershipOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? status = null,
    Object? features = null,
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<MembershipFeature>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipOptionsImplCopyWith<$Res>
    implements $MembershipOptionsCopyWith<$Res> {
  factory _$$MembershipOptionsImplCopyWith(_$MembershipOptionsImpl value,
          $Res Function(_$MembershipOptionsImpl) then) =
      __$$MembershipOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(fromJson: _priceFromJson) double price,
      int status,
      List<MembershipFeature> features});
}

/// @nodoc
class __$$MembershipOptionsImplCopyWithImpl<$Res>
    extends _$MembershipOptionsCopyWithImpl<$Res, _$MembershipOptionsImpl>
    implements _$$MembershipOptionsImplCopyWith<$Res> {
  __$$MembershipOptionsImplCopyWithImpl(_$MembershipOptionsImpl _value,
      $Res Function(_$MembershipOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? status = null,
    Object? features = null,
  }) {
    return _then(_$MembershipOptionsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<MembershipFeature>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipOptionsImpl implements _MembershipOptions {
  _$MembershipOptionsImpl(
      {required this.id,
      required this.name,
      @JsonKey(fromJson: _priceFromJson) this.price = 0,
      this.status = 1,
      final List<MembershipFeature> features = const []})
      : _features = features;

  factory _$MembershipOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipOptionsImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _priceFromJson)
  final double price;
  @override
  @JsonKey()
  final int status;
  final List<MembershipFeature> _features;
  @override
  @JsonKey()
  List<MembershipFeature> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  String toString() {
    return 'MembershipOptions(id: $id, name: $name, price: $price, status: $status, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipOptionsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._features, _features));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, status,
      const DeepCollectionEquality().hash(_features));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipOptionsImplCopyWith<_$MembershipOptionsImpl> get copyWith =>
      __$$MembershipOptionsImplCopyWithImpl<_$MembershipOptionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipOptionsImplToJson(
      this,
    );
  }
}

abstract class _MembershipOptions implements MembershipOptions {
  factory _MembershipOptions(
      {required final int id,
      required final String name,
      @JsonKey(fromJson: _priceFromJson) final double price,
      final int status,
      final List<MembershipFeature> features}) = _$MembershipOptionsImpl;

  factory _MembershipOptions.fromJson(Map<String, dynamic> json) =
      _$MembershipOptionsImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(fromJson: _priceFromJson)
  double get price;
  @override
  int get status;
  @override
  List<MembershipFeature> get features;
  @override
  @JsonKey(ignore: true)
  _$$MembershipOptionsImplCopyWith<_$MembershipOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MembershipFeature _$MembershipFeatureFromJson(Map<String, dynamic> json) {
  return _MembershipFeature.fromJson(json);
}

/// @nodoc
mixin _$MembershipFeature {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: "packages_id")
  int get packagesId => throw _privateConstructorUsedError;
  String get feature => throw _privateConstructorUsedError;
  @JsonKey(name: "created_at")
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipFeatureCopyWith<MembershipFeature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipFeatureCopyWith<$Res> {
  factory $MembershipFeatureCopyWith(
          MembershipFeature value, $Res Function(MembershipFeature) then) =
      _$MembershipFeatureCopyWithImpl<$Res, MembershipFeature>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "packages_id") int packagesId,
      String feature,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
}

/// @nodoc
class _$MembershipFeatureCopyWithImpl<$Res, $Val extends MembershipFeature>
    implements $MembershipFeatureCopyWith<$Res> {
  _$MembershipFeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? packagesId = null,
    Object? feature = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      packagesId: null == packagesId
          ? _value.packagesId
          : packagesId // ignore: cast_nullable_to_non_nullable
              as int,
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$MembershipFeatureImplCopyWith<$Res>
    implements $MembershipFeatureCopyWith<$Res> {
  factory _$$MembershipFeatureImplCopyWith(_$MembershipFeatureImpl value,
          $Res Function(_$MembershipFeatureImpl) then) =
      __$$MembershipFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "packages_id") int packagesId,
      String feature,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
}

/// @nodoc
class __$$MembershipFeatureImplCopyWithImpl<$Res>
    extends _$MembershipFeatureCopyWithImpl<$Res, _$MembershipFeatureImpl>
    implements _$$MembershipFeatureImplCopyWith<$Res> {
  __$$MembershipFeatureImplCopyWithImpl(_$MembershipFeatureImpl _value,
      $Res Function(_$MembershipFeatureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? packagesId = null,
    Object? feature = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MembershipFeatureImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      packagesId: null == packagesId
          ? _value.packagesId
          : packagesId // ignore: cast_nullable_to_non_nullable
              as int,
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$MembershipFeatureImpl implements _MembershipFeature {
  _$MembershipFeatureImpl(
      {required this.id,
      @JsonKey(name: "packages_id") required this.packagesId,
      required this.feature,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt});

  factory _$MembershipFeatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipFeatureImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: "packages_id")
  final int packagesId;
  @override
  final String feature;
  @override
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MembershipFeature(id: $id, packagesId: $packagesId, feature: $feature, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipFeatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.packagesId, packagesId) ||
                other.packagesId == packagesId) &&
            (identical(other.feature, feature) || other.feature == feature) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, packagesId, feature, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipFeatureImplCopyWith<_$MembershipFeatureImpl> get copyWith =>
      __$$MembershipFeatureImplCopyWithImpl<_$MembershipFeatureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipFeatureImplToJson(
      this,
    );
  }
}

abstract class _MembershipFeature implements MembershipFeature {
  factory _MembershipFeature(
          {required final int id,
          @JsonKey(name: "packages_id") required final int packagesId,
          required final String feature,
          @JsonKey(name: "created_at") final DateTime? createdAt,
          @JsonKey(name: "updated_at") final DateTime? updatedAt}) =
      _$MembershipFeatureImpl;

  factory _MembershipFeature.fromJson(Map<String, dynamic> json) =
      _$MembershipFeatureImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: "packages_id")
  int get packagesId;
  @override
  String get feature;
  @override
  @JsonKey(name: "created_at")
  DateTime? get createdAt;
  @override
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MembershipFeatureImplCopyWith<_$MembershipFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
