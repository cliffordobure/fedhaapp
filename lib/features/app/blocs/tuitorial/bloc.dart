import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:fedha/constants/global_keys.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/localization/app_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part "state.dart";
part 'event.dart';

class TuitorialBloc extends Bloc<TuitorialEvent, TuitorialState> {
  TuitorialBloc() : super(const TuitorialState()) {
    List<TargetFocus> mountedTargets() {
      return createTargets().where((target) {
        final key = target.keyTarget;
        final targetContext = key?.currentContext;
        if (targetContext == null || !targetContext.mounted) return false;
        return targetContext.findRenderObject() != null;
      }).toList();
    }

    TutorialCoachMark? createTutorial() {
      final targets = mountedTargets();
      if (targets.isEmpty) return null;
      return TutorialCoachMark(
        targets: targets,
        // ignore: use_full_hex_values_for_flutter_colors
        colorShadow: const Color(0xff0000000),
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.4,
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        onFinish: () async {
          logger.info("finish");
          var prefs = service<AppPreferences>();
          prefs.shownTutorial();
        },
        onClickTarget: (target) {
          logger.info('onClickTarget: $target');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          logger.info("target: $target");
          logger.info(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        // onClickOverlay: (target) {
        //   tutorialCoachMark.next();
        //   logger.info('onClickOverlay: $target');
        // },
        onSkip: () {
          logger.info("skip");
          var prefs = service<AppPreferences>();
          prefs.shownTutorial();
          return true;
        },
      );
    }

    on<ReShowTuitorialEvent>((event, emit) {
      emit(state.copyWith(startTutorial: true));
      logger.info("the current state is : ${state.startTutorial}");
      // add(ShowTuitorialEvent(context: event.context, force: true));
    });

    on<CheckTuitorialEvent>((event, emit) async {
      if (!event.context.mounted) return;

      final bool hasSeenTuitorial =
          await service<AppPreferences>().hasSeenTuitorial();
      if (!hasSeenTuitorial && event.context.mounted) {
        add(ShowTuitorialEvent(context: event.context, force: false));
      }
    });

    on<ShowTuitorialEvent>((event, emit) async {
      if (!event.context.mounted) return;

      final tutorial = (event.force || state.tuitorialCoachMark == null)
          ? createTutorial()
          : state.tuitorialCoachMark;
      if (tutorial == null) return;

      emit(state.copyWith(
        tutorialCoachMark: tutorial,
        startTutorial: false,
      ));
      tutorial.show(context: event.context);

      if (!event.force) {
        service<AppPreferences>().shownTutorial();
      }
    });
  }
}

// Create event
