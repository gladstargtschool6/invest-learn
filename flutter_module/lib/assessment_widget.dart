import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Assessment {
  final DateTime timestamp;
  final String prompt;
  final String coaching;
  final int score;

  Assessment({
    required this.timestamp,
    required this.prompt,
    required this.coaching,
    required this.score,
  });

  String toCsvRow() {
    final ts = timestamp.toIso8601String();
    String esc(String s) => '"' + s.replaceAll('"', '""') + '"';
    return '${esc(ts)},${esc(prompt)},${esc(coaching)},$score';
  }
}

class AssessmentListWidget extends StatelessWidget {
  final List<Assessment> assessments;
  final bool teacherMode; // if true, show export button

  const AssessmentListWidget({
    Key? key,
    required this.assessments,
    this.teacherMode = false,
  }) : super(key: key);

  String buildCsv(List<Assessment> items) {
    final sb = StringBuffer();
    sb.writeln('timestamp,prompt,coaching,score');
    for (final a in items) {
      sb.writeln(a.toCsvRow());
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: assessments.isEmpty
              ? const Center(child: Text('No assessments yet'))
              : ListView.builder(
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final a = assessments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.prompt,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text('Score: ${a.score}'),
                            const SizedBox(height: 6),
                            Text(a.coaching),
                            const SizedBox(height: 8),
                            Text(
                              a.timestamp.toLocal().toString(),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (teacherMode)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Export as CSV'),
              onPressed: assessments.isEmpty
                  ? null
                  : () {
                      final csv = buildCsv(assessments);
                      Share.share(csv, subject: 'Assessments Export');
                    },
            ),
          ),
      ],
    );
  }
}
