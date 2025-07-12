import 'package:flutter/material.dart';

enum AppTextSize {
  xs(12),
  sm(14),
  md(16),
  lg(32),
  xl(64);

  const AppTextSize(this.size);
  final double size;
}

enum AppFontWeight {
  normal(FontWeight.w400),
  semibold(FontWeight.w500),
  bold(FontWeight.w600);

  const AppFontWeight(this.value);

  final FontWeight value;
}
