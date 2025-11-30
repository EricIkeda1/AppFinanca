import 'package:flutter/material.dart';
import 'telas/home_page.dart';

void main() {
  runApp(const GastosDiariosApp());
}

class GastosDiariosApp extends StatelessWidget {
  const GastosDiariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastos Diários',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050816),
        cardColor: const Color(0xFF111827),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF6366F1),
        ),
      ),
      home: const HomePage(),
    );
  }
}
