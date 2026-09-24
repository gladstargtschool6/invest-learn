import 'package:flutter/material.dart';
import 'business_growth_screen.dart';
import 'coaching_shell.dart';
import 'premium_screen.dart';
import 'premium_service.dart';

void main() => runApp(const InvestLearnApp());

class InvestLearnApp extends StatefulWidget {
  const InvestLearnApp({super.key});
  @override State<InvestLearnApp> createState() => _InvestLearnAppState();
}

class _InvestLearnAppState extends State<InvestLearnApp> {
  final premium = PremiumService();
  @override void dispose() { premium.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Invest Learn AI Coach',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14532d)), useMaterial3: true, scaffoldBackgroundColor: const Color(0xfff5f7f6)),
    home: CoachingEntryPoint(premium: premium),
  );
}

class CoachingEntryPoint extends StatelessWidget {
  final PremiumService premium;
  const CoachingEntryPoint({super.key, required this.premium});

  void openGrowthPlan(BuildContext context) {
    if (premium.state == EntitlementState.premiumActive) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessGrowthPlanScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(service: premium)));
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Entrepreneurship & Leadership Coach'), actions: [IconButton(tooltip: 'Premium growth plan', icon: const Icon(Icons.trending_up), onPressed: () => openGrowthPlan(context))]),
    body: Column(children: [
      MaterialBanner(content: const Text('AI Business Growth Plan is a Premium feature.'), leading: const Icon(Icons.workspace_premium), actions: [TextButton(onPressed: () => openGrowthPlan(context), child: const Text('VIEW PREMIUM'))]),
      const Expanded(child: CoachingShell()),
    ]),
  );
}
