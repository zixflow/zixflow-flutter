# Zixflow Flutter SDK - Integration Guide

Complete guide for integrating the Zixflow Flutter SDK into your application.

## Table of Contents

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Quick Start](#quick-start)
5. [Core Features](#core-features)
6. [Push Notifications](#push-notifications)
7. [In-App Messaging](#in-app-messaging)
8. [Location Tracking](#location-tracking)
9. [Advanced Configuration](#advanced-configuration)
10. [Platform-Specific Setup](#platform-specific-setup)
11. [Troubleshooting](#troubleshooting)
12. [Example Apps](#example-apps)
13. [API Reference](#api-reference)
14. [Support & Resources](#support--resources)

---

## Introduction

The Zixflow Flutter SDK enables you to send data from your Flutter app to Zixflow, allowing you to track user behavior, send targeted push notifications, display in-app messages, and more. The SDK works across iOS and Android platforms.

### SDK Modules

The SDK includes integrated modules:

- **Data Pipelines** (core): User identification, event tracking, and analytics
- **Push Messaging**: Push notifications via Firebase Cloud Messaging (FCM)
- **In-App Messaging**: Display in-app messages and manage inbox
- **Location Tracking**: Location-based messaging capabilities

---

## Requirements

- **Flutter**: 2.5.0 or higher
- **Dart**: 2.17.6 or higher
- **iOS**: 13.0 or higher
- **Android**: API 21 (Android 5.0 Lollipop) or higher

---

## Installation

### Add Dependency

Add the Zixflow SDK to your `pubspec.yaml`:

```yaml
dependencies:
  zixflow: ^1.0.0
```

### Install Package

Run the following command:

```bash
flutter pub get
```

### Platform-Specific Setup

After adding the dependency, follow platform-specific setup for iOS and Android (see [Platform-Specific Setup](#platform-specific-setup) section).

---

## Quick Start

### Basic Initialization

Create or update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:zixflow/zixflow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Zixflow SDK
  final config = ZixflowConfig(
    cdpApiKey: 'YOUR_CDP_API_KEY',
    region: Region.us,  // or Region.eu
    logLevel: CioLogLevel.debug,
  );

  await Zixflow.initialize(config: config);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}
```

### Replace Configuration Values

- **YOUR_CDP_API_KEY**: Your Zixflow CDP API key (from Zixflow dashboard)

---

## Core Features

### User Identification

Identify users to track their activity:

```dart
// Identify user with ID only
Zixflow.instance.identify(userId: 'user@example.com');

// Identify user with additional attributes
Zixflow.instance.identify(
  userId: 'user@example.com',
  traits: {
    'first_name': 'John',
    'last_name': 'Doe',
    'email': 'user@example.com',
    'plan': 'premium',
    'created_at': DateTime.now().toIso8601String(),
  },
);
```

### Event Tracking

Track custom events:

```dart
// Simple event
Zixflow.instance.track(name: 'button_clicked');

// Event with properties
Zixflow.instance.track(
  name: 'purchase_completed',
  properties: {
    'product_id': '123',
    'product_name': 'Widget',
    'price': 29.99,
    'currency': 'USD',
  },
);

// Event with timestamp
Zixflow.instance.track(
  name: 'order_completed',
  properties: {'order_id': 'ABC123'},
  timestamp: DateTime.now().millisecondsSinceEpoch,
);
```

### Screen Tracking

Track screen views:

```dart
// Manual screen tracking
Zixflow.instance.screen(
  title: 'Product Detail',
  properties: {
    'product_id': '123',
    'category': 'Electronics',
  },
);
```

#### Automatic Screen Tracking with GoRouter

Enable automatic screen tracking by setting `screenViewUse` in configuration:

```dart
final config = ZixflowConfig(
  cdpApiKey: 'YOUR_API_KEY',
  screenViewUse: ScreenView.all,  // Track all screens automatically
);
```

### Profile Attributes

Set user profile attributes:

```dart
// Set profile attributes
Zixflow.instance.setProfileAttributes(
  attributes: {
    'age': 30,
    'gender': 'male',
    'subscription_status': 'active',
    'preferences': {'notifications': true},
  },
);
```

### Device Attributes

Set device-specific attributes:

```dart
// Set device attributes
Zixflow.instance.setDeviceAttributes(
  attributes: {
    'app_theme': 'dark',
    'notifications_enabled': true,
    'preferred_language': 'en',
  },
);
```

### User Logout

Clear user identification when they log out:

```dart
// Clear identified user
Zixflow.instance.clearIdentify();
```

### Register Device Token

Register device token for push notifications:

```dart
Zixflow.instance.registerDeviceToken(deviceToken: 'YOUR_DEVICE_TOKEN');
```

---

## Push Notifications

The Zixflow Flutter SDK uses Firebase Cloud Messaging (FCM) for push notifications on both iOS and Android.

### Prerequisites

1. **Firebase Project Setup**
   - Create Firebase project at https://console.firebase.google.com
   - Add iOS app to Firebase
   - Add Android app to Firebase
   - Download configuration files:
     - iOS: `GoogleService-Info.plist`
     - Android: `google-services.json`

2. **Add Firebase Dependencies**

Update your `pubspec.yaml`:

```yaml
dependencies:
  zixflow: ^1.0.0
  firebase_core: ^3.3.0
  firebase_messaging: ^15.0.4
  flutter_local_notifications: ^19.5.0  # For foreground notifications
```

### Initialize Firebase

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:zixflow/zixflow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';  // Generated by FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure foreground notification presentation
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Initialize Zixflow SDK
  final config = ZixflowConfig(
    cdpApiKey: 'YOUR_CDP_API_KEY',
    region: Region.us,
  );
  await Zixflow.initialize(config: config);

  runApp(MyApp());
}
```

### Handle Push Notifications

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  void _setupPushNotifications() {
    // Handle notification when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handlePushNotificationClick(message, 'terminated');
      }
    });

    // Handle notification when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handlePushNotificationClick(message, 'background');
    });

    // Handle notification when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      // Display local notification or handle as needed
      print('Foreground message: ${message.notification?.title}');
    });
  }

  void _handlePushNotificationClick(RemoteMessage message, String appState) {
    // Track push notification click
    Zixflow.instance.track(
      name: 'push_clicked',
      properties: {
        'push_title': message.notification?.title,
        'app_state': appState,
      },
    );

    // Navigate to appropriate screen based on notification data
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}
```

### Request Push Permission (iOS 10+)

```dart
Future<void> requestPushPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted push notification permission');
  } else {
    print('User declined or has not accepted push notification permission');
  }
}
```

### Local Notifications (Foreground)

To show notifications when app is in foreground, use `flutter_local_notifications`:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('app_icon');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await localNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      // Handle local notification click
      Zixflow.instance.track(
        name: 'local_notification_clicked',
        properties: {'payload': response.payload},
      );
    },
  );
}
```

---

## In-App Messaging

Display in-app messages and manage an inbox of messages for users.

### Initialize In-App Messaging

```dart
final config = ZixflowConfig(
  cdpApiKey: 'YOUR_API_KEY',
  region: Region.us,
  inAppConfig: InAppConfig(
    siteId: 'YOUR_SITE_ID',  // Required for in-app messaging
  ),
);
await Zixflow.initialize(config: config);
```

### Subscribe to In-App Events

```dart
import 'package:zixflow/zixflow.dart';

late StreamSubscription<InAppEvent> _inAppSubscription;

void setupInAppMessaging() {
  _inAppSubscription = CustomerIO.inAppMessaging
      .subscribeToEventsListener(_handleInAppEvent);
}

void _handleInAppEvent(InAppEvent event) {
  print('In-app event: ${event.eventType.name}');

  switch (event.eventType) {
    case InAppEventType.messageShown:
      print('Message shown: ${event.message?.messageId}');
      break;
    case InAppEventType.messageDismissed:
      print('Message dismissed');
      break;
    case InAppEventType.messageActionTaken:
      print('Action taken: ${event.actionValue}');
      // Handle deep links or custom actions
      if (event.actionValue?.startsWith('http') ?? false) {
        // Open URL
      }
      break;
    case InAppEventType.errorWithMessage:
      print('Error with message');
      break;
  }
}

@override
void dispose() {
  _inAppSubscription.cancel();
  super.dispose();
}
```

### Inbox Messages

Manage inbox messages:

```dart
// Get inbox instance
final inbox = CustomerIO.inAppMessaging.inbox;

// Fetch messages
Future<List<InboxMessage>> fetchMessages() async {
  try {
    return await inbox.getMessages();
  } catch (e) {
    print('Error fetching messages: $e');
    return [];
  }
}

// Listen to real-time updates
late StreamSubscription<List<InboxMessage>> _messagesSubscription;

void setupInbox() {
  _messagesSubscription = inbox.messages().listen((messages) {
    setState(() {
      _messages = messages;
    });
  });
}

// Mark message as read/unread
void toggleMessageRead(InboxMessage message) {
  if (message.opened) {
    inbox.markMessageUnopened(message);
  } else {
    inbox.markMessageOpened(message);
  }
}

// Delete message
void deleteMessage(InboxMessage message) {
  inbox.deleteMessage(message);
}

// Open message (marks as read and displays)
void openMessage(InboxMessage message) {
  inbox.openMessage(message);
}
```

---

## Location Tracking

Enable location-based messaging capabilities.

### Initialize Location Tracking

```dart
final config = ZixflowConfig(
  cdpApiKey: 'YOUR_API_KEY',
  region: Region.us,
  locationConfig: LocationConfig(),  // Enable location tracking
);
await Zixflow.initialize(config: config);
```

### Request Location Permission

Use the `permission_handler` package:

```yaml
dependencies:
  permission_handler: ^11.3.1
```

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();

  if (status.isGranted) {
    print('Location permission granted');
  } else if (status.isDenied) {
    print('Location permission denied');
  } else if (status.isPermanentlyDenied) {
    // Open app settings
    openAppSettings();
  }
}
```

### Manual Location Update

```dart
// Track location manually
CustomerIO.location.trackLocation(
  latitude: 37.7749,
  longitude: -122.4194,
);
```

---

## Advanced Configuration

### Full Configuration Options

```dart
final config = ZixflowConfig(
  // Required
  cdpApiKey: 'YOUR_CDP_API_KEY',

  // Region (choose data center location)
  region: Region.us,  // or Region.eu

  // Logging level
  logLevel: CioLogLevel.debug,  // error, info, debug

  // Auto-tracking options
  autoTrackDeviceAttributes: true,
  trackApplicationLifecycleEvents: true,

  // Screen tracking
  screenViewUse: ScreenView.all,  // all, inApp, none

  // Event batching
  flushAt: 20,          // Send events after 20 tracked
  flushInterval: 30,    // Or every 30 seconds

  // Custom endpoints (advanced)
  apiHost: 'custom-api.example.com',
  cdnHost: 'custom-cdn.example.com',

  // Migration from old SDK
  migrationSiteId: 'YOUR_LEGACY_SITE_ID',

  // In-app messaging
  inAppConfig: InAppConfig(
    siteId: 'YOUR_SITE_ID',
  ),

  // Push notifications
  pushConfig: PushConfig(
    // Push configuration options
  ),

  // Location tracking
  locationConfig: LocationConfig(),
);

await Zixflow.initialize(config: config);
```

### Region Configuration

Choose the data center region:

```dart
region: Region.us,  // United States (default)
region: Region.eu,  // European Union
```

### Log Levels

Control SDK logging verbosity:

```dart
logLevel: CioLogLevel.error,  // Errors only
logLevel: CioLogLevel.info,   // Errors + informational
logLevel: CioLogLevel.debug,  // All messages (development)
```

### Screen Tracking Options

```dart
screenViewUse: ScreenView.all,    // Track all screens
screenViewUse: ScreenView.inApp,  // Track only in-app screens
screenViewUse: ScreenView.none,   // Disable auto-tracking
```

---

## Platform-Specific Setup

### iOS Setup

#### 1. Add GoogleService-Info.plist

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add to `ios/Runner/` directory in Xcode
3. Ensure it's added to target

#### 2. Update Info.plist

Add required permissions to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We use your location to send relevant notifications</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We use your location to send relevant notifications</string>

<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### 3. CocoaPods (Default)

Run pod install:

```bash
cd ios
pod install
```

#### 4. Swift Package Manager (Optional)

To use SPM instead of CocoaPods, update `pubspec.yaml`:

```yaml
dependencies:
  zixflow:
    version: ^1.0.0
    native_sdk:
      ios:
        enable-swift-package-manager: true
```

Then run:

```bash
cd ios
pod install
```

---

### Android Setup

#### 1. Add google-services.json

1. Download `google-services.json` from Firebase Console
2. Place in `android/app/` directory

#### 2. Add Google Services Plugin

Update `android/build.gradle`:

```groovy
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Update `android/app/build.gradle`:

```groovy
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services'  // Add this
}

android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

#### 3. Permissions

Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
</manifest>
```

#### 4. Enable Location (Optional)

To enable location tracking, add to `android/gradle.properties`:

```properties
customerio_location_enabled=true
```

---

## Troubleshooting

### Build Errors

#### Pod Install Fails (iOS)

**Error**: CocoaPods could not find compatible versions

**Solution**:
```bash
cd ios
rm Podfile.lock
pod repo update
pod install
```

#### Firebase Configuration Not Found

**Error**: `GoogleService-Info.plist` not found

**Solution**:
1. Ensure file is in `ios/Runner/` directory
2. Verify file is added to Xcode target
3. Clean and rebuild: `flutter clean && flutter pub get`

---

### Runtime Issues

#### SDK Not Initialized

**Error**: `Zixflow SDK is not initialized`

**Solution**:
- Ensure `Zixflow.initialize()` is called before `runApp()`
- Add `WidgetsFlutterBinding.ensureInitialized()` before initialization
- Check logs for initialization errors

#### Events Not Tracking

**Problem**: Events not appearing in Zixflow dashboard

**Solution**:
1. Verify CDP API key is correct
2. Check log level is `debug` to see requests
3. Ensure user is identified before tracking events
4. Check network connectivity
5. Verify region setting (US/EU) matches your account

#### Push Notifications Not Working

**Problem**: Push notifications not received

**Solution**:
1. Verify `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are configured
2. Check FCM server key in Zixflow dashboard
3. Ensure Firebase is initialized before Zixflow
4. Test on physical device (not simulator for iOS APNs)
5. Check notification permissions are granted

#### In-App Messages Not Showing

**Problem**: In-app messages not displaying

**Solution**:
1. Verify site ID is correct in `InAppConfig`
2. Ensure user is identified
3. Verify message is active in Zixflow dashboard
4. Check logs for error messages
5. Ensure in-app event listener is subscribed

---

### Debug Logging

Enable detailed logging:

```dart
final config = ZixflowConfig(
  cdpApiKey: 'YOUR_API_KEY',
  logLevel: CioLogLevel.debug,  // Enable debug logging
);
```

View logs in console output when running app.

---

## Example Apps

The SDK includes complete example applications:

### Flutter Sample (SPM)
**Location**: `/apps/flutter_sample_spm/`

Demonstrates:
- SDK initialization
- Firebase Cloud Messaging
- In-app messaging with inbox
- Location tracking
- Event tracking and screen views
- User identification
- Settings configuration UI

### Flutter Sample (CocoaPods)
**Location**: `/apps/flutter_sample_cocoapods/`

Demonstrates:
- Same features as SPM sample
- Uses CocoaPods for iOS dependencies

### Running Example Apps

1. Clone the repository
2. Navigate to sample app:
   ```bash
   cd apps/flutter_sample_spm
   ```
3. Create `.env` file with credentials:
   ```
   CDP_API_KEY=your_api_key
   SITE_ID=your_site_id
   ```
4. Get dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

---

## API Reference

### Zixflow Core

```dart
// Initialize SDK
await Zixflow.initialize(config: ZixflowConfig);

// Get instance
Zixflow.instance

// Identify user
Zixflow.instance.identify({
  required String userId,
  Map<String, dynamic>? traits,
});

// Track event
Zixflow.instance.track({
  required String name,
  Map<String, dynamic>? properties,
  int? timestamp,
});

// Track screen
Zixflow.instance.screen({
  required String title,
  Map<String, dynamic>? properties,
});

// Set profile attributes
Zixflow.instance.setProfileAttributes({
  required Map<String, dynamic> attributes,
});

// Set device attributes
Zixflow.instance.setDeviceAttributes({
  required Map<String, dynamic> attributes,
});

// Clear user identification
Zixflow.instance.clearIdentify();

// Register device token
Zixflow.instance.registerDeviceToken({
  required String deviceToken,
});
```

### ZixflowConfig

```dart
ZixflowConfig({
  required String cdpApiKey,
  Region? region,
  CioLogLevel? logLevel,
  bool? autoTrackDeviceAttributes,
  bool? trackApplicationLifecycleEvents,
  ScreenView? screenViewUse,
  String? migrationSiteId,
  String? apiHost,
  String? cdnHost,
  int? flushAt,
  int? flushInterval,
  InAppConfig? inAppConfig,
  PushConfig? pushConfig,
  LocationConfig? locationConfig,
});
```

### In-App Messaging

```dart
// Subscribe to events
CustomerIO.inAppMessaging.subscribeToEventsListener(handler);

// Inbox management
final inbox = CustomerIO.inAppMessaging.inbox;
await inbox.getMessages();
inbox.messages().listen((messages) { /* ... */ });
inbox.markMessageOpened(message);
inbox.markMessageUnopened(message);
inbox.deleteMessage(message);
inbox.openMessage(message);
```

### Location

```dart
// Track location
CustomerIO.location.trackLocation({
  required double latitude,
  required double longitude,
});
```

---

## Support & Resources

### Documentation

- **GitHub Repository**: https://github.com/zixflow/zixflow-flutter
- **pub.dev Package**: https://pub.dev/packages/zixflow
- **API Documentation**: https://zixflow.com/docs/sdk/flutter/

### Getting Help

- **GitHub Issues**: https://github.com/zixflow/zixflow-flutter/issues
- **Email Support**: apps@zixflow.com

### Additional Resources

- [Getting Started Guide](../GETTING_STARTED.md) - Detailed setup guide
- [Release Notes](../CHANGELOG.md) - Version history and changes
- [pub.dev Setup](../PUB_DEV_SETUP.md) - Publishing guide

---

## Next Steps

1. **Add dependency** to `pubspec.yaml`
2. **Install package** with `flutter pub get`
3. **Initialize** the SDK in `main.dart`
4. **Identify users** with `Zixflow.instance.identify()`
5. **Track events** with `Zixflow.instance.track()`
6. **Set up push notifications** with Firebase
7. **Test** using the example apps as reference

For advanced features and customization, see the [Advanced Configuration](#advanced-configuration) section above.

---

**Need help?** Contact us at apps@zixflow.com or open an issue on GitHub.
