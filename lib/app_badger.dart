import 'dart:async';

import 'package:flutter/services.dart';

class AppBadger {
  static const MethodChannel _channel = MethodChannel('app_badger');

  /// Updates the badge count
  static Future<void> updateBadgeCount(int count) async {
    try {
      await _channel.invokeMethod('updateBadgeCount', {"count": count});
    } on PlatformException catch (e) {
      print("Failed to update badge count: ${e.message}");
    }
  }

  /// Removes the badge
  static Future<void> removeBadge() async {
    try {
      await _channel.invokeMethod('removeBadge');
    } on PlatformException catch (e) {
      print("Failed to remove badge count: ${e.message}");
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
    } on PlatformException catch (e) {
      print("Failed to open notification settings: ${e.message}");
    }
  }
}
