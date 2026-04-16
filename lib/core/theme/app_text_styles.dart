import 'package:flutter/material.dart';
import 'package:halal_dublin/core/theme/app_colors.dart';

class AppTextStyles {
  // Greeting headline
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Card title
  static const TextStyle titleMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Address, secondary info
  static const TextStyle bodySmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Chip labels
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Subtitle text
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Detail screen labels
  static const TextStyle labelTiny = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 0.5,
  );

  // Detail values
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  AppTextStyles._();
}
