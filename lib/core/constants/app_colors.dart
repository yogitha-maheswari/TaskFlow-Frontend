import 'package:flutter/material.dart';

/// Centralized color system
/// MUST be the single source of truth for colors
class AppColors {
  // ------------------------------
  // Base surfaces
  // ------------------------------
  static const Color background = Color(0xFF0B0C0F);
  static const Color surface = Color(0xFF14161C);
  static const Color surfaceSoft = Color(0xFF1B1E26);
  static const Color surfaceGlass = Color(0xFF161922);

  // ------------------------------
  // Borders & dividers
  // ------------------------------
  static const Color border = Color(0xFF232632);
  static const Color divider = Color(0xFF232632);

  // ------------------------------
  // Text colors
  // ------------------------------
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9AA0AA);
  static const Color textMuted = Color(0xFF6F7480);

  // ------------------------------
  // Brand / actions (MATCHES YOUR THEME)
  // ------------------------------
  static const Color primary = Color.fromARGB(255, 104, 141, 241);
  static const Color primarySoft = Color.fromARGB(180, 104, 141, 241);

  // ------------------------------
  // Status colors (MATCHES YOUR THEME)
  // ------------------------------
  static const Color success = Color.fromARGB(255, 123, 222, 191);
  static const Color danger = Color.fromARGB(255, 251, 120, 103);
  static const Color warning = Color(0xFFF2C94C);
  static const Color overdueDot = Color.fromARGB(255, 251, 120, 103);

  // ------------------------------
  // Category colors (derived, UI-safe)
  // ------------------------------
  static const Color personal = Color.fromARGB(255, 123, 222, 191);
  static const Color work = primary;
  static const Color college = Color(0xFF9B51E0);
  static const Color house = Color(0xFFF2994A);
  static const Color important = danger;
  static const Color shop = Color(0xFF56CCF2);
  static const Color travel = Color(0xFF6FCF97);
  static const Color music = Color(0xFFFFA726);

  // ------------------------------
  // Overlays & shadows
  // ------------------------------
  static const Color modalBarrier = Colors.black54;
  static const Color shadowSoft = Colors.black38;
}
