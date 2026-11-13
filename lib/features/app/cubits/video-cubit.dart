import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoState {
  VideoState._({
    required this.controller,
    required this.loaded,
  });
  factory VideoState.initialize({
    required String url,
  }) {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    return VideoState._(controller: controller, loaded: false);
  }
  final VideoPlayerController controller;
  final bool loaded;

  bool get notLoaded => !loaded;

  VideoState copyWith({
    VideoPlayerController? controller,
    bool? loaded,
  }) {
    return VideoState._(
      controller: controller ?? this.controller,
      loaded: loaded ?? this.loaded,
    );
  }

  Future<void> dispose() async {
    controller.dispose();
  }
}

class VideoCubit extends Cubit<VideoState> {
  VideoCubit(
    String url, {
    bool autoPlay = true,
  }) : super(VideoState.initialize(
          url: url,
        )) {
    // if (state.controller.value.isInitialized) {
    //   state.controller.dispose();
    // }
    state.controller.initialize().then((_) {
      emit(state.copyWith(
        loaded: true,
      ));
      if (autoPlay) {
        state.controller.play();
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }
}
