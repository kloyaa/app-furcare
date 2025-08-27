import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';

class CustomText extends StatelessWidget {
  final String text;
  final AppTextSize size;
  final FontWeight? fontWeight;
  final Color? color;
  final double? opacity;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? lineHeight;
  final TextStyle? style;

  const CustomText(
    this.text, {
    super.key,
    this.size = AppTextSize.sm,
    this.fontWeight,
    this.color,
    this.opacity,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.lineHeight,
    this.style,
  });

  // Factory constructors for common text styles
  factory CustomText.title(
    String text, {
    Key? key,
    AppTextSize size = AppTextSize.lg,
    FontWeight? fontWeight = FontWeight.bold,
    Color? color,
    double? opacity,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    double? letterSpacing,
    double? lineHeight,
    TextStyle? style,
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      style: style,
    );
  }

  factory CustomText.subtitle(
    String text, {
    Key? key,
    AppTextSize size = AppTextSize.md,
    FontWeight? fontWeight,
    Color? color,
    double? opacity = 0.6,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    double? letterSpacing,
    double? lineHeight,
    TextStyle? style,
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      style: style,
    );
  }

  factory CustomText.body(
    String text, {
    Key? key,
    AppTextSize size = AppTextSize.sm,
    FontWeight? fontWeight,
    Color? color,
    double? opacity,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    double? letterSpacing,
    double? lineHeight,
    TextStyle? style,
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      style: style,
    );
  }

  factory CustomText.caption(
    String text, {
    Key? key,
    AppTextSize size = AppTextSize.xs,
    FontWeight? fontWeight,
    Color? color,
    double? opacity = 0.7,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    double? letterSpacing,
    double? lineHeight,
    TextStyle? style,
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.colorScheme.onSurface;
    final finalColor = opacity != null
        // ignore: deprecated_member_use
        ? textColor.withAlpha((opacity! * 255).round())
        : textColor;

    // Create base style from individual properties
    final baseStyle = TextStyle(
      fontSize: size.size,
      fontWeight: fontWeight,
      color: finalColor,
      decoration: decoration,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );

    // Merge with optional style parameter
    final finalStyle = style != null ? baseStyle.merge(style) : baseStyle;

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
