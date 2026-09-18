import 'package:flutter/material.dart';
import 'coaching_shell.dart';

void main() {
  runApp(const InvestLearnApp());
}

class InvestLearnApp extends StatelessWidget {
  const InvestLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invest Learn Coaching',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14532d)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff7faf8),
      ),
      home: const CoachingShell(),
    );
  }
}
