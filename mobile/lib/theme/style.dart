// lib/theme/tokens.dart
import 'package:flutter/material.dart';

@immutable
class AppStyle extends ThemeExtension<AppStyle> {
  final double radiusS;
  final double radius;
  final double radiusM;
  final double radiusL;
  final double spacingS;
  final double spacing;
  final double spacingM;
  final double spacingL;

  const AppStyle({
    required this.radiusS,
    required this.radius,
    required this.radiusM,
    required this.radiusL,
    required this.spacingS,
    required this.spacing,
    required this.spacingM,
    required this.spacingL,
  });

  @override
  AppStyle copyWith({
    double? radiusS,
    double? radius,
    double? radiusM,
    double? radiusL,
    double? spacingS,
    double? spacing,
    double? spacingM,
    double? spacingL,
  }) {
    return AppStyle(
      radiusS: radiusS ?? this.radiusS,
      radius: radius ?? this.radius,
      radiusM: radiusM ?? this.radiusM,
      radiusL: radiusL ?? this.radiusL,
      spacingS: spacingS ?? this.spacingS,
      spacing: spacing ?? this.spacing,
      spacingM: spacingM ?? this.spacingM,
      spacingL: spacingL ?? this.spacingL,
    );
  }

  @override
  AppStyle lerp(ThemeExtension<AppStyle>? other, double t) {
    if (other is! AppStyle) return this;
    return AppStyle(
      radiusS: lerpDouble(radiusS, other.radiusS, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      radiusM: lerpDouble(radiusM, other.radiusM, t)!,
      radiusL: lerpDouble(radiusL, other.radiusL, t)!,
      spacingS: lerpDouble(spacingS, other.spacingS, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      spacingM: lerpDouble(spacingM, other.spacingM, t)!,
      spacingL: lerpDouble(spacingL, other.spacingL, t)!,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
