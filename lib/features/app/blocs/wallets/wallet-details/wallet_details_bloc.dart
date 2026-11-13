import "package:flutter_bloc/flutter_bloc.dart";
import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/wallet/wallet_detail/wallet_details.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'wallet_details_event.dart';
part 'wallet_details_state.dart';

class WalletDetailsBloc extends Bloc<WalletDetailEvent, WallletDetailState> {
  late WalletService walletService;
  WalletDetailsBloc() : super(const WallletDetailState(walletdetails: null)) {
    walletService = service<WalletService>();
    on<FetchWalletDetails>(
      (event, Emitter<WallletDetailState> emit) async {
        emit(state.copyWith(status: ServiceStatus.loading));

        try {
          var resp = await walletService.fetchWalletDetails(event.walletId);

          resp.when(
            onError: ((error) {
              debugPrint(error.error);
              emit(state.copyWith(
                  status: ServiceStatus.loadingFailure,
                  message: ApplicationMessage.error(error.error)));
            }),
            onSuccess: ((WalletDetailData data) {
              emit(
                state.copyWith(
                  status: ServiceStatus.loadingSuccess,
                  message: const ApplicationMessage(
                      message: "Wallet details fetched successfully",
                      type: ApplicationMessageType.success),
                  walletdetails: data,
                ),
              );
            }),
          );
        } catch (error) {
          debugPrint(error.toString());
          // Handle any unexpected errors here
          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error("Unexpected error")));
        }
      },
    );

    // In your bloc's event handler:
    on<FetchMoreTransactions>((event, emit) async {
      final currentState = state;
      if (currentState.status == ServiceStatus.loadingSuccess &&
          currentState.walletdetails?.transactions.nextPageUrl != null) {
        try {
          final moreTransactions = await walletService.fetchMoreTransactions(
              event.walletId, event.nextPage);

          moreTransactions.when(onError: ((error) {
            debugPrint(error.error);
            emit(state.copyWith(
                status: ServiceStatus.loadingFailure,
                message: ApplicationMessage.error(error.error)));
          }), onSuccess: ((data) {
            emit(currentState.copyWith(
              walletdetails: currentState.walletdetails!.copyWith(
                transactions: TransactionDetails(
                  data: [
                    ...currentState.walletdetails!.transactions.data,
                    ...data.data
                  ],
                  currentPage: data.currentPage,
                  lastPage: data.lastPage,
                  nextPageUrl: data.nextPageUrl,
                  firstPageUrl: data.firstPageUrl,
                  lastPageUrl: data.lastPageUrl,
                  total: data.total,
                  links: data.links,
                ),
              ),
            ));
          }));
        } catch (e) {
          emit(state.copyWith(
              status: ServiceStatus.loadingFailure,
              message: ApplicationMessage.error("Unexpected error")));
          // Handle error
        }
      }
    });

    on<ClearWalletDetails>((event, emit) {
      emit(const WallletDetailState(
        walletdetails: null,
        status: ServiceStatus.initial,
      ));
    });
  }
}
