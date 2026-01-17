import 'package:flutter/material.dart';
import 'package:orex/components/premium_btn_component.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/string_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';

import '../extensions/colors.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../extensions/price_widget.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../models/dashBoard_response.dart';
import '../network/RestApis.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class VerticalAdvertisementPropertyComponent extends StatefulWidget {
  final Property? property;
  final bool? isFullWidth;
  final Function? onCall;
  final bool fromFav;

  const VerticalAdvertisementPropertyComponent(
      {super.key,
      this.property,
      this.isFullWidth = false,
      this.onCall,
      this.fromFav = false});

  @override
  State<VerticalAdvertisementPropertyComponent> createState() =>
      _VerticalAdvertisementPropertyComponentState();
}

class _VerticalAdvertisementPropertyComponentState
    extends State<VerticalAdvertisementPropertyComponent> {

  setFavouriteApi(int? id) async {
    appStore.setLoading(true);
    Map req = {
      "property_id": id,
    };
    setFavouriteProperty(req).then((value) {
      appStore.setLoading(false);

      if (widget.property!.isFavourite == 1) {
        widget..property!.isFavourite = 0;
      } else {
        widget..property!.isFavourite = 1;
      }
      widget.onCall!.call();
      toast(value.message);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
    });

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    double cardWidth = widget.isFullWidth == true
        ? context.width()
        : context.width() * 0.5;
    return Container(
      width: cardWidth,
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(12),
        backgroundColor:
        appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              cachedImage(
                widget.property!.propertyImage.validate(),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 12, topRight: 12),

              if (userStore.subscription == "1" &&
                  widget.property!.premiumProperty == 1)
                Positioned(top: 0, left: 0, child: PremiumBtn(pDetail: true)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text(widget.property!.category.validate(),
                  style: boldTextStyle(
                      size: 14,
                      color: appStore.isDarkModeOn
                          ? lightBackgroundColor
                          : Colors.black)),
              4.height,
              Text(
                widget.property!.name.validate(),
                style: boldTextStyle(
                    size: 16,
                    color: appStore.isDarkModeOn
                        ? lightBackgroundColor
                        : Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriceWidget(
                      price: formatNumberString(
                          widget.property!.price.validate()),
                      textStyle:
                      boldTextStyle(size: 16, color: primaryColor))
                      .expand(),
                  fevIconWidget(
                      widget.fromFav ? 1 : widget.property!.isFavourite,
                      context)
                      .onTap(() {
                    setFavouriteApi(widget.property!.id);
                  }),
                ],
              ),

              8.height,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(ic_map_point,
                      width: 18, height: 18, color: primaryColor),
                  4.width,
                  Text(widget.property!.address?.validate() ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryTextStyle(
                          size: 14,
                          weight: FontWeight.w400,
                          color: appStore.isDarkModeOn
                              ? lightBackgroundColor
                              : Colors.black))
                      .expand()
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 8),
        ],
      ),
    );
  }
}
