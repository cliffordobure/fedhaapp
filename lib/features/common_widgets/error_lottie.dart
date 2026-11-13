import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieError extends StatefulWidget {
  const LottieError({super.key, required this.message});
  final String message;

  @override
  State<LottieError> createState() => _LottieErrorState();
}

class _LottieErrorState extends State<LottieError>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/loading.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
            controller: _controller,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
          Text(widget.message)
        ],
      ),
    );
  }
}
