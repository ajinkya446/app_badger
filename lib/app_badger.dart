import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Detailed notification/badge permission status.
enum BadgePermissionStatus {
  /// Permission granted and notifications enabled.
  granted,

  /// Permission explicitly denied by the user.
  denied,

  /// Permission has not yet been requested.
  notDetermined,

  /// Permission restricted by the system (iOS only).
  restricted,

  /// Provisional permission granted (iOS only).
  provisional,
}

/// AppBadger: A reusable badge plugin with frosted glass effect.
/// Provides notification badge functionality and UI overlay.
class AppBadger {
  static const MethodChannel _channel = MethodChannel('app_badger');

  /// Updates the badge count. Returns `true` on success, `false` on failure.
  static Future<bool> updateBadgeCount(int count) async {
    try {
      final result = await _channel.invokeMethod<bool>('updateBadgeCount', {"count": count});
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Removes the badge. Returns `true` on success, `false` on failure.
  static Future<bool> removeBadge() async {
    try {
      final result = await _channel.invokeMethod<bool>('removeBadge');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Returns the current persisted badge count (0 if unknown).
  static Future<int> getBadgeCount() async {
    try {
      final result = await _channel.invokeMethod<int>('getBadgeCount');
      return result ?? 0;
    } on PlatformException {
      return 0;
    }
  }

  /// Increments the current badge count by 1 and returns the new count.
  static Future<int> incrementBadge() async {
    final current = await getBadgeCount();
    final newCount = current + 1;
    await updateBadgeCount(newCount);
    return newCount;
  }

  /// Decrements the current badge count by 1 (minimum 0) and returns the new count.
  static Future<int> decrementBadge() async {
    final current = await getBadgeCount();
    final newCount = (current - 1).clamp(0, current);
    await updateBadgeCount(newCount);
    return newCount;
  }

  /// Returns the device manufacturer. On Android this reflects `Build.MANUFACTURER`;
  /// on iOS and macOS it returns `"Apple"`.
  static Future<String> getDeviceManufacturer() async {
    try {
      final result = await _channel.invokeMethod<String>('getDeviceManufacturer');
      return result ?? 'Unknown';
    } on PlatformException {
      return 'Unknown';
    }
  }

  /// Returns the device brand. On Android this reflects `Build.BRAND`;
  /// on iOS and macOS it returns `"Apple"`.
  static Future<String> getDeviceBrand() async {
    try {
      final result = await _channel.invokeMethod<String>('getDeviceBrand');
      return result ?? 'Unknown';
    } on PlatformException {
      return 'Unknown';
    }
  }

  /// Returns the detailed [BadgePermissionStatus] for this device.
  static Future<BadgePermissionStatus> getPermissionStatus() async {
    try {
      final result = await _channel.invokeMethod<String>('getPermissionStatus');
      switch (result) {
        case 'granted':
          return BadgePermissionStatus.granted;
        case 'denied':
          return BadgePermissionStatus.denied;
        case 'restricted':
          return BadgePermissionStatus.restricted;
        case 'provisional':
          return BadgePermissionStatus.provisional;
        default:
          return BadgePermissionStatus.notDetermined;
      }
    } on PlatformException {
      return BadgePermissionStatus.notDetermined;
    }
  }

  /// Checks if badge is supported on this device
  static Future<bool> isBadgeSupported() async {
    try {
      final bool result = await _channel.invokeMethod('isBadgeSupported');
      return result;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Checks if notifications are enabled (useful for Xiaomi)
  static Future<bool> isNotificationEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isNotificationEnabled');
      return result;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Opens the app's notification settings
  static Future<void> openNotificationSettings() async {
    try {
      await _channel.invokeMethod('openNotificationSettings');
    } on PlatformException {
      rethrow;
    }
  }

  /// Requests POST_NOTIFICATIONS permission (Android 13+) and notification permission (iOS)
  /// Returns true if permission was granted, false otherwise
  static Future<bool> requestNotificationPermission() async {
    try {
      final bool result = await _channel.invokeMethod('requestNotificationPermission');
      return result;
    } on PlatformException catch (_) {
      return false;
    }
  }
}

/// A [WidgetsBindingObserver] mixin that automatically clears the app badge
/// when the app returns to the foreground.
///
/// Usage:
/// ```dart
/// class _MyHomePageState extends State<MyHomePage> with BadgeLifecycleObserver {
///   @override
///   void initState() {
///     super.initState();
///     initBadgeLifecycle();
///   }
///
///   @override
///   void dispose() {
///     disposeBadgeLifecycle();
///     super.dispose();
///   }
/// }
/// ```
mixin BadgeLifecycleObserver on State {
  /// Set to `false` to disable auto-clearing the badge on resume.
  bool clearBadgeOnResume = true;

  _BadgeObserver? _badgeObserver;

  /// Call this in your `initState()` to register the lifecycle observer.
  void initBadgeLifecycle() {
    _badgeObserver = _BadgeObserver(() => clearBadgeOnResume);
    WidgetsBinding.instance.addObserver(_badgeObserver!);
  }

  /// Call this in your `dispose()` to unregister the lifecycle observer.
  void disposeBadgeLifecycle() {
    if (_badgeObserver != null) {
      WidgetsBinding.instance.removeObserver(_badgeObserver!);
      _badgeObserver = null;
    }
  }
}

/// Internal observer that handles lifecycle events for [BadgeLifecycleObserver].
class _BadgeObserver extends WidgetsBindingObserver {
  final bool Function() _shouldClear;

  _BadgeObserver(this._shouldClear);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldClear()) {
      AppBadger.removeBadge();
    }
  }
}

/// GlassMorphismBadge widget for notification counts.
/// Features frosted glass effect, semi-transparent styling, rounded borders,
/// and overlay-friendly design.
class GlassMorphismBadge extends StatelessWidget {
  final int count;
  final double size;
  final Color color;
  final double blur;
  final double borderRadius;
  final TextStyle? textStyle;

  const GlassMorphismBadge({
    super.key,
    required this.count,
    this.size = 24.0,
    this.color = const Color(0x66FFFFFF), // semi-transparent white
    this.blur = 8.0,
    this.borderRadius = 12.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: Color.fromARGB((0.3 * 255).toInt(), 255, 255, 255),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: textStyle ?? TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// GlassMorphismContainer: A reusable widget for glassmorphism UI design.
/// Use for backgrounds, cards, overlays, etc.
class GlassMorphismContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final EdgeInsetsGeometry padding;

  const GlassMorphismContainer({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.color = const Color(0x66FFFFFF),
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.borderColor = const Color(0x33FFFFFF),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
