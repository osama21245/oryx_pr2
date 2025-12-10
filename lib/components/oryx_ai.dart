import 'package:flutter/material.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/utils/images.dart';
import '../screens/search_screen.dart';
import '../utils/colors.dart';

class OryxAIFloatingButton extends StatelessWidget {
  const OryxAIFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16),
      child: FloatingActionButton(
        onPressed: () {
          SearchScreen(
            isBack: true,
            openVoiceDialog: true,
          ).launch(context);
        },
        backgroundColor: primaryColor,
        elevation: 8,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            app_logo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
