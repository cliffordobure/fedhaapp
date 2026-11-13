// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'faqs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FaQ _$FaQFromJson(Map<String, dynamic> json) {
  return _FaQ.fromJson(json);
}

/// @nodoc
mixin _$FaQ {
  int get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  String get answer => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FaQCopyWith<FaQ> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FaQCopyWith<$Res> {
  factory $FaQCopyWith(FaQ value, $Res Function(FaQ) then) =
      _$FaQCopyWithImpl<$Res, FaQ>;
  @useResult
  $Res call({int id, String question, String answer});
}

/// @nodoc
class _$FaQCopyWithImpl<$Res, $Val extends FaQ> implements $FaQCopyWith<$Res> {
  _$FaQCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FaQImplCopyWith<$Res> implements $FaQCopyWith<$Res> {
  factory _$$FaQImplCopyWith(_$FaQImpl value, $Res Function(_$FaQImpl) then) =
      __$$FaQImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String question, String answer});
}

/// @nodoc
class __$$FaQImplCopyWithImpl<$Res> extends _$FaQCopyWithImpl<$Res, _$FaQImpl>
    implements _$$FaQImplCopyWith<$Res> {
  __$$FaQImplCopyWithImpl(_$FaQImpl _value, $Res Function(_$FaQImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? answer = null,
  }) {
    return _then(_$FaQImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FaQImpl implements _FaQ {
  const _$FaQImpl(
      {required this.id, required this.question, required this.answer});

  factory _$FaQImpl.fromJson(Map<String, dynamic> json) =>
      _$$FaQImplFromJson(json);

  @override
  final int id;
  @override
  final String question;
  @override
  final String answer;

  @override
  String toString() {
    return 'FaQ(id: $id, question: $question, answer: $answer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FaQImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, question, answer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FaQImplCopyWith<_$FaQImpl> get copyWith =>
      __$$FaQImplCopyWithImpl<_$FaQImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FaQImplToJson(
      this,
    );
  }
}

abstract class _FaQ implements FaQ {
  const factory _FaQ(
      {required final int id,
      required final String question,
      required final String answer}) = _$FaQImpl;

  factory _FaQ.fromJson(Map<String, dynamic> json) = _$FaQImpl.fromJson;

  @override
  int get id;
  @override
  String get question;
  @override
  String get answer;
  @override
  @JsonKey(ignore: true)
  _$$FaQImplCopyWith<_$FaQImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
