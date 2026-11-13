import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/analytics/financial_data.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/subscriptions/subscriptions.dart';
import 'package:fedha/data/models/subscriptions/user_subscriptions.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  late SubscriptionService subscriptionsService;
  SubscriptionsBloc() : super(const SubscriptionsState()) {
    subscriptionsService = service<SubscriptionService>();

    on<StartSubscriptionsBloc>(
        (SubscriptionsEvent event, Emitter<SubscriptionsState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      final res = await subscriptionsService.fetchUserSubscriptions();
      res.when(
        onError: (error) {
          emit(
            state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) => emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            span: FinancialSpan.weekly,
            selected: data.weekly,
            subscriptions: data,
          ),
        ),
      );
    });

    // RefreshSubscriptions
    on<RefreshSubscriptions>(
        (SubscriptionsEvent event, Emitter<SubscriptionsState> emit) async {
      final res = await subscriptionsService.fetchUserSubscriptions();
      res.when(
        onError: (error) {
          showError(error.error);
        },
        onSuccess: (data) => emit(
          state.copyWith(
            span: FinancialSpan.weekly,
            selected: data.weekly,
            subscriptions: data,
          ),
        ),
      );
    });

    on<StartSubscriptionForm>(
        (SubscriptionsEvent event, Emitter<SubscriptionsState> emit) async {
      emit(
        state.copyWith(
          formStatus: ServiceStatus.loading,
        ),
      );
      final res = await subscriptionsService.fetchSubscriptions();
      final res2 = await subscriptionsService.fetchSubscriptionsSpans();

      res.when(
        onError: (error) {
          emit(
            state.copyWith(
                formStatus: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) => emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            formSubscriptions: data,
          ),
        ),
      );

      res2.when(
        onError: (error) {
          emit(
            state.copyWith(
                formStatus: ServiceStatus.loadingFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) => emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            formSubscriptionSpans: data,
          ),
        ),
      );
    });

    on<SubscriptionsSpanSelected>((event, emit) {
      SubscriptionSpan data;
      switch (event.span) {
        case FinancialSpan.weekly:
          data = state.subscriptions!.weekly;
          break;
        case FinancialSpan.monthly:
          data = state.subscriptions!.monthly;
          break;
        case FinancialSpan.yearly:
          data = state.subscriptions!.annually;
          break;
        default:
          data = state.subscriptions!.weekly;
      }

      emit(state.copyWith(span: event.span, selected: data));
    });

    on<NewSubscription>((event, emit) async {
      showLoading("Please wait");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.submissionInProgress,
        ),
      );
      final res = await subscriptionsService.saveSubscription(event.data);
      res.when(
        onError: (error) {
          showError(error.error);
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) {
          showSuccess(data);
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionSuccess,
                message: ApplicationMessage.success(data)),
          );
          // refresh subscriptions
          add(RefreshSubscriptions());
        },
      );
    });

    on<CancelSubscriptions>((event, emit) async {
      showLoading("Please wait");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.submissionInProgress,
        ),
      );
      final res = await subscriptionsService.cancelSubscription(event.id);
      res.when(
        onError: (error) {
          showError(error.error);
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionFailure,
                message: ApplicationMessage.fromFailure(error)),
          );
        },
        onSuccess: (data) {
          showSuccess(data);
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionSuccess,
                message: ApplicationMessage.success(data)),
          );
        },
      );
    });

    // refresh types
    on<RefreshSubscriptionTypes>((event, emit) async {
      final res = await subscriptionsService.fetchSubscriptions();

      res.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        showSuccess("Subscription saved");
        // update types
        emit(state.copyWith(formSubscriptions: data));
      });
    });

    // Create a new budget type
    on<NewSubscriptionType>((event, emit) async {
      showLoading("Saving...");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.submissionInProgress,
        ),
      );
      final res = await subscriptionsService
          .saveNewSubscriptionType({"name": event.name});

      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        showSuccess(data);
        // EasyLoading.dismiss();
        emit(
          state.copyWith(
              formStatus: ServiceStatus.loadingSuccess,
              message: ApplicationMessage.success(data)),
        );
        // refresh types
        add(RefreshSubscriptionTypes());
      });
    });
  }
}
