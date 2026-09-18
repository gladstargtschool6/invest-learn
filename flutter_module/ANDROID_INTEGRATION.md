# Flutter add-to-app integration

The repository contains the Flutter source in `flutter_module/`. The generated `.android/` directory is intentionally not committed because it is produced by the Flutter SDK.

From the repository root on a machine with Flutter installed:

```bash
cd flutter_module
flutter create --template module --org com.gladstargtschool6 --project-name invest_learn .
flutter pub get
cd ..
./gradlew :app:assembleDebug
```

The existing `lib/`, `assets/`, and `pubspec.yaml` are preserved when generating the module. If Flutter asks to overwrite files, keep the repository versions of those files, then run `flutter pub get` again.

`settings.gradle` automatically applies `flutter_module/.android/include_flutter.groovy` when it exists, and `app/build.gradle` adds the generated `:flutter` project. The Assessments button launches `FlutterActivity`; before generation it falls back to the native assessments screen.

The Flutter module includes:

- Assessments with teacher-only CSV export UI.
- Weather dashboard using Open-Meteo (no API key).
- Courses loaded from `assets/courses.json`.

For real host data, add a `MethodChannel` after module generation. The current Flutter demo uses sample assessments and bundled course data; no generated Flutter files or machine-specific paths are committed.
