import 'package:flutter/widgets.dart';

class Responsive {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  // Check if screen is mobile (< 600)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  // Check if screen is tablet (600 - 900)
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  // Check if screen is desktop (>= 900)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Convenience: is wide screen (tablet or desktop)
  static bool isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint;
}
