import 'package:flutter/material.dart';

class PremiumCoachingDashboard extends StatelessWidget {
  const PremiumCoachingDashboard({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Personalized Coaching Dashboard')), body: ListView(padding: const EdgeInsets.all(20), children: [
    Card(color: Theme.of(context).colorScheme.primary, child: const Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('YOUR PREMIUM COACHING', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Grow revenue while building leadership capacity.', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('Your plan adapts to your goals, completed actions, and development areas.', style: TextStyle(color: Colors.white))]))),
    _metric('Coaching plan progress', .42), _metric('Entrepreneurship development', .56), _metric('Leadership development', .38),
    const SizedBox(height: 12), const Text('Today\'s personalized actions', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    const _Action(title: 'Business action', detail: 'Review your last 30 days of customer acquisition costs.'), const _Action(title: 'Leadership action', detail: 'Delegate one clearly defined task and agree on its success criteria.'), const _Action(title: 'Reflection', detail: 'What assumption is currently limiting your next growth decision?'),
  ]));
  static Widget _metric(String title, double value) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), const SizedBox(height: 8), LinearProgressIndicator(value: value), const SizedBox(height: 4), Text('${(value * 100).round()}% complete')]));
}
class _Action extends StatelessWidget { final String title, detail; const _Action({required this.title, required this.detail}); @override Widget build(BuildContext context) => Card(child: ListTile(leading: const Icon(Icons.task_alt), title: Text(title), subtitle: Text(detail), trailing: const Icon(Icons.chevron_right))); }
