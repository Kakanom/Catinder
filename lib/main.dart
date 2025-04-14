import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CatinderApp());
}

class CatinderApp extends StatefulWidget {
  const CatinderApp({super.key});

  @override
  State<CatinderApp> createState() => _CatinderAppState();
}

class _CatinderAppState extends State<CatinderApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _soundEnabled = true;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleSound(bool enabled) {
    setState(() {
      _soundEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder PRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: HomeScreen(
        onThemeChanged: toggleTheme,
        soundEnabled: _soundEnabled,
        onSoundChanged: toggleSound,
      ),
    );
  }
}
