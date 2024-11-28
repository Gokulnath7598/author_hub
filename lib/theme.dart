import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.redAccent,
      error: Colors.redAccent,
      primary: Colors.redAccent,
      secondary: Colors.redAccent,
      tertiary: const Color(0xFF442C2E)),
  textTheme: TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp, color: const Color(0xFF442C2E)),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp, color: const Color(0xFF442C2E)),
    titleSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xFF442C2E)),
    headlineLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xFF442C2E)),
    headlineMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: const Color(0xFF442C2E)),
    headlineSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF442C2E)),
    bodyLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.sp, color: const Color(0xFF442C2E)),
    bodyMedium: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.sp, color: const Color(0xFF442C2E)),
    bodySmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 13.sp, color: const Color(0xFF442C2E))
  ),
);
