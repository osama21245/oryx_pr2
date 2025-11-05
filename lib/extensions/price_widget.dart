import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orex/utils/colors.dart';
import 'package:orex/utils/images.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/shared_pref.dart';
import '../extensions/text_styles.dart';
import '../main.dart';
import '../utils/constants.dart';

class PriceWidget extends StatefulWidget {
  var price;
  final double? size;
  final Color? color;
  final TextStyle? textStyle;

  PriceWidget({
    super.key,
    this.price,
    this.color,
    this.size = 22.0,
    this.textStyle,
  });

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  var currency = '₹';

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    setState(() {
      currency = getStringAsync(CurrencySymbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userStore.currencyPosition == "left") {
      return Row(
        children: [
          Image.asset(ic_moneys, width: 24, height: 24, color: primaryColor),
          4.width,
          currencyWidget(),
          2.width,
          Text(widget.price.toString(),
              style: widget.textStyle ??
                  primaryTextStyle(
                      color: widget.color ?? textPrimaryColorGlobal,
                      size: widget.size!.toInt())),
        ],
      );
    } else {
      return Row(
        children: [
          Image.asset(ic_moneys, width: 24, height: 24, color: primaryColor),
          4.width,
          Text(
            widget.price.toString(),
            style: TextStyle(
              color:
                  appStore.isDarkModeOn ? Colors.white : textPrimaryColorGlobal,
              fontWeight: widget.textStyle!.fontWeight ?? FontWeight.w400,
              fontSize: widget.textStyle!.fontSize ?? 18,
            ),
            // widget.textStyle ??
            //     primaryTextStyle(
            //         color: widget.color ?? textPrimaryColorGlobal,
            //         size: widget.size!.toInt())
          ),
          2.width,
          currencyWidget(),
        ],
      );
    }
  }

  Widget currencyWidget() {
    return Text(currency,
        style: GoogleFonts.roboto(
            color:
                appStore.isDarkModeOn ? Colors.white : textPrimaryColorGlobal,
            fontWeight: widget.textStyle!.fontWeight ?? FontWeight.w400,
            fontSize: widget.textStyle!.fontSize ?? 18));
  }
}
