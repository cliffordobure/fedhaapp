import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/bank/bank.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter/material.dart';

part 'search_bank_event.dart';
part 'search_bank_state.dart';

class SearchBankBloc extends Bloc<SearchBankEvent, SearchBankState> {
  SearchBankBloc() : super(const SearchBankState()) {
    // var banksService = service<BanksService>();
    // var res = banksService.fetchBanks;

    on<SearchBankEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RadioSelectEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
      debugPrint(
          "This is the event index: ${event.index}, this is the state ${state.selectedIndex}");
    });
  }
}
