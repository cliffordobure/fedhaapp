import 'package:flutter/material.dart';
import 'dart:math';

class DottedCirclePainter extends CustomPainter {
  final double progress;

  DottedCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    const int numberOfDots = 12; // Number of dots around the circle

    for (int i = 0; i < numberOfDots; i++) {
      final double angle = (i / numberOfDots) * 2 * pi + progress * 2 * pi;
      final double x = radius + radius * cos(angle);
      final double y = radius + radius * sin(angle);
      final double dotRadius = 4 - (i * 0.5); // Adjust size of dots

      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LogoLoader extends StatefulWidget {
  const LogoLoader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogoLoaderState createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 45,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: DottedCirclePainter(progress: _controller.value),
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset('assets/Images/ic_launcher.png'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: LogoLoader(),
    ),
  ));
}
