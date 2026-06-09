// main.dart

import 'package:flutter/material.dart';
import 'package:campus_trace/frontend/screens/home/splash_loading_screen.dart';

void main() {
  runApp(const CampusTraceApp());
}

class CampusTraceApp extends StatelessWidget {
  const CampusTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusTrace',
      home: const SplashLoadingScreen(),
    );
  }
}
