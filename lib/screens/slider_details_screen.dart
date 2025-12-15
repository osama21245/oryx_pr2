import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:orex/components/table.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/screens/subscribe_screen.dart';
import '../components/limit_exceed_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/system_utils.dart';
import '../models/property_details_model.dart';
import '../network/RestApis.dart';
import '../utils/colors.dart';
import '../components/app_bar_components.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../utils/app_common.dart';
import '../utils/images.dart';
import 'limit_screen.dart';
import 'property_detail_screen.dart';

class SliderDetailsScreen extends StatefulWidget {
  final MSlider slider;

  const SliderDetailsScreen({super.key, required this.slider});

  @override
  State<SliderDetailsScreen> createState() => _SliderDetailsScreenState();
  
}

class _SliderDetailsScreenState extends State<SliderDetailsScreen> {
  PropertyDetailsModel? mDetail;
  propertyDetailCall() async {
    appStore.setLoading(true);
    Map? req = {
      "id": widget.slider.propertyId,
    };

    await propertyDetails(req).then((value) {
      mDetail = value;
      if (mDetail!.data!.videoUrl != null) {
        getYoutubeThumbnail(mDetail!.data!.videoUrl);
      }

      setState(() {

      });
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void initState() {
    // TODO: implement initState
    propertyDetailCall();
    super.initState();
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
        appBar: appBarWidget(widget.slider.name.validate(),
            context1: context, titleSpace: 0),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            cachedImage(widget.slider.sliderImage.validate(),
                    height: context.height() * 0.3,
                    width: context.width(),
                    fit: BoxFit.fill)
                // .cornerRadiusWithClipRRect(12)
                .paddingSymmetric(horizontal: 16),
                20.height
                ,
            Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(12),
                    backgroundColor:
                        appStore.isDarkModeOn ? darkGrayColor : primaryVariant),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.tapToView,
                            style: primaryTextStyle(
                                color: appStore.isDarkModeOn
                                    ? textOnDarkMode
                                    : textOnLightMode)),
                        10.height,
                        CustomAreaPricesTable(
                          areaPrices: widget.slider.areaPrices,
                          onRowTap: (p0) {
                            print('price ${p0.price}');
                            PropertyDetailScreen(
                              propertyId: widget.slider.propertyId,
                              areaPrice: p0,
                              fromSliderDetails: true,
                            ).launch(context);
                          },
                        ),
                        10.height,
                        Text(language.description,
                            style: primaryTextStyle(
                                color: appStore.isDarkModeOn
                                    ? textOnDarkMode
                                    : textOnLightMode)),
                        4.height,
                        Html(
                          data: widget.slider
                              .description, // e.g. "<p>موجود مساحات متنوعة للايجار تبدأ من 7متر حتى 200متر</p>"
                          style: {
                            "*": Style(
                              direction: TextDirection.rtl, // since it's Arabic
                              fontSize: FontSize(16),
                              color: appStore.isDarkModeOn
                                  ? textOnDarkMode
                                  : textOnLightMode,
                            ),
                          },
                        ),
                      ],
                    ).expand(),
                    // Image.asset(ic_forward_arrow,
                    //     height: 20, width: 20, fit: BoxFit.fill)
                  ],
                )).onTap(() {
              // PropertyDetailScreen(
              //   propertyId: widget.slider.propertyId,
              // ).launch(context);
            }).paddingSymmetric(horizontal: 16),
            10.height,contactWidget(),
            // HtmlWidget(postContent: widget.slider.description.validate()).paddingSymmetric(horizontal: 10)
          ]),
        ),
      ),
    );
  }

  Widget contactWidget() {
    if (mDetail == null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(8.0),
        // backgroundColor:
        //     appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Row(
              //   children: [
              //     cachedImage(mDetail!.customer!.profileImage,
              //             height: 50, width: 50, fit: BoxFit.fitWidth)
              //         .cornerRadiusWithClipRRect(40),
              //     8.width,
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //             "${mDetail!.customer!.firstName.validate().capitalizeFirstLetter()} ${mDetail!.customer!.lastName.validate()}",
              //             style: boldTextStyle(size: 16)),
              //         Text(
              //           mDetail!.customer!.isBuilder == null &&
              //                   mDetail!.customer!.isAgent == null
              //               ? language.property + " " + OWNER
              //               : mDetail!.customer!.isBuilder != null
              //                   ? language.property + " " + BUILDER
              //                   : language.property + " " + AGENT,
              //           style: secondaryTextStyle(size: 14, color: grey),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  // mDetail!.data!.premiumProperty == 1
                  //     ? Row(
                  //         children: [
                  //           InkWell(
                  //             child: Container(
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 10, vertical: 5),
                  //               decoration: boxDecorationWithRoundedCorners(
                  //                   backgroundColor: appStore.isDarkModeOn
                  //                       ? cardDarkColor
                  //                       : primaryExtraLight,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   border: Border.all(
                  //                       color: userStore.subscription == "1"
                  //                           ? mDetail!.data!
                  //                                       .checkedPropertyInquiry ==
                  //                                   0
                  //                               ? Colors.transparent
                  //                               : dividerColor
                  //                           : dividerColor)),
                  //               child: userStore.subscription == "1"
                  //                   ? mDetail!.data!.checkedPropertyInquiry == 0
                  //                       ? Image.asset(ic_wp_trans,
                  //                           height: 30, width: 30)
                  //                       : Image.asset(ic_whatsapp,
                  //                           height: 30, width: 30)
                  //                   : Image.asset(ic_whatsapp,
                  //                       height: 30, width: 30),
                  //             ),
                  //             onTap: () {
                  //               if (userStore.subscription == "0") {
                  //                 commonLaunchUrl(
                  //                     'whatsapp://send?phone=:${mDetail!.customer!.contactNumber}');
                  //               } else {
                  //                 if (mDetail!.data!.checkedPropertyInquiry ==
                  //                     1) {
                  //                   commonLaunchUrl(
                  //                       'whatsapp://send?phone=:${mDetail!.customer!.contactNumber}');
                  //                 }
                  //               }
                  //             },
                  //           ),
                  //           8.width,
                  //           InkWell(
                  //             child: Container(
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 10, vertical: 5),
                  //               decoration: boxDecorationWithRoundedCorners(
                  //                   backgroundColor: appStore.isDarkModeOn
                  //                       ? cardDarkColor
                  //                       : primaryExtraLight,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   border: Border.all(
                  //                       color: userStore.subscription == "1"
                  //                           ? mDetail!.data!
                  //                                       .checkedPropertyInquiry ==
                  //                                   0
                  //                               ? Colors.transparent
                  //                               : dividerColor
                  //                           : dividerColor)),
                  //               child: userStore.subscription == "1"
                  //                   ? mDetail!.data!.checkedPropertyInquiry == 0
                  //                       ? Image.asset(ic_call_trans,
                  //                           height: 30, width: 30)
                  //                       : Image.asset(ic_call,
                  //                           height: 30, width: 30)
                  //                   : Image.asset(ic_call,
                  //                       height: 30, width: 30),
                  //             ),
                  //             onTap: () {
                  //               if (userStore.subscription == "0") {
                  //                 commonLaunchUrl(
                  //                     'tel:${mDetail!.customer!.contactNumber}');
                  //               } else {
                  //                 if (mDetail!.data!.checkedPropertyInquiry ==
                  //                     1) {
                  //                   commonLaunchUrl(
                  //                       'tel:${mDetail!.customer!.contactNumber}');
                  //                 }
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ).paddingOnly(top: 10)
                  //     :
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: appStore.isDarkModeOn
                                  ? cardDarkColor
                                  : Color(0xffE9E9E9),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: dividerColor)),
                          child:
                          Image.asset(ic_whatsapp, height: 30, width: 30),
                        ),
                        onTap: () {
                          print("phone : ${mDetail!.customer!.contactNumber}");
                          final phone = mDetail!.customer!.contactNumber
                              ?.replaceAll('+', '')
                              .replaceAll(':', '')
                              .trim();

                          commonLaunchUrl('https://wa.me/$phone');
                        },
                      ),
                      8.width,
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: appStore.isDarkModeOn
                                  ? cardDarkColor
                                  : Color(0xffE9E9E9),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: dividerColor)),
                          child: Image.asset(ic_call, height: 30, width: 30),
                        ),
                        onTap: () {
                          commonLaunchUrl(
                              'tel:${mDetail!.customer!.contactNumber}');
                        },
                      ),
                    ],
                  ).paddingOnly(top: 10)
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 16),
          Container(
            padding: EdgeInsets.all(10),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(
                backgroundColor:
                appStore.isDarkModeOn ? Colors.grey : primaryVariant,
                borderRadius: radiusOnly(bottomLeft: 8, bottomRight: 8)),
            child: Text(language.tapToViewContactInfo,
                style: primaryTextStyle(
                    color: mDetail!.data!.checkedPropertyInquiry == 0
                        ? Colors.black
                        : grayColor))
                .center(),
          ).onTap(() {
            if (userStore.isSubscribe != 0) {
              if (mDetail!.data!.checkedPropertyInquiry == 0) {
                if (userStore.subscriptionDetail!.subscriptionPlan!.packageData!
                    .property
                    .validate() ==
                    0) {
                  userStore.contactInfo == 0
                      ? showDialog(
                    context: context,
                    builder: (context) {
                      return LimitExceedDialog(
                        onTap: () {
                          finish(context);
                          LimitScreen(limit: "view_property")
                              .launch(context);
                        },
                      );
                    },
                  )
                      : setInquiryOProperty();
                } else {
                  setInquiryOProperty();
                  setState(() {});
                }
              }
            } else {
              SubscribeScreen().launch(context);
            }
          }).visible(userStore.subscription == "1" &&
              mDetail!.data!.checkedPropertyInquiry == 0)
        ],
      ),
    ).paddingSymmetric(horizontal: 16);
  }
  setInquiryOProperty() async {
    appStore.setLoading(true);
    Map req = {
      "property_id": widget.slider.propertyId,
    };
    await savePropertyHistory(req).then((value) {
      mDetail = value;
      getUSerDetail(context, userStore.userId.validate());
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      log('Error $e');
    }).whenComplete(() => appStore.setLoading(false));
  }
}
