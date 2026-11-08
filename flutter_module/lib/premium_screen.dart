import 'package:flutter/material.dart';
import 'premium_service.dart';

class PremiumScreen extends StatelessWidget {
  final PremiumService service;
  const PremiumScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: service, builder: (context, _) {
    final annual = service.annual;
    final monthly = service.monthly;
    return Scaffold(appBar: AppBar(title: const Text('Premium AI Coaching')), body: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Unlock Your AI Business & Leadership Coach', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      const Text('Move from your current level to your desired level with practical, personalized coaching.'),
      const SizedBox(height: 20),
      ...['Personalized AI coaching', 'Business growth guidance', 'Leadership development', '30/60/90-day action plans', 'Business-plan coaching', 'Leadership simulations', 'Weekly progress reviews', 'Premium courses and challenges'].map((benefit) => ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: Text(benefit))),
      const SizedBox(height: 12),
      _PlanCard(title: 'Premium Annual', fallbackPrice: '\$20/year', detail: 'Best value — less than monthly billing over a full year', product: annual, highlighted: true, service: service),
      _PlanCard(title: 'Premium Monthly', fallbackPrice: '\$2/month', detail: 'Flexible monthly billing', product: monthly, service: service),
      if (service.message != null) Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(service.message!, style: TextStyle(color: Theme.of(context).colorScheme.primary))),
      OutlinedButton(onPressed: service.restore, child: const Text('Restore Purchase')),
      TextButton(onPressed: () {}, child: const Text('Terms of Service')), TextButton(onPressed: () {}, child: const Text('Privacy Policy')), TextButton(onPressed: () {}, child: const Text('Manage Subscription')),
      const Text('Subscriptions renew automatically unless cancelled in Google Play. Payment and cancellation are handled by Google Play. Your account entitlement is verified securely before Premium access is activated.', style: TextStyle(fontSize: 12)),
    ]));
  });
}

class _PlanCard extends StatelessWidget { final String title, fallbackPrice, detail; final dynamic product; final bool highlighted; final PremiumService service; const _PlanCard({required this.title, required this.fallbackPrice, required this.detail, required this.service, this.product, this.highlighted = false});
  @override Widget build(BuildContext context) { final price = product?.price ?? fallbackPrice; return Card(color: highlighted ? Theme.of(context).colorScheme.primaryContainer : null, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (highlighted) const Chip(label: Text('BEST VALUE')), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(detail), const SizedBox(height: 10), SizedBox(width: double.infinity, child: FilledButton(onPressed: product == null ? null : () => service.buy(product), child: const Text('Subscribe with Google Play')))]))); }
}
