// Flutter module main
import 'package:flutter/material.dart';
import 'assessment_widget.dart';
import 'weather_dashboard.dart';
import 'courses_screen.dart';

void main() {
  runApp(const FlutterModuleApp());
}

class FlutterModuleApp extends StatelessWidget {
  const FlutterModuleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Embedded Flutter Module',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool teacherMode = false;

  // sample assessments - in real integration these will be provided by host Android via MethodChannel
  final sampleAssessments = List.generate(
    4,
    (i) => Assessment(
      timestamp: DateTime.now().subtract(Duration(hours: i * 6)),
      prompt: 'Student idea #$i: project example',
      coaching: 'Coaching notes for student #$i',
      score: 70 + i * 5,
    ),
  );

  int _selectedIndex = 0;

  static const List<Widget> _pagesPlaceholder = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      AssessmentListWidget(assessments: sampleAssessments, teacherMode: teacherMode),
      WeatherDashboard(),
      CoursesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Embedded Flutter UI'),
        actions: [
          Row(children: [
            const Text('Teacher', style: TextStyle(fontSize: 14)),
            Switch(
              value: teacherMode,
              onChanged: (v) => setState(() => teacherMode = v),
            ),
          ])
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Assessments'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
        ],
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
