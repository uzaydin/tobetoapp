import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobetoapp/main.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  ThemeMode _themeMode = ThemeMode.light;
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await _themeService.getThemeMode();
    setState(() {
      _themeMode = themeMode;
    });
  }

  void _toggleTheme() {
    final newThemMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _themeMode = newThemMode;
    });
    _themeService.setThemeMode(newThemMode);
    MyApp.of(context)?.setTheme(newThemMode);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
          _themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
      onPressed: _toggleTheme,
    );
  }
}

//  Tema yönetimi servisi

class ThemeService {
  static const String themeModeKey = "theme_mode";

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeModeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, themeMode.index);
  }

  ThemeMode currentThemeMode(ThemeMode? themeMode) {
    return themeMode ?? ThemeMode.system;
  }
}
