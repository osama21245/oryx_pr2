import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../extensions/colors.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/horizontal_list.dart';
import '../screens/property_detail_screen.dart';
import '../../components/app_bar_components.dart';
import '../../components/robot_voice_search_dialog.dart';
import '../../main.dart';
import '../components/advertisement_property_component.dart';
import '../components/premium_btn_component.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/app_text_field.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/loader_widget.dart';
import '../extensions/price_widget.dart';
import '../extensions/system_utils.dart';
import '../extensions/text_styles.dart';
import '../models/dashBoard_response.dart';
import '../models/ai_search_response_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'dashboard_screen.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  final double? budgetMinPrice;
  final double? budgetMaxPrice;
  final int? bhkSend;
  final int? selectCategory;
  final List<Property>? mPropertyData;
  final bool isBack;
  final int? propertyId;
  final String? propertySince;
  final num? latitude;
  final num? longitude;
  bool? isFilter;
  final bool? openVoiceDialog;

  SearchScreen(
      {super.key,
      this.budgetMaxPrice,
      this.budgetMinPrice,
      this.bhkSend,
      this.selectCategory,
      this.longitude,
      this.latitude,
      this.propertyId,
      this.propertySince,
      this.isFilter,
      this.mPropertyData,
      this.isBack = false,
      this.openVoiceDialog = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Property> mergePropertyData = [];
  late Debouncer _debouncer;

  List<String> list = [];
  num? latitude;
  num? longitude;

  ScrollController scrollController = ScrollController();
  TextEditingController mSearchCont = TextEditingController();

  FocusNode search = FocusNode();

  String? mSearchValue = '';

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  // STT variables
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAiSearchLoading = false;
  String? _aiMessage;
  bool _useAiSearch = false; // Toggle between regular and AI search

  @override
  void initState() {
    _debouncer = Debouncer(milliseconds: 500);
    super.initState();
    init();
    _initializeSpeech();

    // Auto-open voice dialog if requested
    if (widget.openVoiceDialog == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            _showRobotVoiceSearchDialog();
          }
        });
      });
    }
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        // Status handling moved to dialog
      },
      onError: (error) {
        toast(error.errorMsg);
      },
    );
    if (!available && mounted) {
      // Speech not available
    }
  }

  init() async {
    if (widget.isFilter == true) mergePropertyData.clear();
  }

  Future<void> _getCurrentLocation() async {
    try {
      appStore.setLoading(true);

      // Request location permissions
      var locationStatus = await Permission.location.request();
      if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
        appStore.setLoading(false);
        toast('Location permission is required to use this feature');
        return;
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        appStore.setLoading(false);
        toast('Please enable location services');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.medium, // Approximate location (city/area level)
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        mSearchValue = '';
        mSearchCont.clear();
      });

      if (latitude != null && longitude != null) {
        await searchPropertyApi();
      } else {
        appStore.setLoading(false);
      }
    } catch (e) {
      appStore.setLoading(false);
      log('Error getting current location: $e');
      toast('Failed to get current location');
    }
  }

  void searchAndUpdateList(String value) {
    setState(() {
      if (value.isNotEmpty && !userStore.mRecentSearchList.contains(value)) {
        userStore.mRecentSearchList.remove(mSearchValue);
        userStore.mRecentSearchList.insert(0, mSearchValue!);
      }
      //mSearchCont.clear();
    });
  }

  void _removeFromUniqueValues(String valueToRemove) {
    setState(() {
      userStore.mRecentSearchList.remove(valueToRemove);
    });
  }

  searchPropertyApi() async {
    Map req = {
      "search": mSearchValue,
      "latitude": latitude,
      "longitude": longitude
    };
    appStore.setLoading(true);
    searchProperty(req).then((value) {
      print(req);
      log("valueeeeeeeee${value.propertyData?.length}");
      log("valueeeeeeeee${value.nearByProperty?.length}");
      appStore.setLoading(false);
      mergePropertyData.clear();
      Iterable its = value.propertyData!;
      Iterable it = value.nearByProperty!;
      its.map((e) => mergePropertyData.add(e)).toList();
      it.map((e) => mergePropertyData.add(e)).toList();
      if (!mSearchCont.text.isEmptyOrNull) {
        userStore.addToRecentSearchList(mSearchValue.toString());
      }

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
  }

  Future<void> _showRobotVoiceSearchDialog() async {
    // Request microphone permission first
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      toast('Microphone permission is required for voice search');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RobotVoiceSearchDialog(
        onTextRecognized: (text) {
          if (text.isNotEmpty) {
            setState(() {
              mSearchCont.text = text;
              mSearchValue = text;
            });
            // Perform AI search with the recognized text
            _performAiSearch(text);
          }
        },
        onCancel: () {
          _stopListening();
        },
      ),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
  }

  Future<void> _performAiSearch(String searchText) async {
    if (searchText.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isAiSearchLoading = true;
        _aiMessage = null;
        mergePropertyData.clear();
      });
    }

    try {
      Map req = {
        "search": searchText,
      };

      aiSearchProperty(req).then((value) {
        if (mounted) {
          setState(() {
            _isAiSearchLoading = false;
            _aiMessage = value.message;

            // Merge property data
            mergePropertyData.clear();
            if (value.data?.propertyData != null) {
              Iterable its = value.data!.propertyData!;
              its.map((e) => mergePropertyData.add(e)).toList();
            }
            if (value.data?.nearByProperty != null) {
              Iterable it = value.data!.nearByProperty!;
              it.map((e) => mergePropertyData.add(e)).toList();
            }

            // Save to recent searches
            if (searchText.isNotEmpty) {
              userStore.addToRecentSearchList(searchText);
            }
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isAiSearchLoading = false;
          });
        }
        log(error);
        toast(error.toString());
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAiSearchLoading = false;
        });
      }
      log(e.toString());
      toast(e.toString());
    }
  }

  setFavouriteApi(int? id, int? isFavourite) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) async {
      appStore.setLoading(false);
      if (isFavourite == 1) {
        isFavourite = 0;
      } else {
        isFavourite = 1;
      }

      appStore.setLoading(false);

      toast(value.message);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => true);

      return true;
    }, child: Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget("",
            context1: context,
            titleSpace: 0,
            showBack: true,
            backWidget: Icon(
                    appStore.selectedLanguage == 'ar'
                        ? MaterialIcons.arrow_forward_ios
                        : Octicons.chevron_left,
                    color: primaryColor,
                    size: 28)
                .onTap(() {
              if (widget.isBack == false) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (route) => true);
              } else {
                finish(context);
              }
            })),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Search Container with better spacing
                  Column(
                    children: [
                      // Search Bar Row
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(12),
                            backgroundColor: appStore.isDarkModeOn
                                ? cardDarkColor
                                : primaryExtraLight,
                            border: Border.all(
                              color: _useAiSearch
                                  ? primaryColor.withOpacity(0.3)
                                  : Colors.transparent,
                              width: 2,
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _useAiSearch
                                    ? primaryColor.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: radius(8),
                              ),
                              child: Image.asset(
                                ic_magnifier,
                                height: 22,
                                width: 22,
                                color: _useAiSearch ? primaryColor : grey,
                              ),
                            ),
                            12.width,
                            Expanded(
                              child: AppTextField(
                                focus: search,
                                controller: mSearchCont,
                                textStyle: primaryTextStyle(),
                                textFieldType: TextFieldType.OTHER,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8),
                                    border: InputBorder.none,
                                    hintText: _useAiSearch
                                        ? 'Ask me anything about properties...'
                                        : language.searchLocation,
                                    hintStyle: primaryTextStyle(color: grey)),
                                onChanged: (v) {
                                  if (!_useAiSearch) {
                                    _debouncer.run(() {
                                      mSearchValue = v;
                                      latitude = 0.0;
                                      longitude = 0.0;
                                      searchAndUpdateList(v.trim());
                                      searchPropertyApi();
                                      widget.isFilter = false;
                                      if (mounted) setState(() {});
                                    });
                                  } else {
                                    setState(
                                        () {}); // Update UI to show/hide AI button
                                  }
                                },
                                onFieldSubmitted: (v) {
                                  mSearchValue = v;
                                  if (_useAiSearch) {
                                    // Use AI search when submitted
                                    if (v.trim().isNotEmpty) {
                                      _performAiSearch(v.trim());
                                    }
                                  } else {
                                    latitude = 0.0;
                                    longitude = 0.0;
                                    searchAndUpdateList(v.trim());
                                    searchPropertyApi();
                                    widget.isFilter = false;
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            8.width,
                            // Voice Search Button
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.mic,
                                color: primaryColor,
                                size: 20,
                              ),
                            ).onTap(() {
                              _showRobotVoiceSearchDialog();
                            }),
                            8.width,
                            // Filter Button
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.1),
                              ),
                              child: Image.asset(
                                ic_filter,
                                height: 18,
                                width: 18,
                                color: primaryColor,
                              ),
                            ).onTap(() {
                              FilterScreen(isSelect: false).launch(context);
                            }),
                          ],
                        ),
                      ),
                      // AI Toggle and Search Button Row (outside search container)
                      12.height,
                      Row(
                        children: [
                          // AI Toggle Button
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: _useAiSearch
                                  ? primaryColor
                                  : Colors.transparent,
                              borderRadius: radius(10),
                              border: Border.all(
                                color: _useAiSearch
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: _useAiSearch
                                      ? Colors.white
                                      : primaryColor,
                                  size: 18,
                                ),
                                8.width,
                                Text(
                                  'AI Search',
                                  style: primaryTextStyle(
                                    size: 13,
                                    color: _useAiSearch
                                        ? Colors.white
                                        : primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ).onTap(() {
                            setState(() {
                              _useAiSearch = !_useAiSearch;
                              if (!_useAiSearch) {
                                _aiMessage = null;
                              }
                            });
                          }),
                          // AI Search Action Button (only shown when AI mode is on and has text)
                          if (_useAiSearch && mSearchCont.text.isNotEmpty) ...[
                            12.width,
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: primaryColor,
                                  borderRadius: radius(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    8.width,
                                    Text(
                                      'Search with AI',
                                      style: boldTextStyle(
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ).onTap(() {
                                if (mSearchCont.text.trim().isNotEmpty) {
                                  _performAiSearch(mSearchCont.text.trim());
                                }
                              }),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Location Button
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight,
                          borderRadius: radius(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Icon(
                                Icons.my_location_sharp,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                            12.width,
                            Expanded(
                              child: Text(
                                language.useMyCurrentLocation,
                                style: boldTextStyle(
                                  color: primaryColor,
                                  size: 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ).onTap(() async {
                        widget.isFilter = false;
                        await _getCurrentLocation();
                      }),
                      18.height,
                      // Enhanced AI Message Display
                      if (_aiMessage != null && _aiMessage!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(18),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(16),
                            backgroundColor: appStore.isDarkModeOn
                                ? cardDarkColor
                                : primaryExtraLight,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.15),
                                      borderRadius: radius(8),
                                    ),
                                    child: Icon(
                                      Icons.auto_awesome,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  12.width,
                                  Text(
                                    'AI Assistant',
                                    style: boldTextStyle(
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              12.height,
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: appStore.isDarkModeOn
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.white,
                                  borderRadius: radius(10),
                                ),
                                child: Text(
                                  _aiMessage!,
                                  style: primaryTextStyle(
                                    size: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Lottie Loading Animation for AI Search
                      if (_isAiSearchLoading)
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            searching_animation,
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      Stack(
                        children: [
                          mSearchCont.text.isEmpty &&
                                  latitude == null &&
                                  longitude == null &&
                                  !_isAiSearchLoading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(language.recentSearch,
                                              style:
                                                  secondaryTextStyle(size: 18))
                                          .visible(userStore
                                              .mRecentSearchList.isNotEmpty),
                                      20.height,
                                      HorizontalList(
                                          padding: EdgeInsets.all(0),
                                          itemCount: 1,
                                          itemBuilder: (context, i) {
                                            return AnimatedWrap(
                                              runSpacing: 16,
                                              spacing: 16,
                                              children: List.generate(
                                                  userStore.mRecentSearchList
                                                      .length, (index) {
                                                final item = userStore
                                                    .mRecentSearchList[index];
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration:
                                                      boxDecorationWithRoundedCorners(
                                                          borderRadius:
                                                              radius(30),
                                                          backgroundColor: appStore
                                                                  .isDarkModeOn
                                                              ? cardDarkColor
                                                              : primaryExtraLight),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.close,
                                                              color:
                                                                  primaryColor)
                                                          .onTap(() {
                                                        userStore
                                                            .clearSearchList(
                                                                item);
                                                        init();
                                                        setState(() {});
                                                      }),
                                                      10.width,
                                                      Text(item,
                                                          style:
                                                              primaryTextStyle())
                                                    ],
                                                  ),
                                                ).onTap(() {
                                                  mSearchCont.text =
                                                      item.toString();
                                                  mSearchValue =
                                                      mSearchCont.text;
                                                  _removeFromUniqueValues(item);
                                                  searchPropertyApi();
                                                });
                                              }),
                                            );
                                          }),
                                    ])
                              : mergePropertyData.isNotEmpty &&
                                      !_isAiSearchLoading
                                  ? ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: mergePropertyData.length,
                                      itemBuilder: (context, index) {
                                        return AdvertisementPropertyComponent(
                                          property: mergePropertyData[index],
                                          isFullWidth: true,
                                          onCall: () {},
                                        ).onTap(() async {
                                          bool? res =
                                              await PropertyDetailScreen(
                                                      propertyId:
                                                          mergePropertyData[
                                                                  index]
                                                              .id)
                                                  .launch(context);
                                          if (res == true) {
                                            searchPropertyApi();
                                            setState(() {});
                                          }
                                        });
                                      })
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(language.foundState,
                                                  style: primaryTextStyle(),
                                                  textAlign: TextAlign.start)),
                                          40.height,
                                          Image.asset(ic_no_search_found,
                                                  height: 150, width: 200)
                                              .center(),
                                          20.height,
                                          Text(language.searchNotFound,
                                                  style: boldTextStyle())
                                              .center(),
                                          20.height,
                                          Text(
                                            language.searchMsg
                                                .capitalizeFirstLetter(),
                                            style: secondaryTextStyle(),
                                            textAlign: TextAlign.center,
                                          ).paddingSymmetric(horizontal: 16)
                                        ]).paddingSymmetric(vertical: 16),
                          widget.mPropertyData != null
                              ? ListView.builder(
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  shrinkWrap: true,
                                  itemCount: widget.mPropertyData!.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: radius(12),
                                        backgroundColor: appStore.isDarkModeOn
                                            ? cardDarkColor
                                            : primaryExtraLight,
                                      ),
                                      child: Row(children: [
                                        Stack(
                                          children: [
                                            cachedImage(
                                                    widget.mPropertyData![i]
                                                        .propertyImage,
                                                    height: 155,
                                                    width: 110,
                                                    fit: BoxFit.fill)
                                                .cornerRadiusWithClipRRectOnly(
                                                    bottomLeft: 12,
                                                    topLeft: 12),
                                            Positioned(
                                              bottom: 10,
                                              left: 6,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                        borderRadius: radius(4),
                                                        backgroundColor:
                                                            primaryLight),
                                                child: Text(
                                                    widget.mPropertyData![i]
                                                                .propertyFor ==
                                                            0
                                                        ? language.forRent
                                                        : widget
                                                                    .mPropertyData![
                                                                        i]
                                                                    .propertyFor ==
                                                                1
                                                            ? language.forSell
                                                            : language.pg,
                                                    style: primaryTextStyle(
                                                        color: primaryColor,
                                                        size: 12)),
                                              ),
                                            ),
                                            if (userStore.subscription == "1" &&
                                                widget.mPropertyData![i]
                                                        .premiumProperty ==
                                                    1)
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child:
                                                    PremiumBtn(pDetail: true),
                                              ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                PriceWidget(
                                                        price: formatNumberString(
                                                            widget
                                                                .mPropertyData![
                                                                    i]
                                                                .price!),
                                                        textStyle: boldTextStyle(
                                                            size: 18,
                                                            color:
                                                                primaryColor))
                                                    .expand(),
                                                fevIconWidget(
                                                        widget.mPropertyData![i]
                                                            .isFavourite,
                                                        context)
                                                    .onTap(() {
                                                  setFavouriteApi(
                                                      widget
                                                          .mPropertyData![i].id,
                                                      widget.mPropertyData![i]
                                                          .isFavourite);

                                                  if (widget.mPropertyData![i]
                                                          .isFavourite ==
                                                      1) {
                                                    widget.mPropertyData![i]
                                                        .isFavourite = 0;
                                                  } else {
                                                    widget.mPropertyData![i]
                                                        .isFavourite = 1;
                                                  }
                                                  setState(() {});
                                                })
                                              ],
                                            ),
                                            8.height,
                                            Row(
                                              children: [
                                                Image.asset(ic_property,
                                                    height: 20,
                                                    width: 20,
                                                    color: primaryColor),
                                                5.width,
                                                Text(
                                                    widget.mPropertyData![i]
                                                        .category
                                                        .toString(),
                                                    style: secondaryTextStyle())
                                              ],
                                            ),
                                            8.height,
                                            Text(
                                                widget.mPropertyData![i].name
                                                    .validate()
                                                    .capitalizeFirstLetter(),
                                                style: primaryTextStyle()),
                                            8.height,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(ic_map_point,
                                                    height: 20, width: 20),
                                                5.width,
                                                Text(
                                                  widget
                                                      .mPropertyData![i].address
                                                      .validate(),
                                                  style: secondaryTextStyle(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).expand()
                                              ],
                                            ),
                                          ],
                                        )
                                            .paddingSymmetric(
                                                horizontal: 15, vertical: 0)
                                            .expand()
                                      ]),
                                    ).onTap(() async {
                                      bool? res = await PropertyDetailScreen(
                                              propertyId:
                                                  widget.mPropertyData![i].id)
                                          .launch(context);

                                      if (res == true) {
                                        init();
                                        setState(() {});
                                      }
                                    });
                                  }).visible(widget.isFilter == true)
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                      Text(language.foundState,
                                          style: primaryTextStyle(),
                                          textAlign: TextAlign.start),
                                      40.height,
                                      Image.asset(ic_no_search_found,
                                              height: 150, width: 200)
                                          .center(),
                                      20.height,
                                      Text(language.searchNotFound,
                                              style: boldTextStyle())
                                          .center(),
                                      20.height,
                                      Text(
                                        language.searchMsg,
                                        style: secondaryTextStyle(),
                                        textAlign: TextAlign.center,
                                      ).paddingSymmetric(horizontal: 16)
                                    ]).visible(widget.isFilter == true),
                          Stack(
                            children: [],
                          ).visible(widget.isFilter == true),
                        ],
                      )
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
            Loader().center().visible(appStore.isLoading && !_isAiSearchLoading)
          ],
        ),
      );
    }));
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
