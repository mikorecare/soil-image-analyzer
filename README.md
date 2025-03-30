# soil-image-analyzer
An app who can determine the texture, composition, and soil color through image only. 
=======
# soil_app

# Flutter Project Setup Guide

## Prerequisites

Ensure you have the following installed:

- **Flutter SDK** (Follow the [official installation guide](https://flutter.dev/docs/get-started/install))
- **Dart SDK** (Included with Flutter)
- **Android Studio** or **Visual Studio Code** (for development)
- **Git** (Version Control System)
- **Android Emulator** or **Physical Device** (for testing)

## 🚀 Clone the Project Repository

```bash
git clone https://github.com/your-repo/soil-image-analyzer.git
cd soil-image-analyzer

📦 Install Dependencies
flutter pub get

⚙️ Configure Android
Open the android/app/build.gradle file and ensure the minSdkVersion is set to a compatible version:
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21  // Set this to your required minimum SDK version
        ...
    }
}

🌐 Run the Application
flutter run

🎨 Build for Release
flutter build apk  # For Android
flutter build ios  # For iOS

🛠️ Troubleshooting
Flutter Doctor: Run flutter doctor to check your setup for any issues and follow the recommended fixes.

Dependency Issues: If you encounter any dependency issues, try running:
flutter pub get

Hot Reload Not Working: Ensure your emulator is running and connected. Use flutter run to start the app and then save your changes for hot reload.
