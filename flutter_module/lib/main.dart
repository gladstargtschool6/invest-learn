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

  @override
  void dispose() {
    premium.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Invest Learn AI Coach',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14532d)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xfff5f7f6),
    ),
    home: CoachingEntryPoint(premium: premium),
  );
}

class CoachingEntryPoint extends StatelessWidget {
  final PremiumService premium;
  const CoachingEntryPoint({super.key, required this.premium});

  void openPremiumGate(BuildContext context, {required String feature}) {
    final unlocked = premium.state == EntitlementState.premiumActive;
    if (!unlocked) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(service: premium)));
      return;
    }

    switch (feature) {
      case 'growth_plan':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessGrowthPlanScreen()));
        break;
      case 'advanced_coaching':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachingShell()));
        break;
      case 'leadership_simulations':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachingShell()));
        break;
      case 'premium_library':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachingShell()));
        break;
      case 'certificates':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachingShell()));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachingShell()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Entrepreneurship & Leadership Coach'),
      actions: [
        IconButton(
          tooltip: 'Premium growth plan',
          icon: const Icon(Icons.trending_up),
          onPressed: () => openPremiumGate(context, feature: 'growth_plan'),
        ),
      ],
    ),
    body: Column(
      children: [
        MaterialBanner(
          content: const Text('AI Business Growth Plan, advanced coaching, and premium tools are available with Premium.'),
          leading: const Icon(Icons.workspace_premium),
          actions: [
            TextButton(
              onPressed: () => openPremiumGate(context, feature: 'growth_plan'),
              child: const Text('VIEW PREMIUM'),
            ),
          ],
        ),
        const Expanded(child: CoachingShell()),
      ],
    ),
  );
}
