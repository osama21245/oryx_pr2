import 'package:flutter/material.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/common.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/extensions/text_styles.dart';
import 'package:orex/screens/developer_screen.dart';
import 'package:orex/screens/edait_property_screen.dart';
import 'package:orex/utils/app_common.dart';
import 'package:orex/main.dart';
import 'package:orex/utils/colors.dart';
import '../network/RestApis.dart';
import '../models/dashBoard_response.dart';

class DeveloperSlidersScreen extends StatefulWidget {
  const DeveloperSlidersScreen({super.key});

  @override
  State<DeveloperSlidersScreen> createState() => _DeveloperSlidersScreenState();
}

class _DeveloperSlidersScreenState extends State<DeveloperSlidersScreen> {
  List<MSlider> mMySliders = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getMySliders();
  }

  Future<void> getMySliders() async {
    appStore.setLoading(true);
    setState(() {});
    try {
      mMySliders = await getMySlidersApi();

      print('my Slider is ${mMySliders[0].toJson()}');
    } catch (e) {
      print(e);
      toast('Error loading sliders');
    } finally {
      appStore.setLoading(false);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = appStore.isDarkModeOn;
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Sliders', style: boldTextStyle()),
        backgroundColor: primaryColor,
      ),
      backgroundColor: isDark ? scaffoldDarkColor : Colors.white,
      body: appStore.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getMySliders,
              child: mMySliders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('No sliders found', style: primaryTextStyle()),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: mMySliders.length,
                      itemBuilder: (context, index) {
                        final slider = mMySliders[index];
                        return InkWell(
                          onTap: () {
                            EdaitPropertyScreen(
                              mSlider: slider,
                            ).launch(context, isNewTask: false);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? cardDarkColor : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cachedImage(
                                  slider.sliderImage,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(12),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  color: appStore.isDarkModeOn
                                      ? darkGrayColor
                                      : Colors.grey.shade300,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Area',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appStore.isDarkModeOn
                                                ? textOnDarkMode
                                                : textOnLightMode,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appStore.isDarkModeOn
                                                ? textOnDarkMode
                                                : textOnLightMode,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Type',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appStore.isDarkModeOn
                                                ? textOnDarkMode
                                                : textOnLightMode,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //const SizedBox(height: 6),
                                slider.areaPrices != null &&
                                        slider.areaPrices!.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: (slider.areaPrices ?? [])
                                            .map((area) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          '${area.area ?? '-'} M',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: appStore
                                                                    .isDarkModeOn
                                                                ? textOnDarkMode
                                                                : textOnLightMode,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          '${area.price ?? 0}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: appStore
                                                                    .isDarkModeOn
                                                                ? textOnDarkMode
                                                                : textOnLightMode,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          area.type ?? '',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: appStore
                                                                    .isDarkModeOn
                                                                ? textOnDarkMode
                                                                : textOnLightMode,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment
                                                //           .spaceBetween,
                                                //   children: [
                                                //     Text(area.area ?? 'No area',
                                                //         style: boldTextStyle(
                                                //             size: 16).copyWith(

                                                //           overflow: TextOverflow
                                                //               .ellipsis,
                                                //         )),
                                                //     Text(
                                                //       '${area.price ?? 0} EGP',
                                                //       style: boldTextStyle(
                                                //         color: Colors.green,

                                                //       ),
                                                //     ),
                                                //     SizedBox(
                                                //       width: 40,
                                                //       child: Text(
                                                //           area.type ?? '',
                                                //           maxLines: 1,
                                                //           overflow: TextOverflow
                                                //               .ellipsis,
                                                //           style:
                                                //               secondaryTextStyle()),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          DeveloperScreen().launch(context);
        },
        label: const Text('Add Property'),
        icon: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}
