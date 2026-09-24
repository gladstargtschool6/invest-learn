import 'package:flutter/material.dart';

class PremiumCertificatesScreen extends StatelessWidget {
  const PremiumCertificatesScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Certificates & Achievements')), body: ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Complete premium learning requirements to earn verified certificates.', style: TextStyle(fontSize: 16)), const SizedBox(height: 16),
    _certificate('Entrepreneurship Fundamentals', 'Complete the required lessons and final assessment.'),
    _certificate('Business Planning', 'Complete your business plan and pass the assessment.'),
    _certificate('Strategic Leadership', 'Complete the leadership path and final review.'),
    const SizedBox(height: 12), const Text('Certificates are issued after server-side completion and score verification. Your certificate number and completion date are stored with your account.', style: TextStyle(fontSize: 12)),
  ]));
  static Widget _certificate(String title, String detail) => Card(child: ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: Text(title), subtitle: Text(detail), trailing: const Icon(Icons.lock_outline)));
}
