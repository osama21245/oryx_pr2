import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orex/screens/join_us_screen.dart';

import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/shared_pref.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../languageConfiguration/ServerLanguageResponse.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../screens/walk_through_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'dashboard_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    appStore.setLoading(true);

    String versionNo = await getStringAsync(CURRENT_LAN_VERSION,
        defaultValue: LanguageVersion);
    await getLanguageList(versionNo).then((value) {
      appStore.setLoading(false);
      if (value.status == true) {
        setValue(CURRENT_LAN_VERSION, value.currentVersionNo.toString());
        if (value.data!.length > 0) {
          defaultServerLanguageData = value.data;
          performLanguageOperation(defaultServerLanguageData);
          setValue(LanguageJsonDataRes, value.toJson());
          // ✅ Check if user has already selected a language
          String? savedLangCode = getStringAsync(SELECTED_LANGUAGE_CODE);
          bool isSetLanguage =
              getBoolAsync(IS_SELECTED_LANGUAGE_CHANGE, defaultValue: false);
          
          if (!isSetLanguage && savedLangCode.isEmpty) {
            // ✅ Only set server default if no user selection exists
            for (int i = 0; i < value.data!.length; i++) {
              int isDefaultLang = value.data![i].isDefaultLanguage ?? 0;
              if (isDefaultLang == 1) {
                setValue(SELECTED_LANGUAGE_CODE, value.data![i].languageCode);
                setValue(
                    SELECTED_LANGUAGE_COUNTRY_CODE, value.data![i].countryCode);
                appStore.setLanguage(value.data![i].languageCode!,
                    context: context);
                break;
              }
            }
          } else if (savedLangCode.isNotEmpty) {
            // ✅ User has selected a language - use it with server data
            appStore.setLanguage(savedLangCode, context: context);
            print('🌍 Using saved language with server data: $savedLangCode');
          }
        } else {
          defaultServerLanguageData = [];
          selectedServerLanguageData = null;
          setValue(LanguageJsonDataRes, "");
        }
      } else {
        String getJsonData =
            getStringAsync(LanguageJsonDataRes, defaultValue: "");
        if (getJsonData.isNotEmpty) {
          ServerLanguageResponse languageSettings =
              ServerLanguageResponse.fromJson(json.decode(getJsonData.trim()));
          if (languageSettings.data!.length > 0) {
            defaultServerLanguageData = languageSettings.data;
            performLanguageOperation(defaultServerLanguageData);
          }
        }
      }
    }).catchError((error) {
      appStore.setLoading(false);
      print(error);
    });

    //await 3.seconds.delay;
    if (!getBoolAsync(IS_FIRST_TIME)) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else {
      if (appStore.isLoggedIn) {
        // MainScreen().launch(context, isNewTask: true);
        DashboardScreen(
          isSplash: true,
        ).launch(context, isNewTask: true);
      } else {
        JoinUsScreen().launch(context, isNewTask: false);
        // MainScreen().launch(context, isNewTask: false);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Image.asset(splash, fit: BoxFit.fill).center(),
          ],
        ),
      ),
    );
  }
}
