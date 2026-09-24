import 'package:flutter/material.dart';
import 'business_growth_screen.dart';

void main() {
  runApp(const InvestLearnApp());
}

class InvestLearnApp extends StatelessWidget {
  const InvestLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invest Learn AI Coach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF14532D)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
      ),
      home: const BusinessGrowthPlanScreen(),
    );
  }
}
