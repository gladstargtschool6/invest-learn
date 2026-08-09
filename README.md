Firebase setup

I added Firebase Authentication support (Email/Password) and simple login/signup UI.

What I changed
- Added Firebase BOM & Auth dependency to app/build.gradle and applied Google services plugin.
- Added LoginActivity and SignupActivity (Kotlin) with corresponding layouts.
- Updated AndroidManifest to make LoginActivity the launcher activity.

What you must do locally
1. Create a Firebase project at https://console.firebase.google.com and enable Email/Password sign-in under Authentication > Sign-in method.
2. Add an Android app in the Firebase console and register the package name com.gladstargtschool6.investlearn.
3. Download the generated google-services.json and place it into app/ (do NOT commit your google-services.json to public repos containing sensitive keys).
4. Open the project in Android Studio and sync Gradle. Run on a device/emulator.

Next steps I can take
- Add Google Sign-In and profile linking.
- Persist user progress to Firestore or Realtime Database.
- Add password reset and email verification flows.
- Improve UX: show progress indicators, better error handling, and field validation.
