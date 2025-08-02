import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AppTextSize titleSize;
  final AppTextSize subtitleSize;
  final FontWeight? titleWeight;
  final FontWeight? subtitleWeight;
  final Color? titleColor;
  final Color? subtitleColor;
  final double? subtitleOpacity;
  final TextAlign? textAlign;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleSize = AppTextSize.lg,
    this.subtitleSize = AppTextSize.md,
    this.titleWeight = FontWeight.bold,
    this.subtitleWeight,
    this.titleColor,
    this.subtitleColor,
    this.subtitleOpacity = 0.6,
    this.textAlign,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        CustomText.title(
          title,
          size: titleSize,
          fontWeight: titleWeight,
          color: titleColor,
          textAlign: textAlign,
        ),
        if (subtitle != null) ...[
          SizedBox(height: spacing),
          CustomText.subtitle(
            subtitle!,
            size: subtitleSize,
            fontWeight: subtitleWeight,
            color: subtitleColor,
            opacity: subtitleOpacity,
            textAlign: textAlign,
          ),
        ],
      ],
    );
  }
}
