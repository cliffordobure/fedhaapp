part of 'floating_action_button_bloc.dart';

@freezed
abstract class FloatingActionButtonEvent with _$FloatingActionButtonEvent {
  const factory FloatingActionButtonEvent.buttonPressed() = ButtonPressed;
  const factory FloatingActionButtonEvent.menuItemPressed(String title) =
      MenuItemPressed;
}
