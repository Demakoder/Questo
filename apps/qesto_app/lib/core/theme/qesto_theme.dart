import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class QestoColors {
  static const background = Color(0xFFF6F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF3478F6);
  static const primarySoft = Color(0xFFEAF2FF);
  static const text = Color(0xFF171A22);
  static const secondaryText = Color(0xFF7B8190);
  static const border = Color(0xFFE9EBF0);
  static const green = Color(0xFF55C96F);
  static const orange = Color(0xFFFFB347);
  static const danger = Color(0xFFFF6B5F);
  static const purple = Color(0xFF8D63F6);
}

ThemeData buildQestoTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: QestoColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: QestoColors.primary,
      primary: QestoColors.primary,
      surface: QestoColors.surface,
      error: QestoColors.danger,
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: QestoColors.text,
        letterSpacing: -0.5,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: QestoColors.text,
        letterSpacing: -0.3,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: QestoColors.text,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.35,
        color: QestoColors.text,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.35,
        color: QestoColors.text,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        height: 1.35,
        color: QestoColors.secondaryText,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: QestoColors.background,
      foregroundColor: QestoColors.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    dividerColor: QestoColors.border,
    splashFactory: InkRipple.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}
