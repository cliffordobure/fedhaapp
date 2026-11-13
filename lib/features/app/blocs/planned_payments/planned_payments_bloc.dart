import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/planned_payments/planned_payments.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';

part 'planned_payments_event.dart';
part 'planned_payments_state.dart';

class PlannedPaymentsBloc
    extends Bloc<PlannedPaymentsEvent, PlannedPaymentsState> {
  PlannedPaymentsBloc() : super(const PlannedPaymentsState()) {
    on<FetchAllPlannedPaymentsEvent>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));
      final res = await PlanningService().getPlannedPayments();

      res.when(
        onError: ((error) {
          showError(error.error);

          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error(error.error)));
        }),
        onSuccess: ((data) {
          emit(state.copyWith(
              status: ServiceStatus.loadingSuccess, plannedPayments: data));
        }),
      );
    });
// "
//     on<FetchPlannedPaymentEvent>((event, emit) async {
//       emit(state.copyWith(status: ServiceStatus.loading));
//       final res = await PlanningService()
//           .getSpecificPlannedPayment(event.plannedPaymentId);

//       res.when(
//         onError: ((error) {
//           showError(error.error);
//           emit(state.copyWith(
//               status: ServiceStatus.loadingFailure,
//               message: ApplicationMessage.error(error.error)));
//         }),
//         onSuccess: ((data) {
//           emit(state.copyWith(
//               status: ServiceStatus.loadingSuccess,
//               fetchedPlannedPayments: data));
//         }),
//       );
//     });"

    on<AddPlannedPaymentsEvent>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));
      final res =
          await PlanningService().createPlannedPayments(event.plannedPayment);

      res.when(
        onError: ((error) {
          showError(error.error);
          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error(error.error)));
        }),
        onSuccess: ((data) {
          showSuccess('Planned payment created');
          add(FetchAllPlannedPaymentsEvent());
        }),
      );
    });

    on<UpdateGoalEvent>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));
      final res = await PlanningService()
          .updatePlannedPayments(event.plannedPayment, event.plannedPaymentId);

      res.when(
        onError: ((error) {
          showError(error.error);
          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error(error.error)));
        }),
        onSuccess: ((data) {
          showSuccess("Planned Payment Updated");
          add(FetchAllPlannedPaymentsEvent());
          emit(state.copyWith(status: ServiceStatus.loadingSuccess));
        }),
      );
    });

    on<DeleteGoalEvent>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));
      final res =
          await PlanningService().deletePlannedPayments(event.plannedPaymentId);

      res.when(
        onError: ((error) {
          showError(error.error);
          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error(error.error)));
        }),
        onSuccess: ((data) {
          showSuccess("PlannedPayments Updated");
          add(FetchAllPlannedPaymentsEvent());
        }),
      );
    });
  }
}
