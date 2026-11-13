import 'package:fedha/data/error/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'multiple_result.freezed.dart';

@freezed
class MultipleResult<T> with _$MultipleResult<T> {
  const factory MultipleResult.onError({
    required Failure error,
  }) = Error;

  const factory MultipleResult.onSuccess({
    required T data,
  }) = Success;
}
