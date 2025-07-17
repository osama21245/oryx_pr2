import 'package:flutter/material.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/main.dart';

class TransactionTypeCard extends StatelessWidget {
  final String imagePath;
  final String type;
  bool isSelected;
  bool isGif;
  TransactionTypeCard(
      {super.key,
      required this.isSelected,
      required this.imagePath,
      required this.type,
      this.isGif = false});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 4,
          ),
          color: Theme.of(context).disabledColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(23)),
      child: Column(
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
              ? Image.network(
                  imagePath,
                  width: size.width * 0.5,
                  height: size.height * 0.2,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  imagePath,
                  width: size.width * 0.5,
                  height: size.height * 0.2,
                ),
          Text(
            type,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : appStore.isDarkModeOn
                        ? textOnDarkMode
                        : textOnLightMode),
          ),
        ],
      ),
    );
  }
}
