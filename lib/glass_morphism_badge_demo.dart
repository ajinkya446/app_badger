import 'package:flutter/material.dart';
import 'package:app_badger/app_badger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlassMorphism Badge Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('GlassMorphism Badge Demo')),
        body: Center(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Icon(Icons.notifications, size: 48),
              GlassMorphismBadge(count: 7),
            ],
          ),
        ),
      ),
    );
  }
}

