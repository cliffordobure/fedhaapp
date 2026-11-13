part of 'bloc.dart';

class TuitorialState extends Equatable {
  final TutorialCoachMark? tuitorialCoachMark;
  final bool startTutorial;
  final BuildContext? context;

  const TuitorialState({
    this.context,
    this.tuitorialCoachMark,
    this.startTutorial = false,
  });

  TuitorialState copyWith({
    BuildContext? context,
    TutorialCoachMark? tutorialCoachMark,
    bool? startTutorial,
  }) {
    return TuitorialState(
      context: context ?? this.context,
      tuitorialCoachMark: tutorialCoachMark ?? tuitorialCoachMark,
      startTutorial: startTutorial ?? this.startTutorial,
    );
  }

  @override
  List<Object?> get props => [tuitorialCoachMark, startTutorial, context];
}
