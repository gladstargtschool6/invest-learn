import 'package:flutter/material.dart';
import 'business_growth_screen.dart';
import 'coaching_shell.dart';

void main() => runApp(const InvestLearnApp());

class InvestLearnApp extends StatelessWidget {
  const InvestLearnApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Invest Learn AI Coach',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14532d)), useMaterial3: true, scaffoldBackgroundColor: const Color(0xfff5f7f6)),
    home: const CoachingEntryPoint(),
  );
}

class CoachingEntryPoint extends StatelessWidget {
  const CoachingEntryPoint({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Entrepreneurship & Leadership Coach'), actions: [IconButton(tooltip: 'Business growth plan', icon: const Icon(Icons.trending_up), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessGrowthPlanScreen())))]),
    body: Column(children: [
      MaterialBanner(content: const Text('Build a practical plan from your coaching goals and business constraints.'), leading: const Icon(Icons.auto_awesome), actions: [TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessGrowthPlanScreen())), child: const Text('GROWTH PLAN'))]),
      const Expanded(child: CoachingShell()),
    ]),
  );
}
