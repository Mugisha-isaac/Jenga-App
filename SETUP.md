# Firebase Console Setup Guide - Android

This guide walks you through setting up Google Sign-In and Email Authentication in the Firebase Console for the Jenga App on Android.

## Prerequisites

- Firebase project created
- Flutter app added to Firebase project as an Android app
- `google-services.json` file added to `android/app/` directory
- Android Studio or VS Code with Flutter extension installed

## 1. Enable Authentication Methods

### Step 1: Navigate to Authentication
1. Open your Firebase Console
2. Select your project
3. Click on "Authentication" in the left sidebar
4. Click on the "Sign-in method" tab

### Step 2: Enable Email/Password Authentication
1. Click on "Email/Password" provider
2. Toggle "Enable" to ON
3. Leave "Email link (passwordless sign-in)" disabled (unless needed)
4. Click "Save"

### Step 3: Enable Google Sign-In
1. Click on "Google" provider
2. Toggle "Enable" to ON
3. Enter your project's public-facing name (e.g., "Jenga App")
4. Select a support email from the dropdown
5. Click "Save"

## 2. Configure Google Sign-In for Android

### Step 1: Get SHA Certificate Fingerprint
Run this command in your project root directory:

```bash
# For debug certificate (development) - Use this for testing
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
```

**Default password for debug keystore is:** `android`

**Alternative locations for debug keystore:**
- Windows: `%USERPROFILE%\.android\debug.keystore`
- Mac/Linux: `~/.android/debug.keystore`

### Step 2: Copy the SHA-1 Fingerprint
From the keytool output, copy the SHA-1 fingerprint. It will look like:
```
SHA1: DA:39:A3:EE:5E:6B:4B:0D:32:55:BF:EF:95:60:18:90:AF:D8:07:09
```

### Step 3: Add SHA Fingerprint to Firebase
1. In Firebase Console, go to **Project Settings** (gear icon)
2. Select your **Android app**
3. Scroll down to **"SHA certificate fingerprints"** section
4. Click **"Add fingerprint"**
5. Paste the SHA-1 fingerprint from Step 2
6. Click **"Save"**

### Step 4: Download Updated google-services.json
1. After adding the SHA fingerprint, click **"Download google-services.json"**
2. Replace the existing file in `android/app/google-services.json`
3. **Important:** Always download a fresh copy after adding fingerprints!

## 3. Verify Android Configuration

### Step 1: Check Package Name
Ensure your package name matches between:
1. **Firebase Console**: Your Android app package name
2. **android/app/build.gradle**: `applicationId` field
3. **android/app/src/main/AndroidManifest.xml**: `package` attribute

### Step 2: Verify google-services.json
1. Confirm `google-services.json` is in `android/app/` directory
2. Check that the file contains your project's configuration
3. Look for the `client_id` field for Google Sign-In

## 4. Update Firebase Security Rules

### Firestore Security Rules
Update your Firestore security rules to ensure proper access control:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read categories
    match /categories/{categoryId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Only if users can create categories
    }
    
    // Solutions can be read by authenticated users
    match /solutions/{solutionId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.authorId;
    }
    
    // Comments can be read by authenticated users
    match /comments/{commentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.authorId;
    }
    
    // Payments can only be accessed by the user who made them
    match /payments/{paymentId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

### Firebase Storage Rules
If using Firebase Storage for file uploads:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_uploads/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /solution_images/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 5. Test Configuration on Android

### Testing Email Authentication
1. Run the app on Android emulator or device:
   ```bash
   flutter run
   ```
2. Try registering with a new email
3. Try logging in with existing credentials
4. Test the "Forgot Password" functionality

### Testing Google Sign-In
1. Run the app on Android emulator or device
2. Click the Google sign-in button
3. Complete the Google authentication flow
4. Verify the user is created in Firebase Authentication
5. Check that user data is saved to Firestore

**Note:** Google Sign-In may not work on emulators without Google Play Services. Test on a physical device if possible.

## 6. Android Production Setup

### For Android Release Build
1. **Generate a release keystore** if you haven't already:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   
2. **Get the SHA-1 fingerprint for your release keystore:**
   ```bash
   keytool -list -v -alias upload -keystore ~/upload-keystore.jks
   ```
   
3. **Add release SHA-1 to Firebase Console** (same process as debug)
4. **Download and replace** `google-services.json`
5. **Update android/app/build.gradle** with signing configuration:
   ```gradle
   android {
       signingConfigs {
           release {
               keyAlias 'upload'
               keyPassword 'your-key-password'
               storeFile file('../upload-keystore.jks')
               storePassword 'your-store-password'
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### Build Release APK
```bash
flutter build apk --release
```

### Environment Variables
Create or update your `.env` file with any additional configuration:

```env
# Add any additional Firebase configuration here
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
```

## 7. Android-Specific Troubleshooting

### Common Android Issues

#### Google Sign-In Not Working
- **Verify SHA-1 fingerprint** is correct and added to Firebase
- **Ensure `google-services.json`** is updated after adding SHA fingerprint
- **Check package name** matches exactly in Firebase and `android/app/build.gradle`
- **Test on physical device** - emulators may not have Google Play Services
- **Clear app data** and try again

#### "PlatformException(sign_in_failed)"
- SHA-1 fingerprint missing or incorrect
- Package name mismatch
- Google Services not available on device

#### "Client ID not found" Error
- **Ensure `google-services.json`** includes the client ID
- **Verify package name** matches exactly
- **Check SHA-1 fingerprint** is added correctly
- **Download fresh `google-services.json`** after adding fingerprints

#### Email Authentication Issues
- **Check Firebase security rules** allow the operation
- **Verify email/password authentication** is enabled
- **Check network connectivity**
- **Review Firebase Authentication logs** in the console

### Android Debug Steps
1. **Check Flutter logs** for detailed error messages:
   ```bash
   flutter logs
   ```
2. **Review Firebase Console logs** under Authentication > Users
3. **Verify Firestore security rules** in the Rules tab
4. **Test with different Android devices/emulators**
5. **Clear app data** and try again
6. **Check Android build.gradle** files for conflicts

### Quick Debug Commands
```bash
# Check if Google Services are available
flutter doctor

# Clear Flutter cache
flutter clean && flutter pub get

# Run with verbose logging
flutter run --verbose

# Check Android dependencies
cd android && ./gradlew dependencies
```

## 8. Next Steps for Android

After completing this setup:
1. **Test all authentication flows** thoroughly on Android devices
2. **Implement proper error handling** in your app
3. **Set up monitoring and analytics** 
4. **Test on different Android versions** and devices
5. **Prepare for Google Play Store** submission if needed

## 9. Android Resources

For additional help with Android setup:
- [Firebase Android Setup](https://firebase.google.com/docs/android/setup)
- [Google Sign-In for Android](https://developers.google.com/identity/sign-in/android/start)
- [Firebase Auth for Flutter](https://firebase.flutter.dev/docs/auth/overview)
- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
