import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "state.dart";
part 'event.dart';

class BanksBloc extends Bloc<BanksEvent, BanksState> {
  late BanksService banksService;
  BanksBloc() : super(const BanksState()) {
    banksService = service<BanksService>();

    on<StartBanksBloc>((BanksEvent event, Emitter<BanksState> emit) async {
      emit(
        state.copyWith(
          status: ServiceStatus.loading,
        ),
      );
      //
      final res = await banksService.fetchBanks();
      res.when(onError: (error) {
        emit(
          state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.fromFailure(error)),
        );
      }, onSuccess: (data) {
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          banks: data,
        ));
      });
    });

    on<RefreshBanks>((BanksEvent event, Emitter<BanksState> emit) async {
      final res = await banksService.fetchBanks();
      res.when(onError: (error) {
        // Do nothing
      }, onSuccess: (data) {
        emit(state.copyWith(
          banks: data,
        ));
      });
    });

    on<ToggleSelected>((event, emit) {
      if (state.selected.length >= 5) {
        showError("You can only select upto 5 banks");
      } else {
        var selectedBanks = List<int>.from(state.selected);

        if (selectedBanks.contains(event.id)) {
          selectedBanks.remove(event.id);
        } else {
          selectedBanks.add(event.id);
        }

        print(selectedBanks);

        emit(state.copyWith(selected: selectedBanks));
      }
    });

    // Save selected banks
    on<SaveSelectedBanks>((event, emit) async {
      showLoading("Saving banks");

      final res = await banksService.saveWallets(state.selected);

      res.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        showSuccess(data);
        emit(state.copyWith(banksSaved: true));
      });
    });
  }
}
