import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor_mobile_app/utils/models.dart';
import 'package:monitor_mobile_app/screens/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
