import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/constants/provider_name.dart';

final themeProvider = Provider.family<ThemeData, Brightness>((ref, brightness) {
  final theme = ThemeData(
    brightness: brightness,
    primaryColor: Colors.teal,
    primarySwatch: Colors.teal,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Color(0xFF003333),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color(0xFF800080),
      unselectedLabelColor: Colors.white60,
      indicatorColor: Color(0xFF800080),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Color(0xFF003333),
      backgroundColor: Colors.teal,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.disabled)
                ? brightness == Brightness.dark
                    ? Colors.white60
                    : const Color(0xFF446666)
                : const Color(0xFF003333)),
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.disabled)
                ? const Color(0xAF668080)
                : const Color(0xFF009999)),
        // backgroundColor: MaterialStateProperty.all(const Color(0xFF009999)),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.teal,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.teal,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal, width: 2.0),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF009999),
    ),
  );
  return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(secondary: Colors.lime));
}, name: kProviderNameTheme);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

extension Extension on ThemeMode {
  ThemeMode getNext() {
    switch (this) {
      case ThemeMode.system:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  IconData getIcon() {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_medium;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}
