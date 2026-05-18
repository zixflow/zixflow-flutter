/// Enum to define the log levels.
/// Logs can be viewed in Xcode or Android studio.
enum CioLogLevel { none, error, info, debug }

/// Use this enum to specify the region your Zixflow workspace is present in.
/// US - for data center in United States
/// EU - for data center in European Union
///
/// Note: Zixflow uses a global endpoint, so both regions point to the same API host.
enum Region {
  us,
  eu;

  /// Get API host for the region - Zixflow uses global endpoint
  String get apiHost => 'api-events.zixflow.com/v1';

  /// Get CDN host for the region - Zixflow uses global endpoint
  String get cdnHost => 'api-events.zixflow.com/v1';
}

/// Enum to specify the type of metric for tracking
enum MetricEvent { delivered, opened, converted }

/// Enum to specify the click behavior of push notification for Android
enum PushClickBehaviorAndroid {
  resetTaskStack(rawValue: 'RESET_TASK_STACK'),
  activityPreventRestart(rawValue: 'ACTIVITY_PREVENT_RESTART'),
  activityNoFlags(rawValue: 'ACTIVITY_NO_FLAGS');

  factory PushClickBehaviorAndroid.fromValue(String value) {
    switch (value) {
      case 'RESET_TASK_STACK':
        return PushClickBehaviorAndroid.resetTaskStack;
      case 'ACTIVITY_PREVENT_RESTART':
        return PushClickBehaviorAndroid.activityPreventRestart;
      case 'ACTIVITY_NO_FLAGS':
        return PushClickBehaviorAndroid.activityNoFlags;
      default:
        throw ArgumentError('Invalid value provided');
    }
  }

  const PushClickBehaviorAndroid({
    required this.rawValue,
  });

  final String rawValue;
}

/// Enum class to define how CustomerIO SDK should handle screen view events.
/// all - to send screen events to destinations for analytics purposes and to display in-app messages.
/// inApp - to only display in-app messages and not send screen events to destinations.
enum ScreenView { all, inApp }

/// Location tracking mode for the CustomerIO Location module.
enum LocationTrackingMode {
  /// Location tracking is disabled. All location operations no-op.
  off(rawValue: 'OFF'),

  /// Host app controls when location is captured (default).
  manual(rawValue: 'MANUAL'),

  /// SDK auto-captures location once per app launch when the app becomes active.
  onAppStart(rawValue: 'ON_APP_START');

  const LocationTrackingMode({required this.rawValue});

  final String rawValue;
}
