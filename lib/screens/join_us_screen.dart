import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orex/extensions/app_button.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/generated/assets.dart';
import 'package:orex/main.dart';
import 'package:orex/network/RestApis.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/login_screen.dart';
import 'package:orex/utils/colors.dart';
import 'package:orex/utils/images.dart';
import 'package:orex/utils/static_translations.dart';

import '../extensions/text_styles.dart';
import '../utils/app_common.dart';

class JoinUsScreen extends StatefulWidget {
  const JoinUsScreen({super.key});

  @override
  State<JoinUsScreen> createState() => _JoinUsScreenState();
}

class _JoinUsScreenState extends State<JoinUsScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   // Use WidgetsBinding to ensure context is available
  //   // Only run guest login on iOS platform
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // if (Platform.isIOS) {
  //     _performGuestLogin();
  //     // }
  //   });
  // }

  Future<void> _performGuestLogin() async {
    try {
      await appStore.setLoading(true);
      await guestLoginApi().then((response) {
        if (response.data != null && response.data!.apiToken != null) {
          // Guest login successful, navigate to dashboard
          debugPrint(response.data!.apiToken);
          if (mounted) {
            DashboardScreen(
              isSplash: true,
            ).launch(context, isNewTask: true);
          }
        } else {
          // If guest login fails, still allow guest mode without token
          if (mounted) {
            DashboardScreen(
              isSplash: true,
            ).launch(context, isNewTask: true);
          }
        }
      }).catchError((e) {
        // If guest login endpoint doesn't exist or fails,
        // still allow guest mode (will handle errors gracefully)
        print("Guest login error in initState: $e");
        if (mounted) {
          DashboardScreen(
            isSplash: true,
          ).launch(context, isNewTask: true);
        }
      }).whenComplete(() {
        if (mounted) {
          appStore.setLoading(false);
        }
      });
    } catch (e) {
      print("Guest login exception in initState: $e");
      if (mounted) {
        appStore.setLoading(false);
        // Still navigate to dashboard even if guest login fails
        DashboardScreen(
          isSplash: true,
        ).launch(context, isNewTask: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              80.height,
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
              //     _performGuestLogin();
              //   },
              // ).paddingOnly(right: 16, bottom: 16, left: 16, top: 0),
              150.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                  onPressed: () {
                    final phone = "+201096968482"
                        .replaceAll('+', '')
                        .replaceAll(':', '')
                        .trim();

                    commonLaunchUrl('https://wa.me/$phone');
                  },
                  child: Text(
                    translateKeywords("الدعم الفني", appStore.selectedLanguage),
                    style:  secondaryTextStyle()
                  ),
                ),
                  ImageIcon(AssetImage(ic_call)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
