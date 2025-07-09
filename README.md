# jenga_app

# Jenga App

A Flutter application built with GetX for state management and Firebase for backend services.

## Features

- **Authentication**: User registration and login with email/password
- **User Management**: Profile management and user data storage
- **Modern UI**: Clean, responsive design with dark/light theme support
- **Settings**: App preferences, language selection, and theme switching
- **Firebase Integration**: Cloud Firestore for data storage and Firebase Auth for authentication

## Architecture

- **GetX**: State management, dependency injection, and routing
- **Firebase**: Backend services (Authentication, Firestore, Storage)
- **Clean Architecture**: Separation of concerns with controllers, repositories, and providers

## Project Structure

```
lib/
├── bindings/          # GetX bindings for dependency injection
├── models/           # Data models
├── modules/          # Controllers (GetX controllers)
├── providers/        # Data providers (Firebase providers)
├── repositories/     # Data repositories
├── routes/           # App routing configuration
├── screens/          # UI screens
├── services/         # App services
├── themes/           # App themes
└── main.dart         # App entry point
```

## Setup Instructions

### 1. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication and Firestore Database
3. Configure your Firebase project:
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Login to Firebase: `firebase login`
   - Configure FlutterFire: `flutterfire configure`
   - This will automatically update `lib/firebase_options.dart`

### 2. Run the App

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project configuration after running `flutterfire configure`.

## App Screens

1. **Splash Screen**: Loading screen with app branding
2. **Login Screen**: User authentication
3. **Register Screen**: User registration
4. **Home Screen**: Main dashboard with tabs
5. **Profile Screen**: User profile management
6. **Settings Screen**: App preferences and settings

## Dependencies

- `get: ^4.6.6` - State management and routing
- `firebase_core: ^2.24.2` - Firebase core functionality
- `firebase_auth: ^4.15.3` - Firebase authentication
- `cloud_firestore: ^4.13.6` - Firestore database
- `firebase_storage: ^11.6.0` - Firebase storage
- `shared_preferences: ^2.2.2` - Local storage
- `cached_network_image: ^3.3.0` - Image caching
- `image_picker: ^1.0.4` - Image selection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
