import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppBadger: A reusable badge plugin with frosted glass effect.
/// Provides notification badge functionality and UI overlay.
class AppBadger {
  static const MethodChannel _channel = MethodChannel('app_badger');

  /// Updates the badge count
  static Future<void> updateBadgeCount(int count) async {
    try {
      await _channel.invokeMethod('updateBadgeCount', {"count": count});
    } on PlatformException {
      return;
    }
  }

  /// Removes the badge
  static Future<void> removeBadge() async {
    try {
      await _channel.invokeMethod('removeBadge');
    } on PlatformException {
      rethrow;
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
