import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextWithLink extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onLinkTap;
  final TextAlign? textAlign;
  final Color? linkTextColor;

  const RichTextWithLink({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onLinkTap,
    this.textAlign,
    this.linkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: normalText, style: AppTextStyles.black12400),
          TextSpan(
            text: linkText,
            style: AppTextStyles.black13400.copyWith(
              color: linkTextColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}
