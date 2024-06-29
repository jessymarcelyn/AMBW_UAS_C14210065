import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginpage.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('pin');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}