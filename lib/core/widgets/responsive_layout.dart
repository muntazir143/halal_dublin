// lib/core/widgets/responsive_layout.dart
import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isWideScreen(context)) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
