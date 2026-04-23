import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onCompleted,
  });

  final VoidCallback onCompleted;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 4500ms = 4s (durée animation SVG) + 500ms buffer
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    // Simple fade in at start, fade out at end
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15, // 0-675ms: fade in
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 70, // 675-3825ms: hold visible (SVG plays here)
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15, // 3825-4500ms: fade out
      ),
    ]).animate(_controller);

    _controller.forward();

    // Redirection après 4.5 secondes
    _timer = Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) {
        return;
      }
      widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: SvgPicture.asset(
            'assets/branding/sparklib-logo-animated.svg',
            width: 280,
          ),
        ),
      ),
    );
  }
}
