part of 'floating_action_button_bloc.dart';

@freezed
abstract class FloatingActionButtonState with _$FloatingActionButtonState {
  const factory FloatingActionButtonState.closed() = Closed;
  const factory FloatingActionButtonState.opening() = Opening;
  const factory FloatingActionButtonState.opened({String? selectedMenuItem}) =
      Opened;
  const factory FloatingActionButtonState.closing() = Closing;
}
