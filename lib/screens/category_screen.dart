import 'package:flutter/material.dart';
import 'package:orex/components/slider_components.dart';
import 'package:orex/models/dashBoard_response.dart';
import 'package:orex/screens/filter_category.dart';
import 'package:orex/screens/home_screen.dart';
import 'package:orex/utils/images.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../components/oryx_ai.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/colors.dart';
import '../extensions/decorations.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/category_list_model.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/static_translations.dart';
import 'no_data_screen.dart';
import 'search_screen.dart';

class CategoryScreen extends StatefulWidget {
  final int? transactionType;
  const CategoryScreen({super.key, this.transactionType});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryData> categoryData = [];
  int page = 1;
  int? numPage;
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
    await getPropertyCategory();
    await getFilterSliders();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getPropertyCategory() async {
    appStore.setLoading(true);
    getCategory(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        categoryData.clear();
      }
      Iterable it = value.data!;
      it.map((e) => categoryData.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  //Filter sliders based on selected transaction type
  List<MSlider>? filteredSliders;
  Future<void> getFilterSliders() async {
    if (widget.transactionType == 0) {
      filteredSliders = data!.slider!.where((slider) {
        return slider.propertyFor != null &&
            slider.propertyFor == widget.transactionType;
      }).toList();
    } else if (widget.transactionType == 1) {
      filteredSliders = data!.slider!.where((slider) {
        return slider.propertyFor != null &&
            slider.propertyFor == widget.transactionType;
      }).toList();
    } else {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('ddddddaaaaaaaaaaaa ${data!.slider!.length}');
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Image.asset(
            ic_logo,
            height: 40,
            width: 40,
          ).paddingOnly(left: 16, top: 8, bottom: 8),
        ),
        title: Text(language.category),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          categoryData.isNotEmpty
              ? SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      if (data!.slider!.isNotEmpty)

                        // Show slider only if a transaction type is selected
                        if (widget.transactionType != null &&
                            filteredSliders != null &&
                            filteredSliders!.isNotEmpty)
                          SlidesComponents(data: filteredSliders),
                      const SizedBox(height: 16),
                      AnimatedWrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: List.generate(categoryData.length, (i) {
                          return buildCategoryItem(categoryData[i]);
                        }),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 16).paddingBottom(20),
                )
              : appStore.isLoading
                  ? buildShimmerEffect()
                  : NoDataScreen(mTitle: language.resultNotFound)
                      .visible(!appStore.isLoading),
        ],
      ),
      floatingActionButton: OryxAIFloatingButton(),
    );
  }

  Widget _buildOryxAIFloatingButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 16),
      child: FloatingActionButton(
        onPressed: () {
          SearchScreen(
            isBack: true,
            openVoiceDialog: true,
          ).launch(context);
        },
        backgroundColor: primaryColor,
        elevation: 8,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            app_logo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItem(CategoryData category) {
    return GestureDetector(
      onTap: () {
        FilterCategory(
          categoryId: category.id,
          categoryName: translateCategoryName(
            category.name.toString(),
            appStore.selectedLanguage,
          ).capitalizeFirstLetter(),
          transactionType: widget.transactionType,
        ).launch(context);
        // CategorySelectedScreen(
        //   categoryId: category.id,
        //   categoryName: category.name.toString(),
        // ).launch(context);
      },
      child: Container(
        width: context.width() * 0.42,
        padding: EdgeInsets.all(16),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor:
              appStore.isDarkModeOn ? cardDarkColor : Color(0xffE9E9E9),
        ),
        child: Row(
          children: [
            cachedImage(
              category.categoryImage,
              height: 25,
              width: 25,
              fit: BoxFit.cover,
              color: appStore.isDarkModeOn ? textOnDarkMode : textOnLightMode,
            ).cornerRadiusWithClipRRect(12),
            SizedBox(width: 16),
            Expanded(
              flex: 6,
              child: Text(
                translateCategoryName(
                  category.name.toString(),
                  appStore.selectedLanguage,
                ).capitalizeFirstLetter(),
                style: primaryTextStyle(
                    size: 16,
                    color: appStore.isDarkModeOn
                        ? textOnDarkMode
                        : textOnLightMode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: appStore.isDarkModeOn ? Colors.white : black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Shimmer(
              duration: const Duration(seconds: 2), // Adjust shimmer duration
              interval: const Duration(
                  seconds: 1), // Adjust interval between animations
              color: Colors.grey.shade300,
              enabled: true,
              child: Container(
                width: double.infinity,
                height: 200,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Column(
              children: List.generate(6, (index) {
                return Shimmer(
                  duration:
                      const Duration(seconds: 2), // Adjust shimmer duration
                  interval: const Duration(
                      seconds: 1), // Adjust interval between animations
                  color: Colors.grey.shade300,
                  enabled: true,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
