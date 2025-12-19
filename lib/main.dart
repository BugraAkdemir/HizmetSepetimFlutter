import 'package:flutter/material.dart';
import 'gui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HizmetSepetim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A9D8F)),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // 🔥 ASIL OLAY BURASI
    );
  }
}
