import 'package:flutter/material.dart';

void main() {
  runApp(const MaatruApp());
}

class MaatruApp extends StatelessWidget {
  const MaatruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maatru',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'மாற்று\nMaatru',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B00),
            ),
          ),
        ),
      ),
    );
  }
}