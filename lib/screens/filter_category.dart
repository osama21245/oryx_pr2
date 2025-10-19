import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orex/extensions/app_button.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/main.dart';
import 'package:orex/models/filter_category_model.dart';
import 'package:orex/network/RestApis.dart';
import 'package:orex/screens/category_selected_screen.dart';
import 'package:orex/utils/colors.dart';

Map<String, String> selectedOptions =
    {}; // key: filter name, value: selected option

class FilterCategory extends StatefulWidget {
  final String? categoryName;
  final int? categoryId;
  final int? transactionType;
  const FilterCategory(
      {super.key, this.categoryName, this.categoryId, this.transactionType});

  @override
  State<FilterCategory> createState() => _FilterCategoryState();
}

class _FilterCategoryState extends State<FilterCategory> {
  List<FilterCategoryModel> filterCategoryList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<void> init() async {
    await getFilterCategory();
  }
getFilterCategory() async {
  appStore.setLoading(true);

  await getFilterCategoryApi(widget.categoryId!).then((value) {
    appStore.setLoading(false);

    // Always navigate to CategorySelectedScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectedScreen(
          categoryId: widget.categoryId ?? 0,
          categoryName: widget.categoryName ?? '',
          transactionType: widget.transactionType ?? 0,
          selectedOptions: selectedOptions,
        ),
      ),
    );
  }).catchError((e) {
    appStore.setLoading(false);
    print(e.toString());
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(widget.categoryName ?? 'Filter Category'),
        centerTitle: true,
      ),
      body: appStore.isLoading
          ? buildShimmerEffect()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return filterItem(filterCategoryList[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: filterCategoryList.length,
                  ),
                  20.height,
                  AppButton(
                    padding: EdgeInsets.zero,
                    text: language.Continue,
                    width: context.width(),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () {
                      CategorySelectedScreen(
                        categoryId: widget.categoryId ?? 0,
                        categoryName: widget.categoryName ?? '',
                        transactionType: widget.transactionType ?? 0,
                        selectedOptions: selectedOptions,
                      ).launch(context);
                    },
                  )
                ],
              ),
            ),
    );
  }

  Widget filterItem(FilterCategoryModel? model) {
    print('model!.toJson(): ${model?.toJson()}');
    return DropdownButtonFormField<Option>(
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: black),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: appStore.isDarkModeOn ? cardDarkColor : Color(0xffE9E9E9),
        hintText: model?.name ?? 'Filter',
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
      ),
      items: model?.options
          ?.map((option) => DropdownMenuItem<Option>(
                value: option,
                child: Text(option.value ?? ''),
              ))
          .toList(),
      onChanged: (value) {
        // Handle filter selection
        if (value != null && model!.name != null) {
          setState(() {
            selectedOptions[model.name!] = value.id.toString();
          });
          print('Selected filter: ${value.id?.toString()}');
        }
      },
    );
  }

  Widget buildShimmerEffect() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: appStore.isDarkModeOn ? cardDarkColor : Color(0xffE9E9E9),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemCount: 5,
    );
  }
}
