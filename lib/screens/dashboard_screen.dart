import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:orex/extensions/common.dart';
import 'package:orex/screens/developer_sliders_screen.dart';
import 'package:orex/screens/login_screen.dart';
import 'package:orex/screens/main_screen.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import '../components/add_property_dialouge.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../screens/profile_screen.dart';
import '../screens/subscribe_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../components/limit_exceed_dialog.dart';
import '../extensions/LiveStream.dart';
import '../extensions/colors.dart';
import '../extensions/double_press_back_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'category_screen.dart';
import 'favourite_screen.dart';
import 'limit_screen.dart';

class DashboardScreen extends StatefulWidget {
  int? transactionType;
  bool isSplash;
  DashboardScreen({super.key, this.transactionType, this.isSplash = true});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  bool isSplashActive = true;
  List<Widget> getTabs() {
    List<Widget> screens = [];

    screens.add(
      isSplashActive
          ? MainScreen()
          : CategoryScreen(transactionType: widget.transactionType),
    );

    if (appStore.isLoggedIn) {
      screens.add(FavouriteScreen());
      screens.add(
        DeveloperSlidersScreen(),
      );
    }

    screens.add(ProfileScreen());

    return screens;
  }

  // late List<Widget> tabs = [
  //   // HomeScreen(),
  //   // CategoryScreen(
  //   //   transactionType: widget.transactionType,
  //   // ),
  //   isSplashActive
  //       ? MainScreen()
  //       : CategoryScreen(
  //           transactionType: widget.transactionType,
  //         ),
  //   if (appStore.isLoggedIn) ...[
  //     FavouriteScreen(),
  //     DeveloperScreen(),
  //     ProfileScreen(),
  //   ]
  // ];
  // PickResult? selectedPlace;
  bool received = true;
  @override
  void initState() {
    super.initState();
    isSplashActive = widget.isSplash;
    // tabs = [
    //   // HomeScreen(),
    //   // CategoryScreen(
    //   //   transactionType: widget.transactionType,
    //   // ),
    //   isSplashActive
    //       ? MainScreen()
    //       : CategoryScreen(
    //           transactionType: widget.transactionType,
    //         ),
    //   FavouriteScreen(),
    //   ProfileScreen()
    // ];
    OneSignal.User.pushSubscription.optIn();
    init();
  }

  void init() async {
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(
            MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
    getSettingList();

    LiveStream().on("LANGUAGE", (s) {
      setState(() {});
    });
  }

  Future<void> getSettingList() async {
    await getSettingApi().then((value) {
      userStore.setCurrencyCodeID(value.currencySetting!.symbol.validate());
      userStore
          .setCurrencyPositionID(value.currencySetting!.position.validate());

      userStore.setCurrencyCode(value.currencySetting!.code.validate());
      for (int i = 0; i < value.data!.length; i++) {
        switch (value.data![i].key) {
          case "terms_condition":
            {
              userStore.setTermsCondition(value.data![i].value.validate());
            }
          case "privacy_policy":
            {
              userStore.setPrivacyPolicy(value.data![i].value.validate());
            }
          case "ONESIGNAL_APP_ID":
            {
              userStore.setOneSignalAppID(value.data![i].value.validate());
            }
          case "ONESIGNAL_REST_API_KEY":
            {
              userStore.setOnesignalRestApiKey(value.data![i].value.validate());
            }
          case "ADMOB_BannerId":
            {
              userStore.setAdmobBannerId(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialId":
            {
              userStore.setAdmobInterstitialId(value.data![i].value.validate());
            }
          case "ADMOB_BannerIdIos":
            {
              userStore.setAdmobBannerIdIos(value.data![i].value.validate());
            }
          case "ADMOB_InterstitialIdIos":
            {
              userStore
                  .setAdmobInterstitialIdIos(value.data![i].value.validate());
            }
          case "subscription_system":
            {
              userStore.setSubscription(value.data![i].value.validate());
            }
          case "CHATGPT_API_KEY":
            {
              userStore.setChatGptApiKey(value.data![i].value.validate());
            }
        }
      }
      getSettingData();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
      appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.dark);
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: DoublePressBackWidget(
          child: AnimatedContainer(
              color: context.cardColor,
              duration: const Duration(seconds: 1),
              child: getTabs()[appStore.isLoggedIn
                  ? currentIndex
                  : currentIndex == 3
                      ? 1
                      : 0]
              // IndexedStack(index: currentIndex, children: tabs
              ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: language.addProperties,
          child: Icon(Icons.add, size: 44, color: Colors.white),
          onPressed: () {
            if (!appStore.isLoggedIn) {
              toast('Please login to access this section');
              LoginScreen().launch(context, isNewTask: false);
              return;
            }
            userStore.subscription == "1"
                ? userStore.isSubscribe != 0
                    ? userStore.subscriptionDetail!.subscriptionPlan!
                                .packageData!.addProperty ==
                            0
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return userStore.addLimitCount == 0
                                  ? LimitExceedDialog(
                                      onTap: () {
                                        finish(context);
                                        LimitScreen(limit: "add_property")
                                            .launch(context);
                                      },
                                    )
                                  : AddPropertyDialog();
                            },
                          )
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return AddPropertyDialog();
                            },
                          )
                    : SubscribeScreen().launch(context)
                : showDialog(
                    context: context,
                    builder: (context) {
                      return AddPropertyDialog();
                    },
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: StylishBottomBar(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : primaryVariant,
          option: AnimatedBarOptions(iconStyle: IconStyle.Default),
          currentIndex: currentIndex,
          hasNotch: true,
          fabLocation: StylishBarFabLocation.center,
          onTap: (index) {
            if (!appStore.isLoggedIn && (index == 1 || index == 2)) {
              toast('Please login to access this section');
              LoginScreen().launch(context, isNewTask: false);
              return;
            }
            var type = userStore.userType;
            log("type : $type");
            if (type != 'developer' && index == 2) {
              toast('must your role is developer by admins');
              return;
            }
            currentIndex = index;
            isSplashActive = true;
            setState(() {});
          },
          items: [
            BottomBarItem(
              icon: Image.asset(ic_home,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_home_fill,
                  height: 24, width: 24, color: primaryColor),
              title: Text(
                language.home,
                style: TextStyle(color: primaryColor),
              ),
            ),
            // BottomBarItem(
            //   icon: Image.asset(ic_category,
            //       height: 24, width: 24, color: primaryColor),
            //   selectedIcon: Image.asset(ic_category_fill,
            //       height: 24, width: 24, color: primaryColor),
            //   title: SizedBox(),
            // ),
            BottomBarItem(
              icon: Image.asset(ic_favorite,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_favorite_fill,
                  height: 24, width: 24, color: primaryColor),
              title: Text(
                language.favourite,
                style: TextStyle(color: primaryColor),
              ),
            ),
            // if (userStore.userType == 'developer')
            BottomBarItem(
              icon: Image.asset(ic_category,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_category_fill,
                  height: 24, width: 24, color: primaryColor),
              title: Text(
                language.developer,
                style: TextStyle(color: primaryColor),
              ),
            ),
            BottomBarItem(
              icon: Image.asset(ic_profile,
                  height: 24, width: 24, color: primaryColor),
              selectedIcon: Image.asset(ic_profile_fill,
                  height: 24, width: 24, color: primaryColor),
              title: Text(
                language.profile,
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
