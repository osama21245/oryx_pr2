import 'package:flutter/material.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/main.dart';

class TransactionTypeCard extends StatelessWidget {
  final String imagePath;
  final String? type;
  final String? decorationImagePath;
  bool isSelected;
  bool isGif;
  double? width, height, padding;
  BorderRadiusGeometry? borderRadius;

  TransactionTypeCard({
    super.key,
    required this.isSelected,
    required this.imagePath,
    this.type,
    this.borderRadius,
    this.height,
    this.width,
    this.padding = 0,
    this.isGif = false,
    this.decorationImagePath,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(23);
    return Container(
      width: width ?? size.width * 0.9,
      height: height,
      padding: EdgeInsets.symmetric(vertical: padding!),
      decoration: BoxDecoration(
          image: decorationImagePath != null
              ? DecorationImage(fit: BoxFit.cover,image: AssetImage(decorationImagePath ?? ""))
              : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 4,
          ),
          color: Theme.of(context).disabledColor.withOpacity(0.1),
          borderRadius: effectiveBorderRadius),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Align(
            //   alignment: AlignmentDirectional.topEnd,
            //   child: CustomImageView(
            //     svgPath:
            //         isSelected ? Images.svgSelectedIcon : Images.svgSelectIcon,
            //     width: 40,
            //     height: 40,
            //   ),
            // ),
            isGif
                ? Expanded(
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: effectiveBorderRadius,
                      child: Image.network(
                        imagePath,
                        width: width ?? size.width * 0.9,
                        height: size.height * 0.3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: size.width * 0.3,
                    height: size.height * 0.09,
                  ),
            type != null
                ? Text(
                    type!,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : appStore.isDarkModeOn
                                ? textOnDarkMode
                                : textOnLightMode),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
