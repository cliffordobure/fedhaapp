import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fedha/constants/category_color_manager.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fedha/data/models/categories/categories.dart' as categoryType;

part "state.dart";
part 'event.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  late ExpenseService expensesService;
  ExpenseBloc() : super(ExpenseState()) {
    expensesService = service<ExpenseService>();
    on<StartExpense>((event, emit) async {
      emit(state.copyWith(status: ServiceStatus.loading));

      final response = await expensesService.fetchExpense();

      response.when(onError: (error) {
        emit(state.copyWith(
            status: ServiceStatus.loadingFailure,
            message: ApplicationMessage.fromFailure(error)));
      }, onSuccess: (data) {
        logger.info("Expense categories received ${data.data.length}");
        emit(
          state.copyWith(
            status: ServiceStatus.loadingSuccess,
            expenses: data,
            filteredExpenses: data,
          ),
        );
        // emit totals
        // emit(
        //   state.copyWith(
        //     total: data.data
        //         .expand((element) => element.transactions)
        //         .toList()
        //         .fold(0, (total, transaction) => total! + transaction.amount),
        //   ),
        // );
      });
    });
    // ignore: unused_element
    Color getColorForIncomeType(String incomeTypeName) {
      return state.colorManager.getColorForCategory(incomeTypeName);
    }

    on<RefreshExpense>((event, emit) async {
      final response = await expensesService.fetchExpense();

      response.when(onError: (error) {
        showError("Failed to update expenses");
        // Do nothing
      }, onSuccess: (data) {
        emit(
          state.copyWith(
            expenses: data,
            filteredExpenses: data,
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

    on<FilterExpense>((event, emit) {
      if (event.keyword != null && event.keyword!.isNotEmpty) {
        // emit(state.copyWith(
        //     filteredExpenses: state.expenses
        //         .where((element) =>
        //             element.toJson().toString().contains(event.keyword!))
        //         .toList()));
      } else {
        emit(state.copyWith(filteredExpenses: state.expenses));
      }
    });
    // load categories (local-first)
    on<LoadCategories>((event, emit) async {
      final cache = service<LocalDataCache>();
      final cached = await cache.loadExpenseCategories();
      if (cached != null && cached.data.isNotEmpty) {
        emit(state.copyWith(
          formStatus: ServiceStatus.loadingSuccess,
          categories: cached,
        ));
      } else {
        emit(state.copyWith(formStatus: ServiceStatus.loading));
      }

      final response = await expensesService.fetchExpenseTypes();

      response.when(onError: (error) {
        if (cached == null || cached.data.isEmpty) {
          emit(state.copyWith(formStatus: ServiceStatus.loadingFailure));
        }
      }, onSuccess: (data) {
        cache.saveExpenseCategories(data);
        emit(
          state.copyWith(
            formStatus: ServiceStatus.loadingSuccess,
            categories: data,
          ),
        );
      });
    });
    // save category
    on<SaveCategory>((event, emit) async {
      showLoading("Please wait...");
      emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

      final response =
          await expensesService.saveExpenseCategory(event.formData);

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
        add(RefreshExpense());
      });
    });

    on<SelectCategory>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<SelectSubCategory>((event, emit) {
      emit(state.copyWith(selectedSubCategory: event.subcategory));
    });

    on<GetExpenseCategoryEvent>((event, emit) async {
      final response = await expensesService.getSpecificCategory(event.id);
      response.when(onError: (error) {
        showError(error.error);
      }, onSuccess: (data) {
        emit(state.copyWith(selectedCategory: data));
      });
    });

    on<SaveExpenseSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response =
            await expensesService.saveExpenseSubcategory(event.data);

        response.when(
          onError: (error) {
            showError(error.error);
            emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
          },
          onSuccess: (data) {
            showSuccess(data);
            emit(
              state.copyWith(
                  formStatus: ServiceStatus.submissionSuccess,
                  message: ApplicationMessage.success(data)),
            );
            // refresh categories
          },
        );
        add(LoadCategories());
      },
    );

    on<DeleteExpenseSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response =
            await expensesService.deleteExpenseSubcategory(event.subcategoryId);

        response.when(
          onError: (error) {
            showError(error.error);
            emit(state.copyWith(formStatus: ServiceStatus.submissionFailure));
          },
          onSuccess: (data) {
            showSuccess(data);
            emit(
              state.copyWith(
                  formStatus: ServiceStatus.submissionSuccess,
                  message: ApplicationMessage.success(data)),
            );
            // refresh categories
          },
        );
        add(LoadCategories());
      },
    );

    on<UpdateExpenseSubCategory>(
      (event, emit) async {
        showLoading("Please wait...");
        emit(state.copyWith(formStatus: ServiceStatus.submissionInProgress));

        final response = await expensesService.updateExpenseSubcategory(
            event.subcategoryId, event.data);

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
        add(LoadCategories());
      },
    );

    // Categorize expense
    on<CategoriseExpense>((event, emit) async {
      showLoading("Please wait...");
      emit(state.copyWith(status: ServiceStatus.submissionInProgress));

      final response = await expensesService.categorizeExpense(
          event.transaction, event.category);

      response.when(onError: (error) {
        showError(error.error);
        emit(state.copyWith(status: ServiceStatus.submissionFailure));
      }, onSuccess: (data) {
        showSuccess(data);
        // Refresh expense
        add(RefreshExpense());
      });
    });

    // Create a new expense type
    on<NewExpenseType>((event, emit) async {
      showLoading("Saving...");
      emit(
        state.copyWith(
          formStatus: ServiceStatus.submissionInProgress,
        ),
      );
      final res =
          await expensesService.saveNewExpenseType({"name": event.name});

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
        add(RefreshExpense());
      });
    });
  }
}
