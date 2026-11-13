import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/constants/category_color_manager.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/data/models/categories/categories.dart' as category_;

part "state.dart";
part 'event.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  late IncomeService incomeService;
  IncomeBloc() : super(IncomeState()) {
    incomeService = service<IncomeService>();
    on<StartIncome>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));

      final response = await incomeService.fetchIncome();

      response.when(onError: (error) {
        emit(state.copyWith(
            status: ServiceStatus.loadingFailure,
            message: ApplicationMessage.fromFailure(error)));
      }, onSuccess: (data) {
        emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            income: data.data,
            filteredIncome: data.data,
          ),
        );
        // emit totals
        // emit(
        //   state.copyWith(
        //     total: data
        //         .expand((element) => element.transactions)
        //         .toList()
        //         .fold(0, (total, transaction) => total! + transaction.amount),
        //   ),
        // );
      });
    });

    on<RefreshIncome>((event, emit) async {
      final response = await incomeService.fetchIncome();

      response.when(onError: (error) {
        showError("Failed to update income");
        // Do nothing
      }, onSuccess: (data) {
        emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            income: data.data,
            filteredIncome: data.data,
          ),
        );
        // emit totals
        // emit(
        //   state.copyWith(
        //     total: data
        //         .expand((element) => element.transactions)
        //         .toList()
        //         .fold(0, (total, transaction) => total! + transaction.amount),
        //   ),
        // );
      });
    });

    on<FilterIncome>((event, emit) {
      if (event.keyword != null && event.keyword!.isNotEmpty) {
        emit(state.copyWith(
            filteredIncome: state.income
                .where((element) =>
                    element.toJson().toString().contains(event.keyword!))
                .toList()));
      } else {
        emit(state.copyWith(filteredIncome: state.income));
      }
    });

    // fetch types (local-first)
    on<FetchIncomeTypes>((event, emit) async {
      final cache = service<LocalDataCache>();
      final cached = await cache.loadIncomeCategories();
      if (cached != null && cached.isNotEmpty) {
        emit(state.copyWith(
          formStatus: ServiceStatus.loadingSuccess,
          incomeTypes: cached,
        ));
      } else {
        emit(state.copyWith(formStatus: ServiceStatus.loading));
      }

      final response = await incomeService.fetchIncomeType();

      response.when(onError: (error) {
        if (cached == null || cached.isEmpty) {
          emit(state.copyWith(formStatus: ServiceStatus.loadingFailure));
        }
      }, onSuccess: (response) {
        cache.saveIncomeCategories(response);
        emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            incomeTypes: response,
          ),
        );
      });
    });

    // ignore: unused_element
    Color getColorForIncomeType(String incomeTypeName) {
      return state.colorManager.getColorForCategory(incomeTypeName);
    }

    on<SaveIncomeSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response =
            await IncomeService().saveIncomeSubcategory(event.data);

        response.when(onError: (error) {
          showError(error.error);
          emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
        }, onSuccess: (data) {
          showSuccess(data);
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionSuccess,
                message: ApplicationMessage.success(data)),
          );
          // refresh categories
        });
        add(FetchIncomeTypes());
      },
    );
    on<UpdateIncomeSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response = await IncomeService()
            .updateIncomeSubcategory(event.subcategoryId, event.data);

        response.when(onError: (error) {
          showError(error.error);
          emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
        }, onSuccess: (data) {
          showSuccess("Updated Successfully");
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionSuccess,
                message: ApplicationMessage.success(data)),
          );
          // refresh categories
        });
        add(FetchIncomeTypes());
      },
    );
    on<DeleteIncomeSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response =
            await IncomeService().deleteIncomeSubcategory(event.subcategoryId);

        response.when(onError: (error) {
          showError(error.error);
          emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
        }, onSuccess: (data) {
          showSuccess("Deleted Successfully");
          emit(
            state.copyWith(
                formStatus: ServiceStatus.submissionSuccess,
                message: ApplicationMessage.success(data)),
          );
          // refresh categories
        });
        add(FetchIncomeTypes());
      },
    );
    on<GetIncomeCategoryEvent>((event, emit) async {
      final response =
          await incomeService.fetchSpecificIncome(event.categoryId);
      response.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        emit(state.copyWith(selectedCategory: data));
      });
    });
    // save types
    on<SaveIncome>((event, emit) async {
      showLoading("Please wait...");
      emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

      final response = await incomeService.saveIncomeType(event.formData);

      response.when(onError: (error) {
        showError(error.error);
        emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
      }, onSuccess: (data) {
        showSuccess(data);
        emit(
          state.copyWith(
              formStatus: ServiceStatus.submissionSuccess,
              message: ApplicationMessage.success(data)),
        );
        add(RefreshIncome());
      });
    });

    on<SelectIncomeType>((event, emit) {
      emit(state.copyWith(selectedIncomeType: event.incomeType));
    });

    on<SelectIncomeSubCategory>((event, emit) {
      emit(state.copyWith(selectedIncomeSubCategory: event.incomeSubCategory));
    });
    // Categorize expense
    on<CategoriseIncome>((event, emit) async {
      showLoading("Please wait...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response = await incomeService.categorizeIncome(
          event.transaction, event.category);

      response.when(onError: (error) {
        showError(error.error);
        emit(state.copyWith(status: ServiceStatus.submissionFailure));
      }, onSuccess: (data) {
        showSuccess(data);
        // Refresh expense
        add(RefreshIncome());
      });
    });
  }
}
