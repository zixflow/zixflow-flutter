library zixflow;

/// Zixflow-branded public API for the Zixflow Flutter SDK.
///
/// This file provides type aliases to expose Zixflow branding while
/// maintaining compatibility with the underlying CustomerIO implementation.
///
/// ## Initialization
/// ```dart
/// final config = ZixflowConfig(
///   cdpApiKey: 'your-api-key',
///   region: Region.US,
///   logLevel: CioLogLevel.debug,
/// );
/// await Zixflow.initialize(config: config);
/// ```
///
/// ## Main API Usage
/// ```dart
/// // Identify user
/// Zixflow.instance.identify(
///   userId: 'user-123',
///   traits: {'email': 'user@example.com'},
/// );
///
/// // Track event
/// Zixflow.instance.track(
///   name: 'button_clicked',
///   properties: {'button_id': 'submit'},
/// );
/// ```
///
/// ## Module-Specific APIs
/// **Note:** Due to Dart type alias limitations, module-specific APIs still use
/// the `CustomerIO` namespace. This is intentional and does not affect functionality.
///
/// ```dart
/// // In-app messaging
/// CustomerIO.inAppMessaging.subscribeToEventsListener(handler);
///
/// // Push messaging
/// CustomerIO.pushMessaging.registerDeviceToken(token);
///
/// // Location tracking
/// CustomerIO.location.trackLocation(latitude, longitude);
/// ```

// Export commonly used types with Zixflow branding
export 'customer_io.dart';
export 'customer_io_config.dart';
export 'customer_io_enums.dart';
export 'customer_io_widgets.dart';

import 'customer_io.dart';
import 'customer_io_config.dart';

/// Main Zixflow SDK class
typedef Zixflow = CustomerIO;

/// Zixflow configuration class
typedef ZixflowConfig = CustomerIOConfig;
