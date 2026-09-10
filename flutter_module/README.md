Flutter module included in repo

What I added:
- flutter_module/ (a complete Flutter app that will be used as the embedded UI)
  - pubspec.yaml (http + share_plus, assets entry)
  - lib/main.dart (tabs: Assessments, Weather, Courses)
  - lib/assessment_widget.dart (AssessmentListWidget + CSV export)
  - lib/weather_dashboard.dart (Open-Meteo integration)
  - lib/courses_screen.dart (loads assets/courses.json)
  - assets/courses.json (sample MERLOT-derived entries)

Integration notes (how to embed into the Android app):
1) This folder is a standalone Flutter app. To build and use it as an add-to-app module, there are two common approaches:
   - Approach A (recommended): Convert this folder into a Flutter module using the Flutter tooling on your machine, then follow the official "Add Flutter to existing app" guide: https://flutter.dev/docs/development/add-to-app
   - Approach B: Keep it as a standalone Flutter app and launch it separately from the Android app (less integrated).

2) Steps to embed (high level):
   - On your machine run inside flutter_module:
       flutter pub get
   - Create a Flutter module (if you prefer the flutter tooling generated layout):
       flutter create -t module flutter_module
     (If you run the above, merge the lib/ and assets/ into the generated module; the tooling will scaffold the android/ and ios/ folders required for Gradle integration.)
   - Follow the guide to add the module to the Android project (modify settings.gradle and add implementation project(':flutter') or use the Flutter Gradle helper). This requires a local Flutter SDK.
   - Implement a MethodChannel to pass real assessments.json and courses.json from the Android host to the Flutter module. The Flutter side already expects courses.json as an asset; for dynamic data you can implement a channel handler that returns a JSON string when Flutter calls 'getAssessmentsJson' or 'getCoursesJson'.

Notes:
- Weather integration uses Open-Meteo (no API key). The WeatherDashboard widget uses the free geocoding and forecast endpoints.
- The courses.json file included is a small sample; I can expand it by scraping the MERLOT page you provided and include the full metadata if you confirm you'd like me to replace the sample with the scraped results.

Next steps I can take now (pick one):
- A: Convert this folder into a proper Flutter module (run flutter create -t module), merge files, and update Android Gradle files in this repo so the module is fully embedded and the Android app can launch the FlutterActivity. (Requires Flutter SDK on the machine where builds happen.)
- B: Leave the module as-is and provide step-by-step patch files / commands you can run locally to embed it.
- C: Scrape the MERLOT page and populate assets/courses.json with the full list of entries.

Which do you want me to do next?