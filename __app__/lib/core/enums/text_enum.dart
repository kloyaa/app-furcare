import 'package:flutter/material.dart';

enum AppTextSize {
  xss(9),
  xs(12),
  sm(14),
  md(16),
  mlg(24),
  lg(32),
  xl(64);

  const AppTextSize(this.size);
  final double size;
}

enum AppFontWeight {
  thin(FontWeight.w100),
  normal(FontWeight.w400),
  semibold(FontWeight.w500),
  bold(FontWeight.w600),
  black(FontWeight.w900);

  const AppFontWeight(this.value);

  final FontWeight value;
}
