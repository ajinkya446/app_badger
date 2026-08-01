import 'package:app_badger/app_badger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appBadgeSupported = 'Unknown';
  String _badgeStatus = '';

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await AppBadger.isBadgeSupported();
      appBadgeSupported = res ? 'Supported' : 'Not supported';
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Badge Example App')),
        body: GlassMorphismContainer(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Badge supported: $_appBadgeSupported\n'),
                Text('Badge status: $_badgeStatus\n', style: TextStyle(fontWeight: FontWeight.bold)),
                GlassMorphismContainer(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  borderRadius: 24.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _addBadge,
                    child: const Text('Add badge'),
                  ),
                ),
                GlassMorphismContainer(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  borderRadius: 24.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _removeBadge,
                    child: const Text('Remove badge'),
                  ),
                ),
                const SizedBox(height: 10),
                GlassMorphismContainer(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  borderRadius: 24.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _checkNotificationPermission,
                    child: const Text('Check Notification Enabled'),
                  ),
                ),
                GlassMorphismContainer(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  borderRadius: 24.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _openNotificationSettings,
                    child: const Text('Open Notification Settings'),
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(Icons.notifications, size: 48),
                    GlassMorphismBadge(count: 7),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addBadge() async {
    try {
      await AppBadger.updateBadgeCount(1);
      setState(() {
        _badgeStatus = "Badge count added successfully!";
      });
    } on PlatformException {
      setState(() {
        _badgeStatus = "Failed to add badge count!";
      });
    }
  }

  void _removeBadge() async {
    try {
      await AppBadger.removeBadge();
      setState(() {
        _badgeStatus = "Badge removed successfully!";
      });
    } on PlatformException {
      setState(() {
        _badgeStatus = "Failed to remove badge!";
      });
    }
  }

  void _checkNotificationPermission() async {
    try {
      bool isEnabled = await AppBadger.isNotificationEnabled();
      initPlatformState();
      setState(() {
        _badgeStatus = "Notifications are ${isEnabled ? "enabled" : "disabled"}";
      });
    } on PlatformException {
      setState(() {
        _badgeStatus = "Failed to check notification status!";
      });
    }
  }

  void _openNotificationSettings() async {
    try {
      await AppBadger.openNotificationSettings();
    } on PlatformException {
      setState(() {
        _badgeStatus = "Failed to open notification settings!";
      });
    }
  }
}
