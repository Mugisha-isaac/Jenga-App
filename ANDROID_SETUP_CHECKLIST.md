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
