import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';

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
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
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
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
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
  }) {
    return CustomText(
      text,
      key: key,
      size: size,
      fontWeight: fontWeight,
      color: color,
      opacity: opacity,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.colorScheme.onSurface;
    final finalColor = opacity != null
        // ignore: deprecated_member_use
        ? textColor.withOpacity(opacity!)
        : textColor;

    return Text(
      text,
      style: TextStyle(
        fontSize: size.size,
        fontWeight: fontWeight,
        color: finalColor,
        decoration: decoration,
        letterSpacing: letterSpacing,
        height: lineHeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
