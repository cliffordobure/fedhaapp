// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floating_action_button_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FloatingActionButtonEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() buttonPressed,
    required TResult Function(String title) menuItemPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? buttonPressed,
    TResult? Function(String title)? menuItemPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? buttonPressed,
    TResult Function(String title)? menuItemPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ButtonPressed value) buttonPressed,
    required TResult Function(MenuItemPressed value) menuItemPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ButtonPressed value)? buttonPressed,
    TResult? Function(MenuItemPressed value)? menuItemPressed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ButtonPressed value)? buttonPressed,
    TResult Function(MenuItemPressed value)? menuItemPressed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloatingActionButtonEventCopyWith<$Res> {
  factory $FloatingActionButtonEventCopyWith(FloatingActionButtonEvent value,
          $Res Function(FloatingActionButtonEvent) then) =
      _$FloatingActionButtonEventCopyWithImpl<$Res, FloatingActionButtonEvent>;
}

/// @nodoc
class _$FloatingActionButtonEventCopyWithImpl<$Res,
        $Val extends FloatingActionButtonEvent>
    implements $FloatingActionButtonEventCopyWith<$Res> {
  _$FloatingActionButtonEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ButtonPressedImplCopyWith<$Res> {
  factory _$$ButtonPressedImplCopyWith(
          _$ButtonPressedImpl value, $Res Function(_$ButtonPressedImpl) then) =
      __$$ButtonPressedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ButtonPressedImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonEventCopyWithImpl<$Res, _$ButtonPressedImpl>
    implements _$$ButtonPressedImplCopyWith<$Res> {
  __$$ButtonPressedImplCopyWithImpl(
      _$ButtonPressedImpl _value, $Res Function(_$ButtonPressedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ButtonPressedImpl implements ButtonPressed {
  const _$ButtonPressedImpl();

  @override
  String toString() {
    return 'FloatingActionButtonEvent.buttonPressed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ButtonPressedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() buttonPressed,
    required TResult Function(String title) menuItemPressed,
  }) {
    return buttonPressed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? buttonPressed,
    TResult? Function(String title)? menuItemPressed,
  }) {
    return buttonPressed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? buttonPressed,
    TResult Function(String title)? menuItemPressed,
    required TResult orElse(),
  }) {
    if (buttonPressed != null) {
      return buttonPressed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ButtonPressed value) buttonPressed,
    required TResult Function(MenuItemPressed value) menuItemPressed,
  }) {
    return buttonPressed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ButtonPressed value)? buttonPressed,
    TResult? Function(MenuItemPressed value)? menuItemPressed,
  }) {
    return buttonPressed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ButtonPressed value)? buttonPressed,
    TResult Function(MenuItemPressed value)? menuItemPressed,
    required TResult orElse(),
  }) {
    if (buttonPressed != null) {
      return buttonPressed(this);
    }
    return orElse();
  }
}

abstract class ButtonPressed implements FloatingActionButtonEvent {
  const factory ButtonPressed() = _$ButtonPressedImpl;
}

/// @nodoc
abstract class _$$MenuItemPressedImplCopyWith<$Res> {
  factory _$$MenuItemPressedImplCopyWith(_$MenuItemPressedImpl value,
          $Res Function(_$MenuItemPressedImpl) then) =
      __$$MenuItemPressedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$$MenuItemPressedImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonEventCopyWithImpl<$Res, _$MenuItemPressedImpl>
    implements _$$MenuItemPressedImplCopyWith<$Res> {
  __$$MenuItemPressedImplCopyWithImpl(
      _$MenuItemPressedImpl _value, $Res Function(_$MenuItemPressedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_$MenuItemPressedImpl(
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MenuItemPressedImpl implements MenuItemPressed {
  const _$MenuItemPressedImpl(this.title);

  @override
  final String title;

  @override
  String toString() {
    return 'FloatingActionButtonEvent.menuItemPressed(title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuItemPressedImpl &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuItemPressedImplCopyWith<_$MenuItemPressedImpl> get copyWith =>
      __$$MenuItemPressedImplCopyWithImpl<_$MenuItemPressedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() buttonPressed,
    required TResult Function(String title) menuItemPressed,
  }) {
    return menuItemPressed(title);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? buttonPressed,
    TResult? Function(String title)? menuItemPressed,
  }) {
    return menuItemPressed?.call(title);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? buttonPressed,
    TResult Function(String title)? menuItemPressed,
    required TResult orElse(),
  }) {
    if (menuItemPressed != null) {
      return menuItemPressed(title);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ButtonPressed value) buttonPressed,
    required TResult Function(MenuItemPressed value) menuItemPressed,
  }) {
    return menuItemPressed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ButtonPressed value)? buttonPressed,
    TResult? Function(MenuItemPressed value)? menuItemPressed,
  }) {
    return menuItemPressed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ButtonPressed value)? buttonPressed,
    TResult Function(MenuItemPressed value)? menuItemPressed,
    required TResult orElse(),
  }) {
    if (menuItemPressed != null) {
      return menuItemPressed(this);
    }
    return orElse();
  }
}

abstract class MenuItemPressed implements FloatingActionButtonEvent {
  const factory MenuItemPressed(final String title) = _$MenuItemPressedImpl;

  String get title;
  @JsonKey(ignore: true)
  _$$MenuItemPressedImplCopyWith<_$MenuItemPressedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FloatingActionButtonState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() closed,
    required TResult Function() opening,
    required TResult Function(String? selectedMenuItem) opened,
    required TResult Function() closing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? closed,
    TResult? Function()? opening,
    TResult? Function(String? selectedMenuItem)? opened,
    TResult? Function()? closing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    TResult Function()? opening,
    TResult Function(String? selectedMenuItem)? opened,
    TResult Function()? closing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Closed value) closed,
    required TResult Function(Opening value) opening,
    required TResult Function(Opened value) opened,
    required TResult Function(Closing value) closing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Closed value)? closed,
    TResult? Function(Opening value)? opening,
    TResult? Function(Opened value)? opened,
    TResult? Function(Closing value)? closing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Closed value)? closed,
    TResult Function(Opening value)? opening,
    TResult Function(Opened value)? opened,
    TResult Function(Closing value)? closing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloatingActionButtonStateCopyWith<$Res> {
  factory $FloatingActionButtonStateCopyWith(FloatingActionButtonState value,
          $Res Function(FloatingActionButtonState) then) =
      _$FloatingActionButtonStateCopyWithImpl<$Res, FloatingActionButtonState>;
}

/// @nodoc
class _$FloatingActionButtonStateCopyWithImpl<$Res,
        $Val extends FloatingActionButtonState>
    implements $FloatingActionButtonStateCopyWith<$Res> {
  _$FloatingActionButtonStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ClosedImplCopyWith<$Res> {
  factory _$$ClosedImplCopyWith(
          _$ClosedImpl value, $Res Function(_$ClosedImpl) then) =
      __$$ClosedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClosedImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonStateCopyWithImpl<$Res, _$ClosedImpl>
    implements _$$ClosedImplCopyWith<$Res> {
  __$$ClosedImplCopyWithImpl(
      _$ClosedImpl _value, $Res Function(_$ClosedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClosedImpl implements Closed {
  const _$ClosedImpl();

  @override
  String toString() {
    return 'FloatingActionButtonState.closed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClosedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() closed,
    required TResult Function() opening,
    required TResult Function(String? selectedMenuItem) opened,
    required TResult Function() closing,
  }) {
    return closed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? closed,
    TResult? Function()? opening,
    TResult? Function(String? selectedMenuItem)? opened,
    TResult? Function()? closing,
  }) {
    return closed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    TResult Function()? opening,
    TResult Function(String? selectedMenuItem)? opened,
    TResult Function()? closing,
    required TResult orElse(),
  }) {
    if (closed != null) {
      return closed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Closed value) closed,
    required TResult Function(Opening value) opening,
    required TResult Function(Opened value) opened,
    required TResult Function(Closing value) closing,
  }) {
    return closed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Closed value)? closed,
    TResult? Function(Opening value)? opening,
    TResult? Function(Opened value)? opened,
    TResult? Function(Closing value)? closing,
  }) {
    return closed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Closed value)? closed,
    TResult Function(Opening value)? opening,
    TResult Function(Opened value)? opened,
    TResult Function(Closing value)? closing,
    required TResult orElse(),
  }) {
    if (closed != null) {
      return closed(this);
    }
    return orElse();
  }
}

abstract class Closed implements FloatingActionButtonState {
  const factory Closed() = _$ClosedImpl;
}

/// @nodoc
abstract class _$$OpeningImplCopyWith<$Res> {
  factory _$$OpeningImplCopyWith(
          _$OpeningImpl value, $Res Function(_$OpeningImpl) then) =
      __$$OpeningImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OpeningImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonStateCopyWithImpl<$Res, _$OpeningImpl>
    implements _$$OpeningImplCopyWith<$Res> {
  __$$OpeningImplCopyWithImpl(
      _$OpeningImpl _value, $Res Function(_$OpeningImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OpeningImpl implements Opening {
  const _$OpeningImpl();

  @override
  String toString() {
    return 'FloatingActionButtonState.opening()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OpeningImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() closed,
    required TResult Function() opening,
    required TResult Function(String? selectedMenuItem) opened,
    required TResult Function() closing,
  }) {
    return opening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? closed,
    TResult? Function()? opening,
    TResult? Function(String? selectedMenuItem)? opened,
    TResult? Function()? closing,
  }) {
    return opening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    TResult Function()? opening,
    TResult Function(String? selectedMenuItem)? opened,
    TResult Function()? closing,
    required TResult orElse(),
  }) {
    if (opening != null) {
      return opening();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Closed value) closed,
    required TResult Function(Opening value) opening,
    required TResult Function(Opened value) opened,
    required TResult Function(Closing value) closing,
  }) {
    return opening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Closed value)? closed,
    TResult? Function(Opening value)? opening,
    TResult? Function(Opened value)? opened,
    TResult? Function(Closing value)? closing,
  }) {
    return opening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Closed value)? closed,
    TResult Function(Opening value)? opening,
    TResult Function(Opened value)? opened,
    TResult Function(Closing value)? closing,
    required TResult orElse(),
  }) {
    if (opening != null) {
      return opening(this);
    }
    return orElse();
  }
}

abstract class Opening implements FloatingActionButtonState {
  const factory Opening() = _$OpeningImpl;
}

/// @nodoc
abstract class _$$OpenedImplCopyWith<$Res> {
  factory _$$OpenedImplCopyWith(
          _$OpenedImpl value, $Res Function(_$OpenedImpl) then) =
      __$$OpenedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? selectedMenuItem});
}

/// @nodoc
class __$$OpenedImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonStateCopyWithImpl<$Res, _$OpenedImpl>
    implements _$$OpenedImplCopyWith<$Res> {
  __$$OpenedImplCopyWithImpl(
      _$OpenedImpl _value, $Res Function(_$OpenedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMenuItem = freezed,
  }) {
    return _then(_$OpenedImpl(
      selectedMenuItem: freezed == selectedMenuItem
          ? _value.selectedMenuItem
          : selectedMenuItem // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OpenedImpl implements Opened {
  const _$OpenedImpl({this.selectedMenuItem});

  @override
  final String? selectedMenuItem;

  @override
  String toString() {
    return 'FloatingActionButtonState.opened(selectedMenuItem: $selectedMenuItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenedImpl &&
            (identical(other.selectedMenuItem, selectedMenuItem) ||
                other.selectedMenuItem == selectedMenuItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedMenuItem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenedImplCopyWith<_$OpenedImpl> get copyWith =>
      __$$OpenedImplCopyWithImpl<_$OpenedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() closed,
    required TResult Function() opening,
    required TResult Function(String? selectedMenuItem) opened,
    required TResult Function() closing,
  }) {
    return opened(selectedMenuItem);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? closed,
    TResult? Function()? opening,
    TResult? Function(String? selectedMenuItem)? opened,
    TResult? Function()? closing,
  }) {
    return opened?.call(selectedMenuItem);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    TResult Function()? opening,
    TResult Function(String? selectedMenuItem)? opened,
    TResult Function()? closing,
    required TResult orElse(),
  }) {
    if (opened != null) {
      return opened(selectedMenuItem);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Closed value) closed,
    required TResult Function(Opening value) opening,
    required TResult Function(Opened value) opened,
    required TResult Function(Closing value) closing,
  }) {
    return opened(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Closed value)? closed,
    TResult? Function(Opening value)? opening,
    TResult? Function(Opened value)? opened,
    TResult? Function(Closing value)? closing,
  }) {
    return opened?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Closed value)? closed,
    TResult Function(Opening value)? opening,
    TResult Function(Opened value)? opened,
    TResult Function(Closing value)? closing,
    required TResult orElse(),
  }) {
    if (opened != null) {
      return opened(this);
    }
    return orElse();
  }
}

abstract class Opened implements FloatingActionButtonState {
  const factory Opened({final String? selectedMenuItem}) = _$OpenedImpl;

  String? get selectedMenuItem;
  @JsonKey(ignore: true)
  _$$OpenedImplCopyWith<_$OpenedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClosingImplCopyWith<$Res> {
  factory _$$ClosingImplCopyWith(
          _$ClosingImpl value, $Res Function(_$ClosingImpl) then) =
      __$$ClosingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClosingImplCopyWithImpl<$Res>
    extends _$FloatingActionButtonStateCopyWithImpl<$Res, _$ClosingImpl>
    implements _$$ClosingImplCopyWith<$Res> {
  __$$ClosingImplCopyWithImpl(
      _$ClosingImpl _value, $Res Function(_$ClosingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClosingImpl implements Closing {
  const _$ClosingImpl();

  @override
  String toString() {
    return 'FloatingActionButtonState.closing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClosingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() closed,
    required TResult Function() opening,
    required TResult Function(String? selectedMenuItem) opened,
    required TResult Function() closing,
  }) {
    return closing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? closed,
    TResult? Function()? opening,
    TResult? Function(String? selectedMenuItem)? opened,
    TResult? Function()? closing,
  }) {
    return closing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? closed,
    TResult Function()? opening,
    TResult Function(String? selectedMenuItem)? opened,
    TResult Function()? closing,
    required TResult orElse(),
  }) {
    if (closing != null) {
      return closing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Closed value) closed,
    required TResult Function(Opening value) opening,
    required TResult Function(Opened value) opened,
    required TResult Function(Closing value) closing,
  }) {
    return closing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Closed value)? closed,
    TResult? Function(Opening value)? opening,
    TResult? Function(Opened value)? opened,
    TResult? Function(Closing value)? closing,
  }) {
    return closing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Closed value)? closed,
    TResult Function(Opening value)? opening,
    TResult Function(Opened value)? opened,
    TResult Function(Closing value)? closing,
    required TResult orElse(),
  }) {
    if (closing != null) {
      return closing(this);
    }
    return orElse();
  }
}

abstract class Closing implements FloatingActionButtonState {
  const factory Closing() = _$ClosingImpl;
}
