import 'package:fedha/features/app/cubits/video-cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  const Video._(
    this.url, {
    Key? key,
    required this.aspectRatio,
  }) : super(key: key);

  static Widget blocProvider(
    String url, {
    required double aspectRatio,
  }) {
    return BlocProvider(
      create: (_) {
        return VideoCubit(url);
      },
      child: Video._(
        url,
        aspectRatio: aspectRatio,
      ),
    );
  }

  final String url;
  final double aspectRatio;

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (_, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: AspectRatio(
            key: ValueKey(state.loaded),
            aspectRatio: widget.aspectRatio,
            child: state.notLoaded
                ? const Center(child: CircularProgressIndicator())
                : VideoPlayer(state.controller),
          ),
        );
      },
    );
  }
}

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String? videoUrl;

//   const VideoPlayerWidget({Key? key, this.videoUrl}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late ChewieController chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
//     _controller.initialize().then((_) => setState(() {}));
//     chewieController = ChewieController(
//       videoPlayerController: _controller,
//       autoPlay: true,
//       looping: false,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: Chewie(
//               controller: chewieController,
//             ),
//           )
//         : Container(
//             color: Colors.black,
//             child: const Center(child: CircularProgressIndicator()),
//           );
//   }
// }
