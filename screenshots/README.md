# Screenshots Directory

This directory contains screenshots of the Jenga App for documentation purposes.

## Screenshot Guidelines

### 📱 Device Specifications
- **Resolution**: 1080x2400 (or similar modern mobile resolution)
- **Device**: Use actual device or high-quality emulator
- **Orientation**: Portrait mode (unless landscape is specifically needed)

### 📸 Screenshot Requirements

#### Authentication Flow
- `splash.png` - Splash screen with app logo
- `welcome.png` - Welcome screen for first-time users
- `onboarding_1.png` - First onboarding screen
- `onboarding_2.png` - Second onboarding screen
- `onboarding_3.png` - Third onboarding screen
- `login.png` - Login screen
- `register.png` - Registration screen

#### Main App Features
- `home.png` - Home dashboard
- `explore.png` - Explore/search screen
- `solution_detail.png` - Solution detail view
- `create_solution.png` - Solution creation screen
- `profile.png` - User profile screen
- `settings.png` - Settings screen

#### Payment & Premium
- `payment.png` - Payment screen
- `premium.png` - Premium content view
- `history.png` - Transaction history
- `payment_success.png` - Payment confirmation

#### Dark Mode Variants
Include dark mode versions with `_dark` suffix:
- `home_dark.png`
- `profile_dark.png`
- etc.

### 🎨 Screenshot Quality Standards
- **Clean UI**: No personal data, use demo accounts
- **Consistent Lighting**: Bright, clear visibility
- **No Status Bar Clutter**: Clean status bar
- **Proper Content**: Use meaningful sample data
- **High Resolution**: Clear, crisp images

### 📐 Recommended Dimensions
- **Mobile Screenshots**: 1080x2400 px
- **Tablet Screenshots**: 1600x2560 px (if applicable)
- **Feature Graphics**: 1024x500 px (for app stores)

## Usage in Documentation

Screenshots are referenced in the main README.md file and should be:
1. Optimized for web viewing (< 500KB per image)
2. Named consistently with the guidelines above
3. Updated whenever UI changes significantly

## Tools for Screenshots

### Recommended Tools
- **Android**: `adb shell screencap` or Android Studio
- **iOS**: Xcode Simulator or physical device
- **Cross-platform**: Flutter's `integration_test` with screenshots

### Example Commands
```bash
# Android screenshot via ADB
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# iOS Simulator
xcrun simctl io booted screenshot screenshot.png
```

## Notes
- Screenshots should be taken with the latest app version
- Include both light and dark theme variants when possible
- Remove any personal or sensitive information
- Use consistent demo data across screenshots
