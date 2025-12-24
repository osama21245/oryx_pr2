import 'package:flutter/material.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/string_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/screens/choose_transaction_type_screen.dart';
import 'package:orex/screens/filter_category.dart';
import 'package:orex/models/category_list_model.dart';
import 'package:orex/network/RestApis.dart';
import 'package:orex/screens/filter_screen.dart';
import 'package:orex/screens/search_screen.dart';
import 'package:orex/utils/app_textfiled.dart';
import 'package:orex/utils/images.dart';
import 'package:orex/components/transaction_type_card.dart';
import 'package:orex/models/gif_model.dart';
import '../components/meta_banner.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/static_translations.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController mSearchCont = TextEditingController();

  String gifUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    fetchGif();
  }

  Future<void> fetchGif() async {
    try {
      GifResponse gifResponse = await getGIFApi();
      gifUrl = gifResponse.url ?? '';
      setState(() {});
    } catch (e) {
      print('Error fetching GIF: $e');
    }
  }

  // add by Axon
  bool showSacandDropdown = false;
  bool showCategoryDropdown = false;

  String? selectedCity;
  String? selectedCityId;
  String? selectCityName;
  String? selectedCategoryId;
  String? selectedCategoryName;
  List<CategoryData> categoryData = [];
  int? selectedTransactionType;

  Future<void> getData() async {
    appStore.setLoading(true);

    Map request = {
      "player_id": getStringAsync(PLAYER_ID),
    };

    if (userStore.latitude.isNotEmpty) {
      request["latitude"] = userStore.latitude;
    }
    if (userStore.longitude.isNotEmpty) {
      request["longitude"] = userStore.longitude;
    }
    if (userStore.cityName.isNotEmpty) {
      request["city"] = userStore.cityName;
    }

    await getDashBoardData(request).then((value) {
      data = value;

      userStore.setMinPrice(data!.filterConfiguration!.minPrice.toString());
      userStore.setMaxPrice(data!.filterConfiguration!.maxPrice.toString());

      setState(() {});
    }).catchError((e) {
      setState(() {});
      print("=======>${e.toString()}");
    }).whenComplete(
      () => appStore.setLoading(false),
    );
  }

  Future<void> getPropertyCategory() async {
    // get ready for category data
    appStore.setLoading(true);
    getCategory(page: 1).then((value) {
      categoryData = value.data!;
      appStore.setLoading(false);
      setState(() {
        print("categoryData: ${categoryData.length}");
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
        print('---------------------------------------');
      });
    }).catchError((e) {
      appStore.setLoading(false);
      print("Category Error: ${e.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          ic_logo,
          height: 40,
          width:
              40, /* color: appStore.isDarkModeOn ? Colors.white : primaryColor, fit: BoxFit.fill */
        ).paddingOnly(left: 16, top: 8, bottom: 8),
        title: Text(language.selectCity),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //?? add by Axon
            // Search widget above grid
            searchWidget(),
            20.height,
            if (gifUrl.isNotEmpty) // Only show if GIF URL is available, or use empty check inside? The original uses `TransactionTypeCard` which handles display.
              // The original code in `choose_transaction_type_screen.dart` unconditionally shows it but fetches the gif.
              // Let's match the user request: "this slider ... i want this component to be in the home page"
              TransactionTypeCard(
                width: MediaQuery.of(context).size.width,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                isSelected: false,
                imagePath: gifUrl,
                padding: 0,
                decorationImagePath: splash,
                isGif: true,
              ).paddingSymmetric(horizontal: 16),
            20.height,
            _buildFirstDropdown(),
            _buildSecondDropdown(),
            _buildCategoryDropdown(),
            // old code
            _buldGrid(),
            // new code
          ],
        ),
      ),
    );
  }

  Widget _buldGrid() {
    if (data?.propertyCity?.isNotEmpty ?? false) {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            // crossAxisSpacing: 10.0,
            // mainAxisSpacing: 10.0,
            childAspectRatio: 1.5 / 1.9),
        shrinkWrap: true,
        padding: EdgeInsets.all(16.0),
        itemCount: data!.propertyCity?.length ?? 0,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.all(8.0),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor:
                appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
            borderRadius: radius(24),
          ),
          child: Column(
            children: [
              Expanded(
                  child: cachedImage(
                data!.propertyCity![index].images.toString(),
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(24)),
              Text(overflow: TextOverflow.ellipsis,
                      translateCityName(
                        data!.propertyCity![index].name.toString(),
                        appStore.selectedLanguage,
                      ),
                      style: primaryTextStyle(
                          color: appStore.isDarkModeOn
                              ? textColorDark
                              : primaryColor,
                          size: 16))
                  .paddingBottom(8)
            ],
          ),
        )
            .paddingOnly(left: 8, right: 8, top: 10, bottom: 10)
            .center()
            .onTap(() async {
          selectedCity = data!.propertyCity![index].name.toString();
          selectCityName = selectedCity;
          // appStore.setLoading(true);
          userStore.setUserCity(selectCityName!).then((value) =>
              ChooseTransactionTypeScreen().launch(context, isNewTask: false));
          await getDashBoardData({
            "latitude": userStore.latitude,
            "longitude": userStore.longitude,
            "city": userStore.cityName,
            "player_id": getStringAsync(PLAYER_ID)
          }).then((value) {
            data = value;
            userStore
                .setMinPrice(data!.filterConfiguration!.minPrice.toString());
            userStore
                .setMaxPrice(data!.filterConfiguration!.maxPrice.toString());
            setState(() {});
          }).catchError((e) {
            setState(() {});
            print("=======>${e.toString()}");
          }).whenComplete(
            () => appStore.setLoading(false),
          );
          // selectedCity = data!.propertyCity![index].id.toString();
          // selectCityName = data!.propertyCity![index].name.toString();
          // userStore.setUserCity(selectCityName!).then((value) {
          //   setState(() {
          //     selectedCity = data!.propertyCity![index].id.toString();
          //     selectCityName = data!.propertyCity![index].name.toString();
          //     showSacandDropdown = true;
          //   });
          // });
          // ChooseTransactionTypeScreen()
          //     .launch(context, isNewTask: false);
          // userStore.setUserCity(selectCityName!).then((value) =>
          //     ChooseTransactionTypeScreen()
          //         .launch(context, isNewTask: false));
          // DashboardScreen().launch(context, isNewTask: true);
        }),
      );
      // Container(
      //   constraints: BoxConstraints(minWidth: 200,minHeight: 200),
      //   decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight, borderRadius: radius(24),),
      //   child:
      // ),
      // WaveAnimation(
      //   key: _waveAnimationKey,
      //   size: 80.0,
      //   color: primaryColor.withOpacity(0.3), // You can specify your desired color here
      //   centerChild: Image.asset(ic_logo, color: primaryExtraLight, height: 22, width: 24),
      // ),
      // Text(language.fetchingYourCurrentLocation, style: secondaryTextStyle(color: primaryColor))
    } else {
      return SizedBox.shrink();
    }
  }

  // Widget _buildFirstDropdown() {
  //   if (data?.propertyCity?.isNotEmpty ?? false) {
  //     return Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: DropdownButtonFormField<String>(
  //         value: selectedCity,
  //         decoration: InputDecoration(
  //           labelText: language.selectCity,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //         ),
  //         items: data!.propertyCity!
  //             .map((city) => DropdownMenuItem<String>(
  //                   value: city.id.toString(),
  //                   child: Row(
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(12),
  //                         child: cachedImage(
  //                           (city.images != null && city.images!.isNotEmpty)
  //                               ? city.images!
  //                               : 'https://via.placeholder.com/32',
  //                           width: 32,
  //                           height: 32,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                       SizedBox(width: 12),
  //                       Text(
  //                         city.name ?? '',
  //                         style: TextStyle(
  //                             color: appStore.isDarkModeOn
  //                                 ? textOnDarkMode
  //                                 : textOnLightMode),
  //                       ),
  //                     ],
  //                   ),
  //                 ))
  //             .toList(),
  //         onChanged: (value) {
  //           setState(() {
  //             selectedCity = value;
  //             // Find the city name by id
  //             selectCityName = data!.propertyCity!
  //                 .firstWhere((city) => city.id.toString() == value)
  //                 .name;
  //           });
  //           userStore.setUserCity(selectCityName!).then((_) {
  //             setState(() {
  //               showSacandDropdown = true;
  //               // showCategoryDropdown = true;
  //             });
  //             // ChooseTransactionTypeScreen().launch(context, isNewTask: false);
  //           });
  //         },
  //       ),
  //     );
  //   } else {
  //     return SizedBox.shrink();
  //   }
  // }
  //region search widget
  Widget searchWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(10),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ic_magnifier, height: 30, width: 20),
          10.width,
          AppTextField(
                  readOnly: true,
                  controller: mSearchCont,
                  textStyle: primaryTextStyle(),
                  textFieldType: TextFieldType.NAME,
                  onTap: () async {
                    bool? res =
                        await SearchScreen(isBack: true).launch(context);
                    if (res == true) {
                      getData();
                      setState(() {});
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: language.search,
                      hintStyle: primaryTextStyle(color: grey),
                      fillColor: appStore.isDarkModeOn
                          ? cardDarkColor
                          : primaryExtraLight))
              .expand(),
          Image.asset(ic_filter, height: 20, width: 20).onTap(() {
            FilterScreen(isSelect: true).launch(context);
          })
        ],
      ),
    );
  }

  //endregion

  Widget _buildFirstDropdown() {
    if (data?.propertyCity?.isNotEmpty ?? false) {
      // لو القيمة الحالية مش موجودة في القائمة، خليها null
      if (selectedCityId != null &&
          !data!.propertyCity!
              .any((city) => city.id.toString() == selectedCityId)) {
        selectedCityId = null;
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: selectedCityId,
          decoration: InputDecoration(
            labelText: language.selectCity,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: data!.propertyCity!
              .map((city) => DropdownMenuItem<String>(
                    value: city.id.toString(),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: cachedImage(
                            (city.images != null && city.images!.isNotEmpty)
                                ? city.images!
                                : 'https://via.placeholder.com/32',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          translateCityName(
                            city.name ?? '',
                            appStore.selectedLanguage,
                          ).capitalizeFirstLetter(),
                          style: TextStyle(
                            color: appStore.isDarkModeOn
                                ? textOnDarkMode
                                : textOnLightMode,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCityId = value;
              selectCityName = data!.propertyCity!
                  .firstWhere((city) => city.id.toString() == value)
                  .name;
            });
            userStore.setUserCity(selectCityName!).then((_) {
              setState(() {
                showSacandDropdown = true;
              });
            });
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildSecondDropdown() {
    return showSacandDropdown
        ? ChooseTransactionTypeDropdown(onChanged: (value) {
            setState(() {
              selectedTransactionType = value;
              showCategoryDropdown = true;
            });
            getPropertyCategory();
          })
        : SizedBox.shrink();
  }

  Widget _buildCategoryDropdown() {
    print("showCategoryDropdown: $showCategoryDropdown");
    print("categoryData length: ${categoryData.length}");

    if (!showCategoryDropdown) {
      return SizedBox.shrink();
    }

    if (categoryData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategoryId,
        decoration: InputDecoration(
          labelText: language.category,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: categoryData
            .map((category) => DropdownMenuItem<String>(
                  value: category.id.toString(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: cachedImage(
                          category.categoryImage ??
                              'https://via.placeholder.com/32',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          color: appStore.isDarkModeOn
                              ? textOnDarkMode
                              : textOnLightMode,
                        ),
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          translateCategoryName(
                            category.name ?? '',
                            appStore.selectedLanguage,
                          ).capitalizeFirstLetter(),
                          style: primaryTextStyle(
                            size: 16,
                            color: appStore.isDarkModeOn
                                ? textOnDarkMode
                                : textOnLightMode,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategoryId = value;
            selectedCategoryName = categoryData
                .firstWhere((category) => category.id.toString() == value)
                .name;
          });

          // Navigate to FilterCategory
          FilterCategory(
            categoryId: int.parse(selectedCategoryId!),
            categoryName: selectedCategoryName!,
            transactionType:
                selectedTransactionType, // You can pass the transaction type here if needed
          ).launch(context);
        },
      ),
    );
  }
}
