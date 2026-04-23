import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/theme/app_theme.dart';
import 'config/environment.dart';
import 'features/auth/auth_gate.dart';
import 'features/splash/splash_screen.dart';

void main() {
  Environment.validate();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.showSplash = true,
    this.enableSessionRestore = true,
  });

  final bool showSplash;
  final bool enableSessionRestore;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showAppContent = false;

  @override
  void initState() {
    super.initState();
    _showAppContent = !widget.showSplash;
  }

  void _onSplashCompleted() {
    if (!mounted) {
      return;
    }

    setState(() {
      _showAppContent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sparklib',
      theme: AppTheme.light,
      home: _showAppContent
          ? AuthGate(enableSessionRestore: widget.enableSessionRestore)
          : SplashScreen(onCompleted: _onSplashCompleted),
    );
  }
}