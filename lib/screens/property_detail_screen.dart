import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:orex/components/checkbox_Component.dart';
import 'package:orex/components/oryx_ai.dart';
import 'package:orex/models/dashBoard_response.dart';
import 'package:orex/utils/app_textfiled.dart';
import 'package:orex/utils/static_translations.dart';
import '../components/full_screen_image_viewer.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/bool_extensions.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/num_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../screens/add_Property_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/limit_screen.dart';
import '../screens/photo_gallery_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../components/VideoPlayerScreen.dart';
import '../components/limit_exceed_dialog.dart';
import '../extensions/app_button.dart';
import '../extensions/common.dart';
import '../extensions/confirmation_dialog.dart';
import '../extensions/decorations.dart';
import '../extensions/price_widget.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/property_details_model.dart';
import '../network/RestApis.dart';
import '../network/network_utills.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'YoutubePlayerScreen.dart';
import 'amenity_screen.dart';
import 'subscribe_screen.dart';
import 'search_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int? propertyId;
  final Function()? onCall;
  final bool? isSuccess;
  final bool? update;
  final bool? fromSliderDetails;
  final AreaPrice? areaPrice;
  final Function(bool)? onTap;
  final bool? comeFromSlider;

  const PropertyDetailScreen(
      {super.key,
      required this.propertyId,
      this.comeFromSlider = false,
      this.onCall,
      this.isSuccess = false,
      this.areaPrice,
      this.fromSliderDetails = false,
      this.update,
      this.onTap});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  PropertyDetailsModel? mDetail;
  String thumbnail = '';
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (showPropertyDetail) loadInterstitialAds();

    propertyDetailCall();

    setState(() {});
  }

  propertyDetailCall() async {
    appStore.setLoading(true);
    Map? req = {
      "id": widget.propertyId,
    };

    await propertyDetails(req).then((value) {
      mDetail = value;
      if (mDetail!.data!.videoUrl != null) {
        getYoutubeThumbnail(mDetail!.data!.videoUrl);
      }

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  setFavouriteApi(int? id) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) {
      if (mDetail!.data!.isFavourite == 1) {
        mDetail!.data!.isFavourite = 0;
      } else {
        mDetail!.data!.isFavourite = 1;
      }
      toast(value.message);
      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      log(error.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  setInquiryOProperty() async {
    appStore.setLoading(true);
    Map req = {
      "property_id": widget.propertyId,
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

  deletePropertyApi(int? id) async {
    appStore.setLoading(true);
    deleteProperty(id).then((value) {
      finish(context, true);
      setState(() {});
    }).catchError((error) {
      finish(context);
      log(error.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  String getYoutubeThumbnail(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    thumbnail = "https://img.youtube.com/vi/$videoId/maxresdefault.jpg";
    return thumbnail;
  }

  bool validateYouTubeUrl(String? url) {
    if (url != null) {
      RegExp regExp = RegExp(
          r"(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]+)");
      return regExp.hasMatch(url);
    }
    return false;
  }

  void handleOnTap(String? url, String? img) {
    if (url!.contains("youtube.com") &&
        validateYouTubeUrl(mDetail!.data!.videoUrl)) {
      YoutubeVideoScreen(url: url).launch(context);
    } else {
      VideoPlayerScreen(thumbnail: img, url: url).launch(context);
    }
  }

  @override
  void dispose() {
    if (showPropertyDetail) showInterstitialAds();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // onDeviceBack() async {
  //   toast("Yes Inside Back Function!");
  //   if (widget.isSuccess.validate()) {
  //     toast("Success Function!");
  //     DashboardScreen().launch(context, isNewTask: true);
  //   } else {
  //     toast("Back Function!");
  //
  //     Navigator.pop(context);
  //     widget.onTap!.call(false);
  //   }
  //   return Future.value(true);
  // }
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    print("%R%%%%%%%% ${widget.propertyId}");

    var size = MediaQuery.of(context).size;
    print(mDetail?.data?.propertyImage?.isEmpty);
    return Scaffold(
      appBar: AppBar(
        title: Text(language.propertyDetail,
            style:
                boldTextStyle(color: white, size: 20, weight: FontWeight.w800)),
        centerTitle: true,
      ),
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Stack(
          children: [
            if (mDetail != null)
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        if ((mDetail?.data?.propertyImage?.isEmpty ?? true) &&
                            (mDetail?.data?.propertyGallary?.isEmpty ?? true))
                          Image.asset(
                            ic_placeholder,
                            height: context.height() * 0.34,
                            width: context.width(),
                            fit: BoxFit.cover,
                          )
                        else if ((mDetail?.data?.propertyGallary?.isEmpty ??
                                true) &&
                            (mDetail?.data?.propertyGallary
                                    ?.contains('default') ??
                                false))
                          Image.asset(
                            ic_placeholder,
                            height: context.height() * 0.34,
                            width: context.width(),
                            fit: BoxFit.cover,
                          )
                        else if (mDetail?.data?.propertyGallary?.isEmpty ??
                            true)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FullScreenImageViewer(
                                          imageUrl: mDetail?.data?.propertyImage??""),
                                ),
                              );
                            },
                            child: Image.network(
                              mDetail?.data?.propertyImage ?? "",
                              height: context.height() * 0.34,
                              width: context.width(),
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          CarouselSlider(
                            carouselController: _carouselController,
                            items:
                                mDetail!.data!.propertyGallary!.map((imageUrl) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(
                                              imageUrl: imageUrl),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: context.height() * 0.34,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index; // Update current index
                                });
                              },
                            ),
                          ),
                        Positioned(
                          left: 16,
                          top: context.height() * 0.15,
                          child: Container(
                            width: context.width() * 0.08,
                            height: context.height() * 0.04,
                            decoration: BoxDecoration(
                              color: Color(0xFFE9E9E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                  appStore.selectedLanguage == 'ar'
                                      ? Icons.arrow_forward_ios
                                      : Icons.arrow_back_ios_new,
                                  color: primaryColor,
                                  size: 16),
                              onPressed: () {
                                setState(() {
                                  _carouselController.previousPage();
                                  _currentIndex = (_currentIndex - 1) %
                                      mDetail!.data!.propertyGallary!.length;
                                  print('_currentIndex: $_currentIndex');
                                });
                              },
                            ),
                          ),
                        ).visible(mDetail!.data!.propertyGallary!.length > 1),
                        Positioned(
                          right: 16,
                          top: context.height() * 0.15,
                          child: Container(
                            width: context.width() * 0.08,
                            height: context.height() * 0.04,
                            decoration: BoxDecoration(
                              color: Color(0xFFE9E9E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                appStore.selectedLanguage == 'ar'
                                    ? Icons.arrow_back_ios_new
                                    : Icons.arrow_forward_ios,
                                color: primaryColor,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _carouselController.nextPage();

                                  _currentIndex = (_currentIndex + 1) %
                                      mDetail!.data!.propertyGallary!.length;
                                  print('_currentIndex: $_currentIndex');
                                });
                              },
                            ),
                          ),
                        ).visible(mDetail!.data!.propertyGallary!.length > 1),
                        // cachedImage(mDetail!.data!.propertyImage,
                        //         fit: BoxFit.fill,
                        //         height: context.height() * 0.34,
                        //         width: MediaQuery.of(context).size.width)
                        //     .cornerRadiusWithClipRRectOnly(
                        //         bottomLeft: 12, bottomRight: 12),
                        // Positioned(
                        //   top: context.statusBarHeight,
                        //   right: 16,
                        //   left: 16,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       backButtonWidget(context, onTap: () {
                        //         if (widget.isSuccess.validate()) {
                        //           DashboardScreen()
                        //               .launch(context, isNewTask: true);
                        //         } else {
                        //           finish(context, true);
                        //           setState(() {});
                        //           // widget.onTap?.call(true);
                        //         }
                        //       }),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //             alignment: Alignment.center,
                        //             padding: EdgeInsets.all(6),
                        //             decoration: boxDecorationDefault(
                        //                 shape: BoxShape.circle,
                        //                 color: context.cardColor),
                        //             child: Icon(Feather.share,
                        //                 size: 20, color: primaryColor),
                        //           )
                        //               .paddingOnly(
                        //                   right:
                        //                       appStore.selectedLanguage == 'ar'
                        //                           ? 0
                        //                           : 16,
                        //                   left:
                        //                       appStore.selectedLanguage == 'ar'
                        //                           ? 16
                        //                           : 0)
                        //               .onTap(() {
                        //             Share.share(mDetail!.data!.name.validate(),
                        //                 subject:
                        //                     mDetail!.data!.name.validate());
                        //           }),
                        //           fevIconWidget(
                        //                   mDetail!.data!.isFavourite, context,
                        //                   padding: 6, color: context.cardColor)
                        //               .onTap(() {
                        //             setState(() {
                        //               setFavouriteApi(mDetail!.data!.id);
                        //             });
                        //           }),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 12,
                        //   right: 16,
                        //   left: 16,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       PremiumBtn(pDetail: false).visible(
                        //           userStore.subscription == "1" &&
                        //               mDetail!.data!.premiumProperty == 1),
                        //       Container(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: 8, vertical: 6),
                        //         decoration: boxDecorationWithRoundedCorners(
                        //             borderRadius: radius(34),
                        //             backgroundColor:
                        //                 Colors.white.withOpacity(0.50),
                        //             border: Border.all(color: Colors.white)),
                        //         child: Text(
                        //             language.ageOfProperty +
                        //                 " " +
                        //                 mDetail!.data!.ageOfProperty.toString() +
                        //                 " " +
                        //                 language.year
                        //                     .replaceAll('(', '')
                        //                     .replaceAll(')', ''),
                        //             style: primaryTextStyle(
                        //                 color: primaryColor, size: 12)),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    20.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(

                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 70,
                              width: 300,
                              child: Text(mDetail!.data!.name.toString(),
                                  style: boldTextStyle(size: 18,),),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.flag_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ).onTap(() {
                                  showBottomSheet(onTap: () {});
                                }),
                                5.height,
                                Text(
                                    translateKeywords(
                                        "ابلاغ", appStore.selectedLanguage),
                                    style: secondaryTextStyle(
                                        size: 12,
                                        color: primaryColor,
                                        weight: FontWeight.w400),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ).paddingSymmetric(horizontal: 0),
                          ],
                        ),
                        widget.comeFromSlider == true
                            ? Text(
                                "${widget.areaPrice!.type}${widget.areaPrice!.area}",
                                style: boldTextStyle(size: 18))
                            : SizedBox.shrink(),
                        Text(
                          'الفئة :- ${mDetail!.data!.category}',
                          style: primaryTextStyle(size: 16),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Image.asset(ic_property, height: 20, width: 20),
                        //     5.width,
                        //     Text(mDetail!.data!.category.toString(),
                        //             style: primaryTextStyle(size: 16))
                        //         .expand(),
                        //     Container(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 10, vertical: 5),
                        //       decoration: boxDecorationWithRoundedCorners(
                        //           borderRadius: radius(8.0),
                        //           backgroundColor: appStore.isDarkModeOn
                        //               ? context.cardColor
                        //               : primaryExtraLight),
                        //       child: Text(
                        //         mDetail!.data!.propertyFor == 0
                        //             ? language.forRent
                        //             : mDetail!.data!.propertyFor == 1
                        //                 ? language.forSell
                        //                 : language.pgCoLiving,
                        //         style: primaryTextStyle(
                        //             color: primaryColor, size: 12),
                        //       ).center(),
                        //     ),
                        //   ],
                        // ).paddingSymmetric(horizontal: 16, vertical: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              ic_map_point,
                              height: 20,
                              width: 20,
                              color: primaryColor,
                            ),
                            5.width,
                            Text("${""} ${mDetail!.data!.city}",
                                    style: secondaryTextStyle(
                                        size: 16,
                                        color: appStore.isDarkModeOn
                                            ? textOnDarkMode
                                            : textOnLightMode,
                                        weight: FontWeight.w400),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)
                                .expand()
                          ],
                        ).paddingSymmetric(horizontal: 0),

                        10.height,
                        Row(
                          children: [
                            widget.fromSliderDetails!
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PriceWidget(
                                          price: formatNumberString(
                                              widget.areaPrice!.price!),
                                          textStyle: primaryTextStyle(
                                              size: 18, color: primaryColor)),
                                      SizedBox(
                                        width: size.width * .5,
                                      ),
                                      Text('${widget.areaPrice!.area} M'),
                                    ],
                                  )
                                : mDetail!.data!.propertyFor == 1
                                    ? PriceWidget(
                                        price: formatNumberString(
                                            mDetail!.data!.price!),
                                        textStyle: primaryTextStyle(
                                            size: 18, color: primaryColor),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PriceWidget(
                                              price: formatNumberString(
                                                  mDetail!.data!.price!),
                                              textStyle: primaryTextStyle(
                                                  size: 18,
                                                  color: primaryColor)),
                                          SizedBox(
                                            width: size.width * .5,
                                          ),
                                          // Text(
                                          //     '/ ' +
                                          //         durationWidget(
                                          //             mDetail!.data!.priceDuration),
                                          //     style: primaryTextStyle(
                                          //         size: 18, color: primaryColor)),
                                        ],
                                      )
                          ],
                        ).paddingSymmetric(horizontal: 0),
                        16.height,

                        // horizontalWidget(),
                        // Divider(
                        //     thickness: 1,
                        //     color: dividerColor,
                        //     indent: 16,
                        //     endIndent: 16),
                        // if (mDetail!.customer!.id != getIntAsync(USER_ID))
                        //   10.height,
                        // if (mDetail!.customer!.id != getIntAsync(USER_ID))
                        descriptionWidget(),
                        16.height.visible(mDetail!.data!.description != null),

                        contactWidget(),
                        // 16.height,
                        // photoGalleryWidget(),
                        // 16.height,
                        // //  mapWidget(),
                        // 16.height,
                        // costOfLivingWidget(),
                        // 16.height,
                        // // nearByGoogle(),
                        // 16.height,
                        // if (mDetail!.propertyAmenityValue!.isNotEmpty)
                        //   AmenityScreen(
                        //       amenityValue: mDetail!.propertyAmenityValue!),
                        // if (widget.update == true && mDetail != null) 40.height,
                      ],
                    ),
                  ],
                ),
              ),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
      ),
      bottomNavigationBar: widget.update == true && mDetail != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: context.cardColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ic_edit_property, height: 24, width: 24),
                        20.width,
                        Text(language.edit,
                            style: primaryTextStyle(color: Colors.white)),
                      ],
                    ),
                  ).onTap(() async {
                    bool res = await AddPropertyScreen(
                            updateProperty: true,
                            pId: widget.propertyId,
                            propertyFor: mDetail!.data!.propertyFor,
                            updatePropertyData: mDetail)
                        .launch(context);
                    if (res) {
                      init();
                      setState(() {});
                    }
                  }).expand(),
                  8.width,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ic_delete_ac,
                            height: 24, width: 24, color: Colors.white),
                        20.width,
                        Text(language.delete,
                            style: primaryTextStyle(color: Colors.white)),
                      ],
                    ),
                  ).onTap(() {
                    showConfirmDialogCustom(
                      bgColor: limitColor.withOpacity(0.10),
                      iconColor: limitColor,
                      positiveBg: Colors.red,
                      image: ic_delete_ac,
                      context,
                      primaryColor: primaryColor,
                      positiveTextColor: Colors.white,
                      negativeBg: primaryLight,
                      negativeTextColor: primaryColor,
                      title: language.deletePropertyMsg,
                      positiveText: language.delete,
                      height: 100,
                      onAccept: (c) async {
                        await deletePropertyApi(widget.propertyId);
                        setState(() {});
                      },
                    );

                    setState(() {});
                  }).expand(),
                ],
              ),
            )
          : SizedBox(),
      floatingActionButton: OryxAIFloatingButton(),
    );
  }

  Widget _buildOryxAIFloatingButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 16),
      child: FloatingActionButton.extended(
        onPressed: () {
          SearchScreen(
            isBack: true,
            openVoiceDialog: true,
          ).launch(context);
        },
        backgroundColor: primaryColor,
        elevation: 8,
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(6),
          child: Image.asset(
            app_logo,
            fit: BoxFit.contain,
          ),
        ),
        label: Text(
          appStore.selectedLanguage == 'ar' ? 'Oryx AI' : 'Oryx AI',
          style: boldTextStyle(color: Colors.white, size: 16),
        ),
      ),
    );
  }

  //region Cost of living
  Widget costOfLivingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.costOfLiving, style: boldTextStyle())
            .paddingSymmetric(horizontal: 16),
        8.height,
        Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(8.0),
              backgroundColor:
                  appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
          child: Column(
            children: [
              commonPriceWidget(
                  title: language.securityDeposit,
                  subTitle: mDetail!.data!.securityDeposit!),
              commonPriceWidget(
                  title: language.maintenanceCharges,
                  subTitle: mDetail!.data!.maintenance!),
              commonPriceWidget(
                  title: language.brokerage,
                  subTitle: mDetail!.data!.brokerage!),
              Divider(
                  thickness: 1, color: dividerColor, indent: 10, endIndent: 10),
              commonPriceWidget(
                  title: language.totalExtraCost,
                  subTitle: (mDetail!.data!.securityDeposit! +
                      mDetail!.data!.maintenance! +
                      mDetail!.data!.brokerage!),
                  isTotal: true),
            ],
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Widget commonPriceWidget(
      {String? title, num? subTitle, bool? isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.validate(),
            style:
                !isTotal.validate() ? secondaryTextStyle() : boldTextStyle()),
        PriceWidget(
            price: formatNumberString(subTitle.validate()),
            textStyle:
                !isTotal.validate() ? primaryTextStyle() : boldTextStyle()),
      ],
    ).paddingOnly(bottom: 8);
  }

//endregion

//region Map View
  Widget mapWidget() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Text(language.location, style: boldTextStyle(size: 18))
                .paddingSymmetric(horizontal: 16)
                .paddingBottom(10),
            4.height,
            SizedBox(
              height: 180, // Adjust height as needed
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // child: GoogleMap(
                //   scrollGesturesEnabled: false,
                //   compassEnabled: false,
                //   zoomControlsEnabled: false,
                //   mapType: MapType.normal,
                //   initialCameraPosition: CameraPosition(
                //     target: LatLng(mDetail!.data!.latitude!.toDouble(), mDetail!.data!.longitude!.toDouble()),
                //     zoom: 12.0,
                //   ),
                //   markers: Set<Marker>.from([
                //     Marker(
                //       markerId: MarkerId('pinpoint'),
                //       position: LatLng(mDetail!.data!.latitude!.toDouble(), mDetail!.data!.longitude.toDouble()),
                //       icon: BitmapDescriptor.defaultMarker,
                //     ),
                //   ]),
                // ),
              ),
            ).paddingSymmetric(horizontal: 16),
            AppButton(
              enableScaleAnimation: false,
              width: context.width(),
              textStyle: boldTextStyle(size: 14),
              text: language.viewOnMap,
              color: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
              elevation: 0,
              onTap: () async {
                await MapsLauncher.launchCoordinates(
                    mDetail!.data!.latitude!.toDouble(),
                    mDetail!.data!.longitude!.toDouble());
                setState(() {});
              },
            ).paddingSymmetric(horizontal: 16),
          ],
          // child:
        ),
      ],
    );
  }

//endregion

//region Photo Gallery
  Widget photoGalleryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.gallery, style: boldTextStyle(size: 18))
            .paddingSymmetric(horizontal: 16)
            .visible(mDetail!.data!.propertyGallary!.isNotEmpty),
        8.height,
        HorizontalList(
          spacing: 8,
          padding: EdgeInsets.only(left: 16, right: 16),
          itemCount: mDetail!.data!.propertyGallary!.length,
          itemBuilder: (context, i) {
            return cachedImage(mDetail!.data!.propertyGallary![i],
                    fit: BoxFit.cover,
                    height: context.height() * 0.09,
                    width: MediaQuery.of(context).size.width * 0.25)
                .cornerRadiusWithClipRRect(12);
          },
        ).onTap(() {
          PhotoGalleyScreen(mPropertyDetail: mDetail!.data).launch(context);
        }),
        8.height.visible(mDetail!.data!.propertyGallary!.isNotEmpty),
      ],
    );
  }

// endregion

//region Description
  Widget descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(language.description, style: boldTextStyle(size: 18))
        //     .visible(mDetail!.data!.description != null),
        // 8.height,
        Text(
          mDetail!.data!.description.toString().capitalizeFirstLetter(),
          style: secondaryTextStyle(
              size: 16,
              color: appStore.isDarkModeOn ? textOnDarkMode : textOnLightMode,
              weight: FontWeight.w400),
        ).visible(mDetail!.data!.description != null),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

//endregion

//region Contact
  Widget contactWidget() {
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

//endregion

//region horizontal
  Widget horizontalWidget() {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        commonWrapWidget(
                image: ic_bed, title: "${mDetail!.data!.bhk} ${language.bhk}")
            .visible(mDetail!.data!.bhk != null),
        commonWrapWidget(
                image: ic_max_square, title: mDetail!.data!.sqft.toString())
            .visible(mDetail!.data!.sqft != null),
        commonWrapWidget(
          image: ic_closet,
          title: mDetail!.data!.furnishedType == 1
              ? language.fullyFurnished
              : mDetail!.data!.furnishedType == 2
                  ? language.semiFurnished
                  : language.unfurnished,
        )
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget commonWrapWidget({String? image, String? title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(38.0),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(image.validate(), height: 22, width: 22),
          8.width,
          Text(title.validate(),
              style: TextStyle(color: primaryColor, fontSize: 14)),
        ],
      ),
    );
  }

// region nearby google
  Widget nearByGoogle() {
    return mDetail!.nearByPlace != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.NearestByGoogle, style: boldTextStyle(size: 18))
                  .paddingSymmetric(horizontal: 16)
                  .visible(mDetail!.data!.propertyGallary!.isNotEmpty),
              8.height,
              HorizontalList(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: mDetail!.nearByPlace!.results!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await MapsLauncher.launchCoordinates(
                            mDetail!.nearByPlace!.results![index].geometry!
                                .location!.lat!
                                .toDouble(),
                            mDetail!.nearByPlace!.results![index].geometry!
                                .location!.lng!
                                .toDouble());
                      },
                      child: Container(
                        decoration: boxDecorationRoundedWithShadow(
                          12,
                          backgroundColor: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight,
                        ),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mDetail!.nearByPlace!.results![index].photos !=
                                        null &&
                                    mDetail!.nearByPlace!.results![index]
                                        .photos!.isNotEmpty
                                ? Image.network(
                                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${mDetail!.nearByPlace!.results![index].photos![0].photoReference}&key=$GOOGLE_API_KEY',
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 140,
                                  ).cornerRadiusWithClipRRectOnly(
                                    topRight: 12,
                                    topLeft: 12,
                                  )
                                : Image.asset(
                                    ic_not_available,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 140,
                                  ).cornerRadiusWithClipRRectOnly(
                                    topRight: 12,
                                    topLeft: 12,
                                  ),
                            4.height,
                            Text(
                              mDetail!.nearByPlace!.results![index].name
                                  .toString()
                                  .capitalizeFirstLetter(),
                              style: boldTextStyle(size: 18),
                            ).paddingSymmetric(horizontal: 12),
                            4.height,
                            Text(
                              mDetail!.nearByPlace!.results![index].vicinity
                                  .toString(),
                              style: primaryTextStyle(size: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ).paddingSymmetric(horizontal: 14),
                            4.height,
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${mDetail!.nearByPlace!.results![index].rating ?? 0.0}/5',
                                  style: primaryTextStyle(size: 14),
                                ),
                                4.width,
                                RatingBar.builder(
                                  initialRating: (mDetail!.nearByPlace!
                                              .results![index].rating ??
                                          0)
                                      .toDouble(),
                                  minRating: 0,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 14),
                            4.height
                          ],
                        ),
                      ),
                    );
                  })
            ],
          )
        : SizedBox();
  }

  void showBottomSheet({required void Function() onTap}) {
    List<String> selectedOptions = [];
    List<String> allOptions = [
      "غير متعلقة بالعقارات",
      "صور خاطئة",
      "أخرى",
    ];
    TextEditingController descriptionController = TextEditingController();

    // Map Arabic options to English API values
    Map<String, String> optionToApiValue = {
      "غير متعلقة بالعقارات": "not_related",
      "صور خاطئة": "fake_images",
      "أخرى": "other",
    };

    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateSheet) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.95,
              minChildSize: 0.4,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          translateKeywords("ابلاغ", appStore.selectedLanguage),
                          style: boldTextStyle(size: 18)),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: allOptions.length,
                          itemBuilder: (context, index) {
                            final option = allOptions[index];
                            final isSelected = selectedOptions.contains(option);
                            return CheckboxListTile(
                              controlAffinity: appStore.selectedLanguage == "ar"
                                  ? ListTileControlAffinity.leading
                                  : ListTileControlAffinity.trailing,
                              contentPadding: EdgeInsets.zero,
                              title: Text(option),
                              value: isSelected,
                              activeColor: primaryColor,
                              onChanged: (bool? value) {
                                setStateSheet(() {
                                  if (value == true) {
                                    selectedOptions.add(option);
                                  } else {
                                    selectedOptions.remove(option);
                                  }
                                });
                                print(selectedOptions);
                              },
                            );
                          },
                        ),
                      ),
                      Text("اشرح المشكلة", style: boldTextStyle(size: 18)),
                      AppTextField(
                        textFieldType: TextFieldType.OTHER,
                        controller: descriptionController,
                        decoration: defaultInputDecoration(context,
                            label: "اشرح المشكلة"),
                      ),
                      20.height,
                      AppButton(
                        text: language.submit,
                        width: context.width(),
                        color: primaryColor,
                        textColor: Colors.white,
                        onTap: () async {
                          if (selectedOptions.isEmpty) {
                            toast("Please select at least one reason");
                            return;
                          }

                          // Convert selected Arabic options to API values
                          List<String> apiReasons = selectedOptions
                              .map((option) =>
                                  optionToApiValue[option] ?? option)
                              .toList();

                          Map<String, dynamic> requestBody = {
                            "reasons": apiReasons,
                            "description": descriptionController.text,
                            "property_id": widget.propertyId,
                          };

                          appStore.setLoading(true);

                          try {
                            await buildHttpResponse(
                              'https://oryxinvestmentsegypt.com/api/report',
                              request: requestBody,
                              method: HttpMethod.POST,
                            );

                            appStore.setLoading(false);
                            Navigator.pop(context);
                            toast(translateKeywords(
                                "تم الإبلاغ بنجاح", appStore.selectedLanguage));
                            onTap();
                          } catch (e) {
                            appStore.setLoading(false);
                            log("Report error: $e");
                            toast(translateKeywords("حدث خطأ، حاول مرة أخرى",
                                appStore.selectedLanguage));
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

//endregion
}
