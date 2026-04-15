import 'package:flutter/material.dart';

class AppColors {
  // Modern, softer green
  static const Color primary = Color(0xFF1B5E20); // Deep forest green
  static const Color primaryLight = Color(
    0xFF4CAF50,
  ); // Vibrant green for accents
  static const Color primaryDark = Color(0xFF0A2F0D); // Darker for contrast

  // Warm accent for ratings/CTAs
  static const Color secondary = Color(0xFFFF8F00); // Amber

  // Neutrals
  static const Color background = Color(0xFFF8F9FA); // Very light gray
  static const Color surface = Color(0xFFFFFFFF); // White for cards
  static const Color surfaceVariant = Color(
    0xFFF1F3F4,
  ); // Slightly darker for sections

  // Text - better contrast
  static const Color textPrimary = Color(0xFF202124); // Near black
  static const Color textSecondary = Color(0xFF5F6368); // Medium gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary

  // Status
  static const Color success = Color(0xFF1E8E3E); // Green
  static const Color error = Color(0xFFD93025); // Red
  static const Color warning = Color(0xFFF9AB00); // Yellow
  static const Color border = Color(0xFFDADCE0); // Light gray border

  AppColors._();
}
