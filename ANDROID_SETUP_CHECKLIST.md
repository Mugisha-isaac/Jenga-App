# Android Setup Checklist ✅

Quick checklist to get Google Sign-In working on Android.

## 🔥 Firebase Console Setup

### ✅ Authentication Setup
- [ ] Firebase project created
- [ ] Android app added to Firebase project  
- [ ] Email/Password authentication enabled
- [ ] Google Sign-In provider enabled
- [ ] Support email configured for Google Sign-In

### ✅ Android App Configuration
- [ ] Package name matches in Firebase Console and `android/app/build.gradle`
- [ ] `google-services.json` downloaded and placed in `android/app/`

## 🔑 SHA Fingerprint Setup

### ✅ Get Debug SHA-1 Fingerprint
Run this command:
```bash
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
```
Password: `android`

### ✅ Add to Firebase
- [ ] Copy SHA-1 fingerprint from keytool output
- [ ] Add fingerprint in Firebase Console → Project Settings → Your Android App
- [ ] Download fresh `google-services.json` after adding fingerprint
- [ ] Replace old `google-services.json` in `android/app/`

## 📱 Testing

### ✅ Run App
```bash
flutter clean
flutter pub get
flutter run
```

### ✅ Test Features
- [ ] Email/Password login works
- [ ] Email/Password registration works  
- [ ] Forgot password works
- [ ] Google Sign-In button appears
- [ ] Google Sign-In works (test on physical device)

## 🚨 URGENT FIX for PlatformException(sign_in_failed, ApiException: 10)

### ❌ Your Current Error
**Error:** `PlatformException(sign_in_failed,com.google.android.gms.common.api.ApiException:10,null,null)`
**Cause:** Missing or incorrect SHA-1 fingerprint in Firebase Console

### 🔧 **IMMEDIATE FIX STEPS:**

#### Step 1: Use Your SHA-1 Fingerprint
Your SHA-1 fingerprint is: `9F:39:02:8D:9D:C6:1F:D9:E4:6A:48:B1:BB:1A:42:F9:DD:C5:4C:81`
Your package name is: `com.example.jenga_app`

#### Step 2: Add to Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Click **Project Settings** (gear icon)
4. Select your **Android app** (`com.alu.jenga`) ⚠️ **Updated package name**
5. Scroll to **"SHA certificate fingerprints"**
6. Click **"Add fingerprint"**
7. Paste: `9F:39:02:8D:9D:C6:1F:D9:E4:6A:48:B1:BB:1A:42:F9:DD:C5:4C:81`
8. Click **"Save"**

#### Step 3: Download Fresh google-services.json
1. After adding the fingerprint, click **"Download google-services.json"**
2. Replace the file in `android/app/google-services.json`
3. **This step is CRITICAL** - you must download a fresh file!

#### Step 4: Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### ✅ After Fix - Google Sign-In Should Work!

## 🚨 Common Issues & Fixes

### Google Sign-In Not Working?
1. **Check SHA-1 fingerprint** - most common issue
2. **Test on physical device** - emulators may not work
3. **Verify package name** matches exactly
4. **Download fresh google-services.json** after adding fingerprint

### Still Having Issues?
```bash
# Clear everything and restart
flutter clean
flutter pub get
# Clear app data on device
flutter run
```

## 🎯 Success Indicators

✅ **You're successful when:**
- Login screen loads without errors
- Email authentication works
- Forgot password sends email
- Google Sign-In button shows up
- Google Sign-In completes successfully (on physical device)
- User data saves to Firestore
- Navigation works after login

## 📞 Need Help?

Check the full `SETUP.md` for detailed troubleshooting steps and error solutions.
