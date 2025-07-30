#!/bin/bash

# Google Sign-In Fix Verification Script
echo "🔍 Checking Google Sign-In Configuration..."
echo

# Check if google-services.json exists
if [ -f "android/app/google-services.json" ]; then
    echo "✅ google-services.json found"
    
    # Check package name in google-services.json
    PACKAGE_NAME=$(grep -o '"package_name"[[:space:]]*:[[:space:]]*"[^"]*"' android/app/google-services.json | head -1 | cut -d'"' -f4)
    echo "📦 Package name in google-services.json: $PACKAGE_NAME"
    
    # Check if it matches build.gradle.kts
    BUILD_GRADLE_PACKAGE=$(grep -o 'applicationId = "[^"]*"' android/app/build.gradle.kts | head -1 | cut -d'"' -f2)
    echo "📦 Package name in build.gradle.kts: $BUILD_GRADLE_PACKAGE"
    
    if [ "$PACKAGE_NAME" = "$BUILD_GRADLE_PACKAGE" ]; then
        echo "✅ Package names match!"
    else
        echo "❌ Package names don't match!"
    fi
    
    # Check for client_id (indicates Google Sign-In is configured)
    if grep -q "client_id" android/app/google-services.json; then
        echo "✅ Google Sign-In client_id found in google-services.json"
    else
        echo "❌ No Google Sign-In client_id found - you may need to download fresh google-services.json"
    fi
    
else
    echo "❌ google-services.json not found in android/app/"
fi

echo
echo "🔧 To fix Google Sign-In error:"
echo "1. Add SHA-1 fingerprint to Firebase Console: 9F:39:02:8D:9D:C6:1F:D9:E4:6A:48:B1:BB:1A:42:F9:DD:C5:4C:81"
echo "2. Download fresh google-services.json"
echo "3. Run: flutter clean && flutter pub get && flutter run"
