# Bundle ID and App Name Update Summary

## Changes Made

### App Configuration
- **New Bundle ID**: `com.magi-3.idvflutter`
- **New App Name**: Flutter IDV
- **Previous Name**: acuant_webview_app → flutter_idv

### Files Updated

#### 1. Flutter Configuration
**File**: `pubspec.yaml`
```yaml
name: flutter_idv
description: Flutter IDV - Identity verification app integrating Acuant SDK with IdCloud KYC API
```

#### 2. Android Configuration
**Files Created/Updated**:
- `android/app/build.gradle` - Created with correct applicationId
- `android/build.gradle` - Root build configuration
- `android/gradle.properties` - Gradle properties
- `android/settings.gradle` - Settings configuration

**Key Changes**:
```gradle
applicationId "com.magi-3.idvflutter"
```

**Android Manifest**: `android/app/src/main/AndroidManifest.xml`
```xml
android:label="Flutter IDV"
```

**Package Structure**:
- Moved from: `com/example/acuant_webview_app/`
- Moved to: `com/magi3/idvflutter/`

**MainActivity**: `android/app/src/main/kotlin/com/magi3/idvflutter/MainActivity.kt`
```kotlin
package com.magi3.idvflutter
```

#### 3. iOS Configuration
**Files Created**:
- `ios/Runner.xcodeproj/project.pbxproj` - Xcode project configuration
- `ios/Flutter/Debug.xcconfig` - Debug configuration
- `ios/Flutter/Release.xcconfig` - Release configuration
- `ios/Runner/AppDelegate.swift` - App delegate
- `ios/Runner/Runner-Bridging-Header.h` - Bridging header

**Key Changes**:
```plist
PRODUCT_BUNDLE_IDENTIFIER = "com.magi-3.idvflutter"
PRODUCT_NAME = "Flutter IDV"
```

#### 4. Application Code
**File**: `lib/main.dart`
```dart
title: 'Flutter IDV',
```

#### 5. Documentation Updates
**File**: `README.md`
- Added Flutter IDV header section with bundle ID
- Updated references throughout documentation
- Added quick setup section

**File**: `setup.sh`
- Updated script messages to reference Flutter IDV
- Changed API references from Gemalto to IdCloud KYC

**File**: `docs/IdCloudAlignment.md`
- Updated title to include Flutter IDV app name
- Added bundle ID reference

### Directory Structure Changes

#### Android Package Structure
```
OLD: android/app/src/main/kotlin/com/example/acuant_webview_app/
NEW: android/app/src/main/kotlin/com/magi3/idvflutter/
```

#### iOS Project Structure
```
ios/
├── Runner.xcodeproj/
│   └── project.pbxproj
├── Runner/
│   ├── Info.plist
│   ├── AppDelegate.swift
│   └── Runner-Bridging-Header.h
└── Flutter/
    ├── Debug.xcconfig
    └── Release.xcconfig
```

## Build Commands

### Clean and Setup
```bash
flutter clean
flutter pub get
```

### Build for Platforms
```bash
# Debug
flutter run

# Android Release
flutter build apk --release

# iOS Release  
flutter build ios --release
```

## Verification

### Bundle ID Verification
- **Android**: Check `android/app/build.gradle` for `applicationId`
- **iOS**: Check Xcode project settings for `PRODUCT_BUNDLE_IDENTIFIER`

### App Name Verification
- **Android**: Check `AndroidManifest.xml` for `android:label`
- **iOS**: Check Xcode project settings for `PRODUCT_NAME`
- **Flutter**: Check `lib/main.dart` for `title`

## Notes

1. **Clean Build Required**: After bundle ID changes, always run `flutter clean` before building
2. **Platform Files**: All necessary Android and iOS configuration files have been created
3. **Package Structure**: Android package structure updated to match new bundle ID
4. **Documentation**: All documentation updated to reflect new app identity

## App Store Considerations

### Android (Google Play)
- Bundle ID: `com.magi-3.idvflutter`
- App Name: Flutter IDV

### iOS (App Store)
- Bundle Identifier: `com.magi-3.idvflutter`  
- Display Name: Flutter IDV

### Signing
- Ensure code signing certificates match the new bundle identifier
- Update provisioning profiles for iOS development/distribution
- Configure app signing for Android releases 