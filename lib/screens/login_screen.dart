import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:orex/network/RestApis.dart';
import 'package:orex/screens/otp_screen.dart';
import 'package:orex/screens/signup_screen.dart';
import 'package:orex/utils/otp_utils.dart';
import 'package:orex/utils/static_translations.dart';
import '../../../extensions/app_text_field.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../languageConfiguration/LanguageDataConstant.dart';
import '../main.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  TextEditingController mMobileNumberCont = TextEditingController();
  FocusNode mMobileFocus = FocusNode();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
    mMobileNumberCont.addListener(() {
      final text = mMobileNumberCont.text;
      if (text.startsWith('0')) {
        mMobileNumberCont.text = text.substring(1);
        mMobileNumberCont.selection = TextSelection.fromPosition(
          TextPosition(offset: mMobileNumberCont.text.length),
        );
      }
    });
  }

  Future<void> init() async {
    if (getStringAsync(PLAYER_ID).isEmpty) {
      await saveOneSignalPlayerId().then((value) {
        //
      });
    }
    await getUserToken();
    appStore.setLoading(false);
  }

//await otpLogInApi({"mobile": number});
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<String?> getUserToken() async {
    try {
      //String userId = await getStringAsync(USER_ID);
      String token = getStringAsync(TOKEN);
      if (token.isNotEmpty) {
        return token;
      } else {
        print("No user is currently signed in.");
        return null;
      }
    } catch (e) {
      print("Error getting user UID: $e");
      return null;
    }
  }

  Future<void> sendOTP() async {
    if (otpCooldownSeconds > 0) {
      toast("انتظر $otpCooldownSeconds ثانية قبل إعادة الإرسال");
      return;
    }

    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      hideKeyboard(context);
      await appStore.setLoading(true);

      String number = '$countryCode${mMobileNumberCont.text.trim()}';
      if (!number.startsWith('+')) {
        number = '+$countryCode${mMobileNumberCont.text.trim()}';
      } //await OTPUtils.sendOTP(context,number);

      try {
        final res = await otpLogInApi({
          "username": number,
          "login_type": LoginTypeOTP,
        });
        // debugPrint(res.data.toString())

        await appStore.setLoading(false);

        if (res.isUserExist == false) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignUpScreen(
                phoneNumber: number,
                // isCodeSent: true,
              ),
            ),
          );
        } else if (res.isUserExist == true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => OTPScreen(
                        phoneNumber: number,
                        isComeFromLogin: true,
                      )));
          // finish(context);
          // HomeScreen().launch(context);
        }
      } catch (e) {
        await appStore.setLoading(false);

        print(
            "erorr is ==========${e.toString().contains('invalid_username')}");
        print("Full error is: ${e.toString()}");
      }
    }
  }

  //  "username": widget.phoneNumber!.replaceAll('+20', ''),
  //   "login_type": LoginTypeOTP,
  //   "accessToken": widget.phoneNumber!.replaceAll('+', ''),
  //   "contact_number": widget.phoneNumber,
  //   'player_id': getStringAsync(PLAYER_ID).validate(),
  // await loginWithOTP(
  //         context, number, mMobileNumberCont.text.trim(), true, () {})
  //     .catchError((e) async {
  //   await appStore.setLoading(false);
  //   setState(() {});
  // });
  // Future<void> sendOTP() async {
  //   if (loginFormKey.currentState!.validate()) {
  //     loginFormKey.currentState!.save();
  //     hideKeyboard(context);
  //     await appStore.setLoading(true);
  //     String number = '$countryCode${mMobileNumberCont.text.trim()}';
  //     if (!number.startsWith('+')) {
  //       number = '$mMobileNumberCont${mMobileNumberCont.text.trim()}';
  //     }
  //     await loginWithOTP(context, number, mMobileNumberCont.text.trim(), true, () {}).then((value)
  // {}).catchError((e) async {
  //       toast(e.toString());
  //       await appStore.setLoading(false);
  //       setState(() {});
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: Observer(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: context.statusBarHeight + 60, right: 16, left: 16),
                child: Form(
                  key: mFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(language.signIn,
                              style: boldTextStyle(size: 24))),
                      20.height,
                      Image.asset(ic_login,
                          fit: BoxFit.fill, height: context.height() * 0.4),
                      30.height,
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("${language.mobileNumber} :",
                              style: primaryTextStyle(
                                  size: 18,
                                  color: primaryColor,
                                  weight: FontWeight.w600))),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(translateKeywords("اختر كود الدولة", appStore.selectedLanguage),
                              style: TextStyle(color: grayColor))),
                      20.height,
                      Form(
                        key: loginFormKey,
                        child: AppTextField(
                          focus: mMobileFocus,
                          controller: mMobileNumberCont,
                          textFieldType: TextFieldType.PHONE,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          isValidationRequired: true,
                          suffix: mSuffixTextFieldIconWidget(ic_call_outlined),
                          decoration: defaultInputDecoration(context,
                              label: language.enterYourMobileNumber,
                              textStyle: TextStyle(color: grayColor),
                              mPrefix: IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CountryCodePicker(
                                      initialSelection: getCountryCode(),
                                      showCountryOnly: false,
                                      showFlag: false,
                                      boxDecoration: BoxDecoration(
                                          borderRadius: radius(defaultRadius),
                                          color:
                                              context.scaffoldBackgroundColor),
                                      showFlagDialog: true,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      textStyle:
                                          primaryTextStyle(color: grayColor),
                                      onInit: (c) {
                                        countryCode = c!.dialCode!;
                                      },
                                      onChanged: (c) {
                                        countryCode = c.dialCode!;
                                      },
                                    ),
                                    VerticalDivider(
                                        color: grayColor,
                                        endIndent: 12,
                                        indent: 12,
                                        width: 5),
                                    18.width,
                                  ],
                                ),
                              )),
                          onFieldSubmitted: (p0) {
                            sendOTP();
                          },
                        ),
                      ),
                      50.height,
                      AppButton(
                        text: language.signIn,
                        color: primaryColor,
                        width: context.width(),
                        textColor: Colors.white,
                        elevation: 0,
                        onTap: () async {
                          await sendOTP();
                        },
                      ),
                      20.height,
                    ],
                  ),
                ),
              ),
              Loader().center().visible(appStore.isLoading)
            ],
          );
        }),
      ),
    );
  }
}
