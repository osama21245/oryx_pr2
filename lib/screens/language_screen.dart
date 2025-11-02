import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../components/app_bar_components.dart';
import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../languageConfiguration/LanguageDefaultJson.dart';
import '../languageConfiguration/ServerLanguageResponse.dart';
import '../main.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<LanguageJsonData> get allLanguageOptions {
    List<LanguageJsonData> options = [];

    // Add system default option as first item
    options.add(LanguageJsonData(
      id: -1, // Special ID for system default
      languageName: language.systemDefault,
      languageCode: 'system_default',
      countryCode: 'system_default',
      isDefaultLanguage: 0,
    ));

    // Add server language data
    if (defaultServerLanguageData != null) {
      options.addAll(defaultServerLanguageData!);
    }

    return options;
  }

  String get currentSelectedLanguageCode {
    String savedCode = getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguageCode);

    // If no language is selected or it's empty, consider it as system default
    if (savedCode.isEmpty || !getBoolAsync(IS_SELECTED_LANGUAGE_CHANGE, defaultValue: false)) {
      return 'system_default';
    }

    return savedCode;
  }

  String getSystemLanguageCode() {
    final Locale systemLocale = PlatformDispatcher.instance.locale;
    String systemLangCode = systemLocale.languageCode;

    // Check if system language is supported
    if (defaultServerLanguageData != null) {
      bool isSupported = defaultServerLanguageData!.any((lang) => lang.languageCode == systemLangCode);
      if (isSupported) {
        return systemLangCode;
      }
    }

    // Fallback to default language if system language is not supported
    return defaultLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(language.language, context1: context, titleSpace: 0),
        body: AnimatedListView(
          itemCount: allLanguageOptions.length,
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            LanguageJsonData data = allLanguageOptions[index];
            bool isSelected = currentSelectedLanguageCode == data.languageCode.validate();

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              margin: EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: isSelected
                      ? primaryColor
                      : appStore.isDarkModeOn
                          ? cardDarkColor
                          : primaryExtraLight),
              child: Column(
                children: [
                  Row(children: [
                    // Show system language info for system default option
                    if (data.languageCode == 'system_default') ...[
                      Icon(
                        Icons.phone_android,
                        size: 24,
                        color: isSelected ? Colors.white : primaryColor,
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.languageName.validate(),
                              style: boldTextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : appStore.isDarkModeOn
                                          ? Colors.white
                                          : Colors.black)),
                          Text('(${getSystemLanguageCode().toUpperCase()})',
                              style: secondaryTextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : appStore.isDarkModeOn
                                          ? Colors.white70
                                          : Colors.black54,
                                  size: 12)),
                        ],
                      ).expand(),
                    ] else ...[
                      16.width,
                      Text(data.languageName.validate(),
                              style: boldTextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : appStore.isDarkModeOn
                                          ? Colors.white
                                          : Colors.black))
                          .expand(),
                    ],
                    isSelected
                        ? Image.asset(ic_radio_fill, height: 20, width: 20, color: Colors.white)
                        : Image.asset(ic_radio, color: primaryColor, height: 20, width: 20)
                  ]),
                  4.height,
                ],
              ).paddingSymmetric(vertical: 4).onTap(() async {
                if (data.languageCode == 'system_default') {
                  // Handle system default selection
                  await setValue(SELECTED_LANGUAGE_CODE, '');
                  await setValue(SELECTED_LANGUAGE_COUNTRY_CODE, '');
                  await setValue(IS_SELECTED_LANGUAGE_CHANGE, false);
                  selectedServerLanguageData = null;

                  // Apply system language
                  String systemLangCode = getSystemLanguageCode();
                  appStore.setLanguage(systemLangCode, context: context);
                } else {
                  // Handle regular language selection
                  await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                  await setValue(SELECTED_LANGUAGE_COUNTRY_CODE, data.countryCode);
                  selectedServerLanguageData = data;
                  await setValue(IS_SELECTED_LANGUAGE_CHANGE, true);
                  appStore.setLanguage(data.languageCode!, context: context);
                }

                finish(context, true);
                setState(() {});
              }),
            );
          },
        ),
      ),
    );
  }
}
