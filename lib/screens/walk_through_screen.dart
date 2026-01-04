import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orex/screens/join_us_screen.dart';
import '../../extensions/app_button.dart';
import '../../extensions/extension_util/context_extensions.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/widget_extensions.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../main.dart';
import '../models/walk_through_model.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController mPageController = PageController();

  List<WalkThroughModel> mWalkList = [];
  List<IntroLanguageModel> mLanguages = [];
  int mCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mLanguages.add(IntroLanguageModel(
        name: "العربية",
        code: "ar",
        countryCode: "ar-EG",
        flagImage: "assets/eg.png"));
    mLanguages.add(IntroLanguageModel(
        name: "English",
        code: "en",
        countryCode: "en-US",
        flagImage: "assets/us.png"));
    mLanguages.add(IntroLanguageModel(
        name: "Русский",
        code: "ru",
        countryCode: "ru-RU",
        flagImage: "assets/ru.png"));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    mPageController.dispose();
    super.dispose();
  }
  void _selectLanguage(IntroLanguageModel langData) async {
    await setValue(SELECTED_LANGUAGE_CODE, langData.code);
    await setValue(SELECTED_LANGUAGE_COUNTRY_CODE, langData.countryCode);
    await setValue(IS_SELECTED_LANGUAGE_CHANGE, true);

    appStore.setLanguage(langData.code, context: context);

    mPageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {
    mWalkList.clear();
    mWalkList.add(WalkThroughModel(
        image: ic_walk1,
        title: language.WALK1_TITLE,
        title1: language.WALK1_TITLE1,
        title2: language.WALK1_TITLE_1));
    mWalkList.add(WalkThroughModel(
        image: ic_walk2,
        title: language.WALK2_TITLE,
        title1: language.WALK2_TITLE2,
        title2: language.WALK2_TITLE_2));
    mWalkList.add(WalkThroughModel(
        image: ic_walk3,
        title: language.WALK3_TITLE,
        title1: language.WALK3_TITLE3,
        title2: language.WALK3_TITLE_3));
    int totalPages = mWalkList.length + 1;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
          body: Stack(
        children: [
          PageView.builder(
            controller: mPageController,
            itemCount: totalPages,
            onPageChanged: (i) {
              setState(() {
                mCurrentIndex = i;
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ic_logo, height: 100, width: 100).paddingBottom(30),

                    Text("Choose Your Language", style: boldTextStyle(size: 24)),
                    Text("اختر لغتك المفضلة", style: secondaryTextStyle(size: 16)),
                    30.height,
                    ...mLanguages.map((lang) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor:
                          appStore.isDarkModeOn ? cardDarkColor : Colors.grey.shade100,
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectLanguage(lang),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(lang.flagImage, width: 32, height: 32),
                                  16.width,
                                  Text(lang.name, style: boldTextStyle()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ).center();
              }
              int walkIndex = index - 1;
              return Column(
                children: [
                  Image.asset(mWalkList[walkIndex].image!,
                      height: context.height() * 0.50, fit: BoxFit.fill),
                ],
              ).paddingTop(context.statusBarHeight + 30);
            },
          ),
          if (mCurrentIndex > 0)
            Positioned(
              right: 24,
              left: 24,
              bottom: context.statusBarHeight + 70,
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: mWalkList[mCurrentIndex - 1]
                                .title1
                                .toString()
                                .toUpperCase(),
                            style: boldTextStyle(size: 20)),
                        TextSpan(
                            text: " ${mWalkList[mCurrentIndex - 1]
                                .title2
                                .toString()
                                .toUpperCase()}",
                            style: boldTextStyle(color: primaryColor, size: 20)),
                      ],
                    ),
                  ),
                  16.height,
                  Text(mWalkList[mCurrentIndex - 1].title.toString(),
                      style: secondaryTextStyle(size: 16),
                      textAlign: TextAlign.center),
                  16.height,
                  dotIndicator(mWalkList, mCurrentIndex - 1),

                  40.height,
                  AppButton(
                    text: (mCurrentIndex - 1) == 2 ? language.getStarted : language.next,
                    width: context.width(),
                    color: primaryColor,
                    onTap: () {
                      if ((mCurrentIndex - 1) >= 2) {
                        setValue(IS_FIRST_TIME, true);
                        JoinUsScreen().launch(context, isNewTask: true);
                      } else {
                        mPageController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.linearToEaseOut);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
          ),
      ),
    );
  }
}
