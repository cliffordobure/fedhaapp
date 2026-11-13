import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'floating_action_button_event.dart';
part 'floating_action_button_state.dart';
part 'floating_action_button_bloc.freezed.dart';

class FloatingActionButtonBloc
    extends Bloc<FloatingActionButtonEvent, FloatingActionButtonState> {
  final AnimationController animationController;

  FloatingActionButtonBloc(this.animationController) : super(const Closed()) {
    on<FloatingActionButtonEvent>((event, emit) async {
      if (event is ButtonPressed) {
        debugPrint("button pressed");
        if (state == const Closed()) {
          animationController.forward();
          emit(const Opening());
        } else if (state is Opened) {
          animationController.reverse();
          emit(const Closing());
        }
      } else if (event is MenuItemPressed) {
        if (state is Opened) {
          emit(Opened(selectedMenuItem: event.title));
          animationController.reverse();
        }
      }
    });
  }
}
