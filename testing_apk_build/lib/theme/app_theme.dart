// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../ui/shared/constant/style_constant.dart';
import 'style.dart';

class AppTheme {
  static ThemeData light() {
    const seed = AppConst.primaryColor; // your PRIMARY color (green)
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      // brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      // Common component shapes can use your radii
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConst.radius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConst.radiusS),
          ),
        ),
      ),

      // Attach your custom tokens here
      extensions: const [
        AppStyle(
          radiusS: 8,
          radius: 12,
          radiusM: 14,
          radiusL: 20,
          spacingS: 8,
          spacing: 10,
          spacingM: 12,
          spacingL: 16,
        ),
      ],
    );
  }

  static ThemeData dark() {
    final base = light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConst.primaryColor,
        // brightness: Brightness.dark,
      ),
    );
  }
}
