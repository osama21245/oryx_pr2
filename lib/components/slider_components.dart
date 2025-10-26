import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orex/extensions/text_styles.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/string_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../models/dashBoard_response.dart';
import '../screens/slider_details_screen.dart';
import '../extensions/common.dart';
import '../utils/app_common.dart';

class SlidesComponents extends StatefulWidget {
  final List<MSlider>? data;
  SlidesComponents({required this.data});
  @override
  State<SlidesComponents> createState() => _SlidesComponentsState();
}

class _SlidesComponentsState extends State<SlidesComponents> {
  PageController pageController = PageController();
  late Timer _autoScrollTimer;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  void startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (widget.data == null || widget.data!.isEmpty) return;

      currentIndex++;
      if (currentIndex >= widget.data!.length) {
        currentIndex = 0;
      }

      if (mounted) {
        pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = context.height() * 0.3;
    return Column(
      children: [
        16.height,
        SizedBox(
          height: mHeight,
          width: context.width(),
          child: PageView.builder(
            itemCount: widget.data!.length,
            controller: pageController,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              return cachedImage(widget.data![i].sliderImage.validate(),
                      height: mHeight,
                      fit: BoxFit.cover,
                      width: context.width())
                  .cornerRadiusWithClipRRect(16)
                  .paddingOnly(right: 16, bottom: 8, left: 16)
                  .onTap(() {
                SliderDetailsScreen(slider: widget.data![i]).launch(context);
              });
            },
            onPageChanged: (int i) {
              setState(() {
                currentIndex = i;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 18),
            child: Text(
              widget.data![currentIndex].name.validate(),
              style: boldTextStyle(),
            ),
          ),
        ),
        dotIndicator(widget.data!, currentIndex).paddingTop(4),
      ],
    );
  }
}
