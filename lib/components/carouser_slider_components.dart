import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/models/dashBoard_response.dart';

import '../extensions/text_styles.dart';
import '../utils/app_common.dart';

class CarouserSliderComponents extends StatefulWidget {
  final DashboardResponse data;

  const CarouserSliderComponents({super.key, required this.data});

  @override
  State<CarouserSliderComponents> createState() =>
      _CarouserSliderComponentsState();
}

final CarouselSliderController _carouselController = CarouselSliderController();

class _CarouserSliderComponentsState extends State<CarouserSliderComponents> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: _carouselController,
      items: List.generate(widget.data.property!.length, (index) {
        return Container(
          width: context.width() * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: cachedImage(
                  widget.data.property![index].propertyImage.toString(),
                  width: context.width(),
                  height: context.height() * 00.15,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.property![index].name.toString(),
                    style: boldTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ), Text(
                    widget.data.property![index].address.toString(),
                    style: boldTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ],
          ),
        );
      }),
      options: _carouselOptions(),
    );
  }

  CarouselOptions _carouselOptions() {
    return CarouselOptions(
      height: context.height() / 4,
      autoPlay: false,
      autoPlayCurve: Curves.decelerate,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      viewportFraction: 0.8,
    );
  }
}
