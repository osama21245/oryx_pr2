import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orex/extensions/app_text_field.dart';
import 'package:orex/extensions/decorations.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/utils/colors.dart';

Widget priceMeterFields(priceMeterList, context, {required Function setState}) {
  return Column(
    children: List.generate(priceMeterList.length, (index) {
      final item = priceMeterList[index];
      return Row(
        children: [
          // حقل السعر
          Expanded(
            child: AppTextField(
              controller: item["price"],
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration: defaultInputDecoration(context, label: 'السعر'),
            ),
          ),
          10.width,
          // حقل المساحة
          Expanded(
            child: AppTextField(
              controller: item["area"],
              textFieldType: TextFieldType.NUMBER,
              keyboardType: TextInputType.number,
              decoration:
                  defaultInputDecoration(context, label: 'المساحة بالمتر'),
            ),
          ),
          10.width,
          Expanded(
            child: AppTextField(
              controller: item["type"],
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.text,
              decoration: defaultInputDecoration(context, label: 'النوع'),
            ),
          ),
          10.width,
          if (index == priceMeterList.length - 1)
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                setState(() {
                  priceMeterList.add({
                    "price": TextEditingController(),
                    "area": TextEditingController(),
                    "type": TextEditingController(),
                  });
                });
              },
            ),

          if (priceMeterList.length > 1 && index < priceMeterList.length - 1)
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  priceMeterList.removeAt(index);
                });
              },
            ),
        ],
      ).paddingSymmetric(vertical: 8);
    }),
  );
}
