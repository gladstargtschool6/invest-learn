import 'package:flutter/material.dart';
import 'assessment_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool teacherMode = false;

  final sample = List.generate(
    3,
    (i) => Assessment(
      timestamp: DateTime.now().subtract(Duration(days: i)),
      prompt: 'Student idea #$i: Start a school store selling handmade goods',
      coaching: '1) Talk to 10 students; 2) Price items; 3) Trial for 1 week; 4) Iterate based on feedback',
      score: 60 + i * 5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assessment Widget Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Assessments Demo'),
          actions: [
            Row(
              children: [
                const Text('Teacher'),
                Switch(
                  value: teacherMode,
                  onChanged: (v) => setState(() => teacherMode = v),
                ),
              ],
            )
          ],
        ),
        body: AssessmentListWidget(
          assessments: sample,
          teacherMode: teacherMode,
        ),
      ),
    );
  }
}
