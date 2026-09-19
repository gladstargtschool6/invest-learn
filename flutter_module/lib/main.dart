import 'package:flutter/material.dart';
import 'coaching_shell.dart';
import 'premium_screen.dart';
import 'premium_service.dart';

void main() => runApp(const InvestLearnApp());

class InvestLearnApp extends StatefulWidget { const InvestLearnApp({super.key}); @override State<InvestLearnApp> createState() => _InvestLearnAppState(); }
class _InvestLearnAppState extends State<InvestLearnApp> {
  final premium = PremiumService();
  @override void dispose() { premium.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => MaterialApp(title: 'Invest Learn Coaching', debugShowCheckedModeBanner: false, theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff14532d)), useMaterial3: true, scaffoldBackgroundColor: const Color(0xfff7faf8)), home: Scaffold(body: Column(children: [MaterialBanner(content: const Text('Unlock personalized business and leadership coaching'), leading: const Icon(Icons.workspace_premium), actions: [TextButton(onPressed: () {}, child: const Text('LATER')), FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(service: premium))), child: const Text('VIEW PREMIUM'))]), const Expanded(child: CoachingShell())])));
}
