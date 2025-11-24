import 'package:flutter/material.dart';
import 'package:orex/extensions/app_button.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/generated/assets.dart';
import 'package:orex/main.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/login_screen.dart';
import 'package:orex/utils/colors.dart';

class JoinUsScreen extends StatelessWidget {
  const JoinUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.joinus,
            ),
            15.height,
            Text(
              language.registerNow,
              style: TextStyle(
                  color: appStore.isDarkModeOn ? Colors.white : Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
            20.height,
            AppButton(
              text: language.login,
              width: context.width(),
              color: primaryColor,
              textColor: Colors.white,
              onTap: () {
                LoginScreen().launch(context, isNewTask: false);
              },
            ).paddingOnly(right: 16, bottom: 16, left: 16, top: 0),
            // AppButton(
            //   text: language.continueAsGuest,
            //   width: context.width(),
            //   color: Color(0xffE9E9E9),
            //   textColor: primaryColor,
            //   onTap: () {
            //     DashboardScreen(
            //       isSplash: true,
            //     ).launch(context, isNewTask: false);
            //   },
            // ).paddingOnly(right: 16, bottom: 16, left: 16, top: 0),
          ],
        ),
      ),
    );
  }
}
