import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/membership/membership.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'events.dart';

class MemberShipBloc extends Bloc<MembershipEvent, MembershipState> {
  late MembershipService _service;

  MemberShipBloc() : super(const MembershipState()) {
    _service = service<MembershipService>();

    MemberOptions translateOption(String? val) {
      final normalized = (val ?? "basic").toLowerCase();

      if (normalized.contains("basic") || normalized.contains("free")) {
        return MemberOptions.BASIC;
      } else if (normalized.contains("bronze")) {
        return MemberOptions.BRONZE;
      } else if (normalized.contains("premium")) {
        return MemberOptions.PREMIUM;
      } else if (normalized.contains("silver")) {
        return MemberOptions.SILVER;
      } else {
        return MemberOptions.BASIC;
      }
    }

    Map<MemberOptions, MembershipOptions> convert(
        List<MembershipOptions> options) {
      // Create options from these
      final opt = {
        MemberOptions.BASIC: options.firstWhere(
            (element) => element.name.toLowerCase().contains("basic")),
        MemberOptions.BRONZE: options.firstWhere(
            (element) => element.name.toLowerCase().contains("bronze")),
        MemberOptions.PREMIUM: options.firstWhere(
            (element) => element.name.toLowerCase().contains("premium")),
        MemberOptions.SILVER: options.firstWhere(
            (element) => element.name.toLowerCase().contains("silver")),
      };
      return opt;
    }

    on<StartMemberShip>(
        (MembershipEvent event, Emitter<MembershipState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      //
      final res = await _service.fetchOptions();
      res.when(onError: (error) {
        showError(error.error);
        emit(
          state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (response) {
        emit(
          state.copyWith(
              options: response.data,
              status: ServiceStatus.loadingSuccess,
              data: convert(response.data),
              currentOption: translateOption(response.currentUserPlan)),
        );
      });
    });

    on<Subscribe>((event, emit) async {
      showLoading("Please wait");
      final res = await _service.subscribeToPlan(event.plan);

      res.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        showSuccess(data);
      });

      // Refresh wallet
      add(RefreshMemberShip());
    });

    // refresh membership
    on<RefreshMemberShip>(
        (MembershipEvent event, Emitter<MembershipState> emit) async {
      final res = await _service.fetchOptions();
      res.when(onError: (error) {
        showError(error.error);
        // do nothin
        debugPrint(error.error);
      }, onSuccess: (response) {
        emit(
          state.copyWith(
              options: response.data,
              data: convert(response.data),
              currentOption: translateOption(response.currentUserPlan)),
        );
      });
    });
  }
}
