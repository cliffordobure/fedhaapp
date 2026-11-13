part of 'new_analytic_bloc.dart';

@freezed
class NewAnalyticEvent with _$NewAnalyticEvent {
  const factory NewAnalyticEvent.fetched({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) = _NewAnalyticFetched;
}
