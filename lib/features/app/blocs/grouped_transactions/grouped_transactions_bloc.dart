import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/transactions/transactions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'grouped_transactions_event.dart';
part 'grouped_transactions_state.dart';

class GroupedTransactionsBloc
    extends Bloc<GroupedTransactionsEvent, GroupedTransactionsState> {
  GroupedTransactionsBloc() : super(const GroupedTransactionsState()) {
    on<GetGroupedTransactionsEvent>(_onEventName);
  }

  Future _onEventName(
    GetGroupedTransactionsEvent event,
    Emitter<GroupedTransactionsState> emit,
  ) async {
    emit(state.copyWith(status: ServiceStatus.loading));

    final res = await TransactionsService().fetchGroupedTransactions(
        days: event.days, perPage: event.perPage, page: event.page);

    res.when(
      onError: (error) {
        showError(error.error);
        emit(state.copyWith(
          status: ServiceStatus.loadingFailure,
          message: ApplicationMessage.error(error.error),
        ));
      },
      onSuccess: (data) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          groupedTransactionData: data,
          // Add other fields here
        ));
      },
    );
  }
}
