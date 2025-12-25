import 'package:flutter/material.dart';
import 'package:orex/main.dart';
import 'package:orex/utils/static_translations.dart';
import '../extensions/colors.dart';
import '../extensions/text_styles.dart';

class RequiredValidationText extends StatefulWidget {
  final String? titleText;
  final bool required;

  const RequiredValidationText(
      {super.key, this.required = false, this.titleText});

  @override
  State<RequiredValidationText> createState() => _RequiredValidationTextState();
}

class _RequiredValidationTextState extends State<RequiredValidationText> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: primaryTextStyle(size: 14),
        children: <TextSpan>[
          TextSpan(
              text: "${widget.titleText} ", style: primaryTextStyle(size: 14)),
          widget.required
              ? TextSpan(text: ' *', style: secondaryTextStyle(color: redColor))
              : TextSpan(
                  children: [
                      TextSpan(text: "("),
                      TextSpan( text: translateKeywords("اختياري", appStore.selectedLanguage),),
                      TextSpan(text: ")"),
                    ],
                  style: primaryTextStyle(size: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
