Flutter Assessment Widget

This directory contains a small standalone Flutter widget and demo app that displays assessments (prompt, coaching, score, timestamp) and allows teachers to export them as CSV using the platform share dialog.

How to run
1. Install Flutter (https://flutter.dev) and ensure flutter is on your PATH.
2. From this folder, run:
   flutter pub get
   flutter run

Files
- lib/assessment_widget.dart - The reusable widget (Assessment model + AssessmentListWidget)
- lib/main.dart - Small demo app showing usage
- pubspec.yaml - Flutter package configuration

Notes
- The demo uses share_plus for sharing CSV. If you run on Android, ensure an emulator/device is available.
- This widget is standalone — integrate `AssessmentListWidget` into your existing Flutter app by copying the file and adapting data sources.
