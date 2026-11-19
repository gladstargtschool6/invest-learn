import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusinessGrowthPlanScreen extends StatefulWidget {
  const BusinessGrowthPlanScreen({super.key});
  @override State<BusinessGrowthPlanScreen> createState() => _BusinessGrowthPlanScreenState();
}

class _BusinessGrowthPlanScreenState extends State<BusinessGrowthPlanScreen> {
  final formKey = GlobalKey<FormState>();
  final business = TextEditingController();
  final currentRevenue = TextEditingController();
  final targetRevenue = TextEditingController();
  final challenge = TextEditingController();
  final customer = TextEditingController();
  String stage = 'Startup';
  bool loading = false;
  Map<String, dynamic>? plan;

  @override void dispose() { business.dispose(); currentRevenue.dispose(); targetRevenue.dispose(); challenge.dispose(); customer.dispose(); super.dispose(); }

  Future<void> generate() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final endpoint = const String.fromEnvironment('GROWTH_PLAN_ENDPOINT', defaultValue: '');
    try {
      if (endpoint.isNotEmpty) {
        final response = await http.post(Uri.parse(endpoint), headers: {'content-type': 'application/json'}, body: jsonEncode({'businessName': business.text.trim(), 'currentRevenue': currentRevenue.text.trim(), 'targetRevenue': targetRevenue.text.trim(), 'businessStage': stage, 'growthConstraint': challenge.text.trim(), 'customerSegment': customer.text.trim(), 'horizonDays': 90}));
        if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('The coaching service could not generate a plan.');
        plan = jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        plan = {'summary': 'Focus on one customer segment, one repeatable acquisition channel, and a measurable 90-day revenue target.', 'priorities': ['Clarify your ideal customer', 'Validate demand with five customer conversations', 'Build a weekly sales and cash-flow review'], 'actions': ['Interview five target customers', 'Test one value proposition', 'Track leads, conversion rate, revenue, and cash collected'], 'milestones': ['Days 1–30: validate the problem', 'Days 31–60: improve conversion', 'Days 61–90: document and scale what works']};
      }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
    if (mounted) setState(() => loading = false);
  }

  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('AI Business Growth Plan')), body: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Turn your coaching goals into a practical 90-day growth plan.'), const SizedBox(height: 16),
    Form(key: formKey, child: Column(children: [
      _field(business, 'Business name'), _field(currentRevenue, 'Current monthly revenue'), _field(targetRevenue, 'Target monthly revenue'),
      DropdownButtonFormField(value: stage, decoration: const InputDecoration(labelText: 'Business stage', border: OutlineInputBorder()), items: ['Idea', 'Startup', 'Growing', 'Established'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => stage = v!)),
      const SizedBox(height: 12), _field(customer, 'Ideal customer or target market'), _field(challenge, 'Biggest growth constraint', lines: 3),
      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: loading ? null : generate, icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome), label: Text(loading ? 'Building plan...' : 'Generate growth plan'))),
    ])),
    if (plan != null) ...plan!.entries.where((e) => e.value is String || e.value is List).map((entry) => Card(margin: const EdgeInsets.only(top: 12), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(entry.value is List ? (entry.value as List).map((v) => '• $v').join('\n') : '${entry.value}')]))))],
  ));

  Widget _field(TextEditingController c, String label, {int lines = 1}) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: c, maxLines: lines, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())));
}
