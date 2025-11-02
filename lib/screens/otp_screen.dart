import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/login_screen.dart';
import 'package:otp_text_field/otp_field.dart';
import '../extensions/app_button.dart';
import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../services/auth_service.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';

class OTPScreen extends StatefulWidget {
  final String? verificationId;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final bool? isComeFromLogin;
  final String? mobileNo;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;
  final Function? onCall;
  final String? gGovernorate;

  const OTPScreen({
    super.key,
    this.verificationId,
    this.gGovernorate,
    this.isCodeSent,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.credential,
    this.onCall,
    this.isComeFromLogin = false,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpCode = '';
  Timer? _timer;
  bool isResendEnabled = false;
  int resendTimeout = 60;

  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> resendOTP() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    resendTimeout = 60;
    isResendEnabled = false;
    setState(() {});
    await loginWithOTP(context, widget.phoneNumber.validate().trim(),
        widget.phoneNumber.validate().trim(), false, () {
      init();
      setState(() {});
    }).then((value) {
      setState(() {
        appStore.setLoading(false);
      });
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  // Future<void> submit() async {
  //   hideKeyboard(context);
  //   await appStore.setLoading(true);
  //   AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: widget.verificationId!, smsCode: otpCode);
  //   await FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .then((result) async {
  //     Map req = {
  //       "username": widget.phoneNumber!.replaceAll('+', ''),
  //       "login_type": LoginTypeOTP,
  //       // "user_type": LoginUser,
  //       "accessToken": widget.phoneNumber!.replaceAll('+', ''),
  //       "contact_number": widget.phoneNumber,
  //       'player_id': getStringAsync(PLAYER_ID).validate(),
  //     };
  //     await otpLogInApi(req).then((value) async {
  //       await setValue(IS_OTP, true);
  //       userStore.setPhoneNo(widget.phoneNumber!.replaceAll('+', ''));
  //       appStore.setLoading(false);
  //       if (value.isUserExist == false) {
  //         finish(context);
  //         SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', ''))
  //             .launch(context);
  //       } else {
  //         await appStore.setLogin(true);
  //         setValue(TOKEN, value.data!.apiToken.validate());
  //         userStore.setToken(value.data!.apiToken.validate());
  //         await getUSerDetail(context, value.data!.id.validate())
  //             .whenComplete(() {
  //           // MainScreen().launch(context, isNewTask: true);
  //           DashboardScreen().launch(context, isNewTask: true);
  //         });
  //       }
  //     }).catchError((e) async {
  //       print("Into otp Screen Error?");
  //       await appStore.setLoading(false);
  //       if (e.toString().contains('invalid_username')) {
  //         finish(context);
  //         SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', ''))
  //             .launch(context);
  //       } else {
  //         if (e.toString().contains('OTP is invalid'))
  //           toast(language.invalidOtp);
  //       }
  //     });
  //   }).catchError((e) async {
  //     log("error->" + e.toString());
  //     toast(e.toString());
  //     await appStore.setLoading(false);
  //     setState(() {});
  //   });
  // }

  Future<void> submit() async {
    hideKeyboard(context);
    await appStore.setLoading(true);
    var request = {
      "first_name": widget.firstName,
      "last_name": widget.lastName,
      "username": widget.phoneNumber,
      "address": widget.gGovernorate,
      "email": '${widget.firstName}@gmail.com',
      "password": getStringAsync(FIREBASE_USER_ID),
      "user_type": LoginUser,
      "login_type": LoginTypeOTP,
      "otp": otpCode,
      "status": ACTIVE,
      "contact_number": "${"+"}${widget.phoneNumber}",
    };

    var verifyOtp = {
      "username": widget.phoneNumber,
      "otp": otpCode,
      "login_type": LoginTypeOTP,
    };

    if (widget.isComeFromLogin == true) {
      try {
        await verifyOtpApi(verifyOtp, context).then((res) async {
          if (
              //res.status == true &&
              res.data != null &&
                  res.data!.apiToken != null &&
                  res.data!.id != null) {
            await userStore.setToken(res.data!.apiToken.validate());
            await userStore.setUserID(res.data!.id!);
            await getUSerDetail(context, res.data!.id.validate())
                .whenComplete(() {
              DashboardScreen().launch(context, isNewTask: true);
            });
            await appStore.setLogin(true);
            await userStore.setLogin(true);
            appStore.setLoading(false);
            await setValue(IS_OTP, true);
            userStore.setPhoneNo(widget.phoneNumber.replaceAll('+', ''));
            await appStore.setLogin(true);
            //DashboardScreen().launch(context, isNewTask: true);
            debugPrint("data is ${res.data.toString()}");

            finish(context);
            DashboardScreen().launch(context);
          } else {
            appStore.setLoading(false);
            toast(res.message ?? 'فشل التسجيل');
            debugPrint(" فشل التسجيل: ${res.message}");
          }
        });
      } catch (e) {
        appStore.setLoading(false);
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('otp is invalid')) {
          toast(language.invalidOtp);
        } else if (errorMessage.contains('invalid-verification-code')) {
          toast('الكود غير صحيح');
        } else if (errorMessage.contains('session-expired')) {
          toast('انتهت صلاحية الكود، حاول مرة أخرى');
        } else {
          toast(errorMessage ?? 'فشل التسجيل');
        }
        toast(errorMessage ?? 'فشل التسجيل');
        debugPrint(" فشل التسجيل: $errorMessage");
        setState(
          () {},
        );
      }
    } else {
      try {
        await signUpApi(
          request,
          context,
        ).then((res) async {
          if (
              //res.status == true &&
              res.data != null &&
                  res.data!.apiToken != null &&
                  res.data!.id != null) {
            await userStore.setToken(res.data!.apiToken.validate());
            await userStore.setUserID(res.data!.id!);

            await setValue(TOKEN, res.data!.apiToken);
            await setValue(USER_ID, res.data!.id);
            // await setValue(PLAYER_ID, res.data!.id);
            await setValue(EMAIL, res.data!.email.validate());
            await setValue(USER_CONTACT_NUMBER, widget.phoneNumber);
            await appStore.setLogin(true);
            await userStore.setLogin(true);
            appStore.setLoading(false);
            await setValue(IS_OTP, true);
            userStore.setPhoneNo(widget.phoneNumber.replaceAll('+', ''));
            await appStore.setLogin(true);
            //DashboardScreen().launch(context, isNewTask: true);
            debugPrint("data is ${res.data.toString()}");
            finish(context);
            DashboardScreen().launch(context);
          } else {
            appStore.setLoading(false);
            toast(res.message ?? 'فشل التسجيل');
            debugPrint(" فشل التسجيل: ${res.message}");
          }
        });
      } catch (e) {
        await appStore.setLoading(false);
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('invalid_username')) {
          finish(context);
          LoginScreen(
                  //phoneNumber: widget.phoneNumber!.replaceAll('+', ''),
                  )
              .launch(context);
        } else if (errorMessage.contains('otp is invalid')) {
          toast(language.invalidOtp);
        } else if (errorMessage.contains('invalid-verification-code')) {
          toast('الكود غير صحيح');
        } else if (errorMessage.contains('session-expired')) {
          toast('انتهت صلاحية الكود، حاول مرة أخرى');
        } else {
          toast('حدث خطأ: $e');
        }
        log("error->$e");

        setState(() {});
      }
    }
  }
  // AuthCredential credential = PhoneAuthProvider.credential(
  //   verificationId: widget.verificationId!,
  //   smsCode: otpCode,
  // );
  // try {
  //   // أول خطوة: التحقق من الكود مع Firebase
  //   //  await FirebaseAuth.instance.signInWithCredential(credential);
  //   // ثاني خطوة: التحقق من المستخدم مع الـ API
  //   // Map req = {
  //   //   "username": widget.phoneNumber!.replaceAll('+20', ''),
  //   //   "login_type": LoginTypeOTP,
  //   //   "accessToken": widget.phoneNumber!.replaceAll('+', ''),
  //   //   "contact_number": widget.phoneNumber,
  //   //   'player_id': getStringAsync(PLAYER_ID).validate(),
  //   // };
  //   try {
  //     // var value = await otpLogInApi(req);
  //     //await setValue(IS_OTP, true);
  //userStore.setPhoneNo(widget.phoneNumber!.replaceAll('+', ''));
  // setValue(TOKEN, value.data!.apiToken.validate());
  // userStore.setToken(value.data!.apiToken.validate());
  // await appStore.setLogin(true);
  // appStore.setLoading(false);
  // if (value.isUserExist == false) {
  //   // المستخدم مش موجود → افتح SignUp
  //   finish(context);
  //   SignUpScreen(
  //     phoneNumber: widget.phoneNumber!.replaceAll('+', ''),
  //   ).launch(context);
  //   } else {
  //     // المستخدم موجود → سجل دخوله
  //     await appStore.setLogin(true);
  //     setValue(TOKEN, value.data!.apiToken.validate());
  //     userStore.setToken(value.data!.apiToken.validate());
  //     await getUSerDetail(context, value.data!.id.validate())
  //         .whenComplete(() {
  //       DashboardScreen().launch(context, isNewTask: true);
  //     });
  //   }
  // } catch (e) {
  // await appStore.setLoading(false);
  // final errorMessage = e.toString().toLowerCase();
  // if (errorMessage.contains('invalid_username')) {
  //   finish(context);
  //   SignUpScreen(
  //     phoneNumber: widget.phoneNumber!.replaceAll('+', ''),
  //   ).launch(context);
  // } else if (errorMessage.contains('otp is invalid')) {
  //   toast(language.invalidOtp);
  // } else {
  //   toast('حدث خطأ: $e');
  // }
  //   }
  // } catch (e) {
  // هنا أخطاء FirebaseAuth (الكود غلط، انتهت الصلاحية، إلخ)
  // log("error->" + e.toString());
  // await appStore.setLoading(false);
  // final err = e.toString().toLowerCase();
  // if (err.contains('invalid-verification-code')) {
  //   toast('الكود غير صحيح');
  // } else if (err.contains('session-expired')) {
  //   toast('انتهت صلاحية الكود، حاول مرة أخرى');
  // } else {
  //   toast('حدث خطأ أثناء التحقق من الكود');
  // }
  // setState(() {});

  void init() async {
    await appStore.setLoading(false);
    startResendTimer();
    setState(() {});
    super.initState();
  }

  void startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (resendTimeout != 0) {
        setState(() {
          resendTimeout--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
      }
    });
  }

  String formatTime(int seconds) {
    if (seconds <= 0) {
      return '';
    }

    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "00:$secondsStr";
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      child: WillPopScope(
        onWillPop: () async {
          finish(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading:
                Image.asset(ic_back, color: primaryColor, height: 16, width: 16)
                    .onTap(() {
              finish(context);
            }).paddingOnly(top: 20, bottom: 20),
            centerTitle: true,
            backgroundColor:
                appStore.isDarkModeOn ? scaffoldColorDark : selectIconColor,
            elevation: 0,
            title: Text(
              language.verifyPhoneNumber,
              style: boldTextStyle(
                  size: 18,
                  color: appStore.isDarkModeOn
                      ? selectIconColor
                      : scaffoldColorDark),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: language.enterTheConfirmationCodeWeSentTo,
                            style: secondaryTextStyle(size: 16),
                          ),
                          TextSpan(
                              text:
                                  " ${widget.phoneNumber.toString().replaceAll(RegExp(r'(?<=.{3}).(?=.*...)'), '*')}",
                              style: boldTextStyle(size: 16, color: grayColor)),
                        ],
                      ),
                    ),
                    20.height,
                    Image.asset(
                      ic_verify,
                      fit: BoxFit.fill,
                      height: context.height() * 0.4,
                    ),
                    20.height,
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(language.enterOTP,
                            style: boldTextStyle(size: 18, color: primaryColor),
                            textAlign: TextAlign.start)),
                    10.height,
                    Row(
                      children: [
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   color: primaryColor,
                        //   size: 20,
                        // ),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: primaryTextStyle(),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: appStore.isDarkModeOn
                                    ? cardDarkColor
                                    : cardLightColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: primaryColor.withOpacity(0.4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: primaryColor.withOpacity(0.4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                              ),
                              onChanged: (value) {
                                otpCode = value;
                                if (value.length == 6) {
                                  submit();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(language.didntReceiveCode,
                                style: primaryTextStyle(
                                    color: grayColor, size: 16)),
                            8.width,
                            isResendEnabled
                                ? Text(language.resend,
                                        style:
                                            boldTextStyle(color: primaryColor))
                                    .paddingAll(2)
                                    .onTap(() {
                                    setState(() {
                                      // if (isResendEnabled) {
                                      resendOTP();
                                      // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) { });
                                      // isResendEnabled = false;
                                      // }
                                    });
                                  })
                                : SizedBox(),
                            Text(
                              formatTime(resendTimeout),
                              style: primaryTextStyle(),
                            ).paddingAll(2),
                          ],
                        ),
                      ],
                    ),
                    25.height,
                    AppButton(
                      text: language.verify,
                      color: primaryColor,
                      width: context.width(),
                      textColor: Colors.white,
                      elevation: 0,
                      onTap: () async {
                        if (appStore.isLoading == false) {
                          if (otpCode.length == 6) {
                            submit();
                          } else {
                            toast(language.enterValidOTP);
                          }
                        }
                        setState(() {});
                      },
                    ),
                    20.height,
                  ],
                )
                    .paddingSymmetric(horizontal: 20)
                    .paddingOnly(top: context.statusBarHeight + 20),
              ),
              Observer(
                builder: (context) {
                  return Loader().center().visible(appStore.isLoading);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
