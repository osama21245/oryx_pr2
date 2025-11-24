import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/dashBoard_response.dart';
import '../components/advertisement_property_component.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../extensions/text_styles.dart';
import 'no_data_screen.dart';
import 'property_detail_screen.dart';
import 'subscribe_screen.dart';
import 'search_screen.dart';

class CategorySelectedScreen extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;
  final int? transactionType;
  final Map<String, String>? selectedOptions;
  const CategorySelectedScreen(
      {this.categoryName,
      this.categoryId,
      this.transactionType,
      this.selectedOptions,
      super.key});

  @override
  State<CategorySelectedScreen> createState() => _CategorySelectedScreenState();
}

class _CategorySelectedScreenState extends State<CategorySelectedScreen> {
  List<Property> mPropertyDataSelected = [];

  int page = 1;
  int? numPage;
  int? currentIndex = 0;
  bool isLastPage = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  Future<void> init() async {
    await getPropertyApiCall();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getPropertyApiCall() async {
    appStore.setLoading(true);
    Map req = {
      "city": userStore.cityName,
      "category_id": widget.categoryId,
      "property_for": widget.transactionType,
    };
    if (widget.selectedOptions != null && widget.selectedOptions!.isNotEmpty) {
      int i = 1;
      for (var value in widget.selectedOptions!.values) {
        req["filter_option[]$i"] = value;
        i++;
      }
    }
    if (kDebugMode) {
      print('object req: $req');
    }
    await filterApi(req, page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mPropertyDataSelected.clear();
      }
      Iterable it = value.property!;
      it.map((e) => mPropertyDataSelected.add(e)).toList();
      // Filter the list to only include properties matching the transaction type
      mPropertyDataSelected = mPropertyDataSelected
          .where((p) => p.propertyFor == widget.transactionType)
          .toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error);
    });
    widget.selectedOptions?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName ?? 'Filter Category'),
          centerTitle: true,
        ),
        bottomNavigationBar:
            showBannerAdOnCategorySelected && userStore.isSubscribe == 0
                ? /*  showBannerAds(context) */ SizedBox()
                : SizedBox(),
        body: Stack(
          children: [
            mPropertyDataSelected.isNotEmpty
                ? ListView.builder(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemCount: mPropertyDataSelected.length,
                    itemBuilder: (context, i) {
                      return widget.categoryId ==
                              mPropertyDataSelected[i].categoryId
                          ? AdvertisementPropertyComponent(
                              property: mPropertyDataSelected[i],
                              onCall: () {
                                getPropertyApiCall();
                              },
                              isFullWidth: true,
                            )
                              .paddingOnly(bottom: 16)
                              .visible(widget.categoryId ==
                                  mPropertyDataSelected[i].categoryId)
                              .onTap(() async {
                              if (mPropertyDataSelected[i].premiumProperty ==
                                  1) {
                                if (userStore.subscription == "1") {
                                  if (userStore.isSubscribe != 0) {
                                    bool? res = await PropertyDetailScreen(
                                            propertyId:
                                                mPropertyDataSelected[i].id)
                                        .launch(context);
                                    if (res == true) {
                                      init();
                                    }
                                  } else {
                                    SubscribeScreen().launch(context);
                                  }
                                } else {
                                  bool? res = await PropertyDetailScreen(
                                          propertyId:
                                              mPropertyDataSelected[i].id)
                                      .launch(context);
                                  if (res == true) {
                                    init();
                                  }
                                }
                              } else {
                                bool? res = await PropertyDetailScreen(
                                        propertyId: mPropertyDataSelected[i].id)
                                    .launch(context);
                                if (res == true) {
                                  init();
                                }
                              }
                            })
                          : SizedBox.shrink();
                    })
                : NoDataScreen(mTitle: language.resultNotFound)
                    .visible(!appStore.isLoading),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
        floatingActionButton: _buildOryxAIFloatingButton(),
      );
    });
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
}
