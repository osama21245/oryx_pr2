import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orex/components/app_bar_components.dart';
import 'package:orex/components/price_meter_fields.dart';
import 'package:orex/components/required_validation.dart';
import 'package:orex/extensions/animatedList/animated_wrap.dart';
import 'package:orex/extensions/app_button.dart';
import 'package:orex/extensions/app_text_field.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/common.dart';
import 'package:orex/extensions/decorations.dart';
import 'package:orex/models/base_response.dart';
import 'package:orex/models/get_property_developer.dart';
import 'package:orex/network/network_utills.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/subscribe_screen.dart';
import 'package:orex/screens/success_property_add_screen.dart';
import 'package:orex/utils/images.dart';
import '../../models/dashBoard_response.dart' as dashR;
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/extensions/extension_util/int_extensions.dart';
import 'package:orex/extensions/extension_util/string_extensions.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/extensions/loader_widget.dart';
import 'package:orex/extensions/system_utils.dart';
import 'package:orex/extensions/text_styles.dart';
import 'package:orex/main.dart';
import 'package:orex/models/category_list_model.dart';
import 'package:orex/network/RestApis.dart';
import 'package:orex/screens/home_screen.dart';
import 'package:orex/utils/app_common.dart';
import 'package:orex/utils/colors.dart';
import 'package:orex/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  int? selectedCategoryId;
  int sellerType = 0;
  int page = 1;
  int? numPage;
  bool isLastPage = false;

  List<CategoryData> categoryData = [];
  PropertyResponseModel? preporty;
  List<String> selectedImages = [];
  List<XFile>? imageFileList = [];

  List<Map<String, TextEditingController>> priceMeterList = [
    {
      "price": TextEditingController(),
      "area": TextEditingController(),
      "type": TextEditingController(),
    },
  ];

  List<String> propertySellerType = [OWNER, BROKER, BUILDER];
  String? mainImagePath;
  XFile? imageMain;
  Uint8List? mainImage;
  String? mainImageName;

  String? selectedProperty;
  String? mUserType;

  TextEditingController propertyNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController meterController = TextEditingController();

  FocusNode propertyNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode meterFocus = FocusNode();

  GlobalKey<FormState> mSecondComponentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await getPropertyCategory();
    appStore.addPropertyIndex = 0;
  }

  getProperty(categoryId) async {
    print('caaaaaaaaaaa $categoryId');
    appStore.setLoading(true);

    try {
      final response = await getPropertyForDeveloper(categoryId);

      // preportyList.clear();
      if (response.data != null && response.data!.isNotEmpty) {
        if (kDebugMode) {
          for (var element in response.data!) {
            print('element.toJson(): ${element.toJson()}');
          }
        }
        preporty = response;
      }
    } catch (e,trace) {
      print("Error: $e $trace");
    } finally {
      appStore.setLoading(false);
      setState(() {});
    }
  }

  Future<void> getPropertyCategory() async {
    print('start fitch category');
    appStore.setLoading(true);
    await getCategory().then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        categoryData.clear();
      }
      categoryData = value.data!;
      // if (widget.updateProperty.validate()) {
      //   categoryData.contains(updatePropertyData!.data!.categoryId);
      //   selectedCategoryId = updatePropertyData!.data!.categoryId;
      // }
      setState(() {});
      print('aaaaaaaaaa ${categoryData.length}');
    }).catchError((e) {
      print("Error is $e");
      isLastPage = true;
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> saveProperty() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    http.MultipartRequest multiPartRequest =
        await getMultiPartRequest('sliders');

    // البيانات العامة
    multiPartRequest.fields['category_id'] = selectedCategoryId.toString();
    multiPartRequest.fields['property_id'] = selectedProperty!;
    multiPartRequest.fields['name'] = propertyNameController.text;
    multiPartRequest.fields['status'] = '1';
    multiPartRequest.fields['description'] = descriptionController.text;

    multiPartRequest.fields['area_prices'] = jsonEncode(
      priceMeterList
          .map((item) => {
                'area': item['area']?.text ?? '',
                'price': int.tryParse(item['price']?.text ?? '') ?? 0,
                'type': item['type']?.text ?? '',
              })
          .toList(),
    );

    if (mainImagePath != null && !mainImagePath!.contains('https')) {
      multiPartRequest.files
          .add(await http.MultipartFile.fromPath('image', mainImagePath!));
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if ((data as String).isJson()) {
          final res = EPropertyBaseResponse.fromJson(jsonDecode(data));
          toast(res.message ?? 'تم الحفظ');
          if (res.message == "Slider has been save successfully") {
            DashboardScreen().launch(context);
            appStore.addPropertyIndex = 0;
            setState(() {});
          } else if (res.message == "Plan Has Expired") {
            SubscribeScreen().launch(context);
          } else {
            finish(context, true);
          }
          appStore.addPropertyIndex = 0;
        }
      },
      onError: (error) {
        toast("Error: $error");
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      print('errererer ${e.toString()}');
      toast("Exception: ${e.toString()}");
    });
  }

  Widget addPropertyComponent1() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            // Text(language.areYouA, style: primaryTextStyle()),
            // 10.height,
            // DropdownButtonFormField<String>(
            //     dropdownColor:
            //         appStore.isDarkModeOn ? cardDarkColor : selectIconColor,
            //     items: propertySellerType
            //         .map(
            //           (value) => DropdownMenuItem<String>(
            //             child: Text(value, style: primaryTextStyle()),
            //             value: value,
            //           ),
            //         )
            //         .toList(),
            //     isExpanded: false,
            //     isDense: true,
            //     borderRadius: radius(),
            //     decoration: defaultInputDecoration(context),
            //     value: sellerType == 0
            //         ? OWNER
            //         : sellerType == 1
            //             ? BROKER
            //             : sellerType == 2
            //                 ? BUILDER
            //                 : mUserType,
            //     onChanged: (String? value) {
            //       mUserType = value.validate();
            //       if (mUserType == OWNER) {
            //         sellerType = 0;
            //       } else if (mUserType == BROKER) {
            //         sellerType = 1;
            //       } else {
            //         sellerType = 2;
            //       }
            //       setState(() {});
            //       print("====" + sellerType.toString());
            //       print("====" + propertySellerType.toString());
            //     }),
            // 20.height,
            Text(language.selectCategory, style: primaryTextStyle()),
            20.height,
            AnimatedWrap(
              runSpacing: 16,
              spacing: 16,
              children: List.generate(
                categoryData.length,
                (i) {
                  return Container(
                    width: context.width() * 0.42,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: categoryData[i].id == selectedCategoryId
                          ? primaryColor
                          : appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        cachedImage(categoryData[i].categoryImage,
                                height: 30, width: 30, fit: BoxFit.fill)
                            .cornerRadiusWithClipRRect(8),
                        10.width,
                        Text(categoryData[i].name.toString(),
                                style: secondaryTextStyle(
                                    size: 16,
                                    color:
                                        categoryData[i].id == selectedCategoryId
                                            ? Colors.white
                                            : grayColor))
                            .expand(),
                      ],
                    ),
                  ).onTap(() {
                    selectedCategoryId = categoryData[i].id!;
                    // getFilterCategory(); // Add this line to call getFilterCategory
                    setState(() {});
                  });
                },
              ),
            )
          ],
        ).visible(!appStore.isLoading).paddingSymmetric(horizontal: 16)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Add property ',
        context1: context,
        titleSpace: 0,
        showBack: true,
        actions: [
          Text("${appStore.addPropertyIndex + 1}" "/" "2",
                  style: secondaryTextStyle())
              .paddingOnly(right: 30, top: 15),
        ],
        backWidget: Icon(Octicons.chevron_left, color: primaryColor, size: 28)
            .onTap(() {
          print(appStore.addPropertyIndex.toString());
          setState(() {
            if (appStore.addPropertyIndex == 0) {
              // finish(context);
              // finish(context);
              DashboardScreen().launch(context, isNewTask: true);
            } else {
              appStore.addPropertyIndex--;
            }
          });
        }),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(2, (i) {
                  return Container(
                    alignment: Alignment.center,
                    height: 3,
                    width: context.width() / 2.5,
                    decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appStore.addPropertyIndex >= i
                            ? primaryColor
                            : dividerColor),
                  );
                }).toList(),
              ).paddingSymmetric(horizontal: 12),
              ListView(
                children: [
                  if (appStore.addPropertyIndex == 0) addPropertyComponent1(),
                  if (appStore.addPropertyIndex == 1) addPropertyComponent2(),
                ],
              ).expand()
            ],
          ),
          Loader().center().visible(appStore.isLoading),
        ],
      ),
      bottomNavigationBar: AppButton(
        enabled: !appStore.isLoading,
        text: appStore.addPropertyIndex == 0
            ? language.Continue
            : language.submit,
        width: context.width(),
        color: primaryColor,
        textColor: Colors.white,
        onTap: () {
          try {
            if (appStore.addPropertyIndex == 0) {
              if (selectedCategoryId != null) {
                appStore.addPropertyIndex = 1;
                getProperty(selectedCategoryId);
              } else {
                toast(language.pleaseSelectCategory);
              }
            } else {
              if (mSecondComponentFormKey.currentState!.validate()) {
                if (mainImagePath == null) {
                  toast(language.pleaseSelectMainPicture);
                  return;
                }
                if (selectedProperty == null) {
                  toast('من فضلك اختر العقار');
                  return;
                }
                saveProperty();
              }
            }
            setState(() {});
          } catch (error) {
            print('errooooooooo$error');
          }
        },
      ).paddingOnly(right: 16, bottom: 30, left: 16, top: 0),
    );
  }

  Widget filterItem(PropertyResponseModel? model) {
    print('model!.toJson(): ${model?.toJson()}');
    return DropdownButtonFormField<Property>(
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: black),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: appStore.isDarkModeOn ? cardDarkColor : primaryExtraLight,
        hintText: 'اختر الوحدة',
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        // ),
      ),
      items: model?.data
          ?.map((option) => DropdownMenuItem<Property>(
                value: option,
                child: Text(option.name ?? ''),
              ))
          .toList(),
      onChanged: (value) {
        // Handle filter selection
        if (value != null) {
          setState(() {
            selectedProperty = value.id.toString();
          });
          print('Selected filter: ${value.id?.toString()}');
        }
      },
    );
  }

  Widget addPropertyComponent2() {
    return SingleChildScrollView(
      child: Form(
        key: mSecondComponentFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            RequiredValidationText(
                required: true, titleText: language.propertyName),
            10.height,
            AppTextField(
              controller: propertyNameController,
              focus: propertyNameFocus,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.go,
              decoration: defaultInputDecoration(context,
                  label: language.enterPropertyName),
            ),
            20.height,

            RequiredValidationText(
                required: true, titleText: language.description),
            10.height,
            AppTextField(
              isValidationRequired: true,
              textInputAction: TextInputAction.newline,
              controller: descriptionController,
              focus: descriptionFocus,
              textFieldType: TextFieldType.MULTILINE,
              keyboardType: TextInputType.multiline,
              decoration: defaultInputDecoration(context,
                  label: language.writeSomethingHere),
              minLines: 3,
              maxLines: 3,
            ),
            20.height,
            filterItem(preporty),
            20.height,
            RequiredValidationText(required: true, titleText: language.price),
            10.height,
            priceMeterFields(priceMeterList, context, setState: setState),
            // AppTextField(
            //   textInputAction: TextInputAction.go,
            //   controller: priceController,
            //   focus: priceFocus,
            //   textFieldType: TextFieldType.NUMBER,
            //   keyboardType: TextInputType.number,
            //   decoration: defaultInputDecoration(
            //     context,
            //     label: language.enterPrice,
            //   ),
            //   onChanged: (value) {
            //     onChangePriceField(value);
            //   },
            // ),

            // 20.height.visible(true),

            // AppTextField(
            //   readOnly: mapLocation.text.isEmpty ? true : false,
            //   isValidationRequired: true,
            //   textInputAction: TextInputAction.go,
            //   controller: cityController,
            //   focus: cityFocus,
            //   textFieldType: TextFieldType.NAME,
            //   keyboardType: TextInputType.streetAddress,
            //   decoration: defaultInputDecoration(context, label: language.city),
            //   onTap: () async {
            //     if (mapLocation.text.isEmpty) {
            //       toast(language.pleaseChooseAddressFromMap);
            //     }
            //   },
            // ),
            // 20.height,
            RequiredValidationText(
                required: false, titleText: language.addPicture),
            10.height,
            if (mainImagePath != null)
              Stack(
                children: [
                  mainImagePath!.contains('https')
                      ? cachedImage(
                          height: context.height() * 0.25,
                          fit: BoxFit.cover,
                          width: context.width(),
                          mainImagePath.validate(),
                        ).cornerRadiusWithClipRRect(8).center()
                      : Image.file(
                          height: context.height() * 0.25,
                          fit: BoxFit.cover,
                          width: context.width(),
                          File(mainImagePath.validate()),
                        ).cornerRadiusWithClipRRect(8).center(),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle),
                      child: Icon(Icons.close, color: Colors.red, size: 12)
                          .onTap(() {
                        mainImagePath = null;
                        setState(() {});
                      }),
                    ),
                  )
                ],
              ),
            if (mainImagePath.isEmptyOrNull) 10.height,
            if (mainImagePath.isEmptyOrNull)
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      dashPattern: [6, 3],
                      color: Colors.grey,
                    ),
                    child: Container(
                      height: 50,
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: appStore.isDarkModeOn
                              ? cardDarkColor
                              : primaryExtraLight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ic_gallery,
                              height: 24, width: 24, color: grayColor),
                          10.width,
                          Text(language.addMainPicture,
                              style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            20.height,
            // RequiredValidationText(
            //     required: false, titleText: language.addOtherPicture),
            // 10.height,
            // if (selectedImages.isNotEmpty)
            //   AnimatedWrap(
            //     itemCount: selectedImages.length,
            //     runSpacing: 16,
            //     spacing: 16,
            //     children: List.generate(selectedImages.length, (i) {
            //       return Stack(
            //         alignment: Alignment.topRight,
            //         children: [
            //           selectedImages[i].contains('https')
            //               ? cachedImage(selectedImages[i].toString(),
            //                       width: (context.width() - 64) / 3,
            //                       height: 100,
            //                       fit: BoxFit.cover)
            //                   .cornerRadiusWithClipRRect(8)
            //               : Image.file(
            //                       fit: BoxFit.fill,
            //                       width: (context.width() - 64) / 3,
            //                       height: 100,
            //                       File(selectedImages[i].toString()))
            //                   .cornerRadiusWithClipRRect(8),
            //           Positioned(
            //             top: 2,
            //             right: 2,
            //             child: Container(
            //               padding: EdgeInsets.all(4),
            //               decoration: boxDecorationWithRoundedCorners(
            //                   boxShape: BoxShape.circle),
            //               child: Icon(Icons.close, color: Colors.red, size: 12)
            //                   .onTap(() {
            //                 selectedImages.removeAt(i);
            //                 setState(() {});
            //               }),
            //             ),
            //           )
            //         ],
            //       );
            //     }),
            //   ).visible(selectedImages.isNotEmpty),
            // 10.height,
            // GestureDetector(
            //   onTap: () async {
            //     List<XFile> image = await ImagePicker().pickMultiImage();
            //     imageFileList!.addAll(image);
            //     imageFileList!.forEach((image) {
            //       selectedImages.add(image.path);
            //     });
            //     imageFileList!.clear();
            //     setState(() {});
            //   },
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: DottedBorder(
            //       options: RectDottedBorderOptions(
            //         dashPattern: [6, 3],
            //         color: Colors.grey,
            //       ),
            //       child: Container(
            //         height: 50,
            //         decoration: boxDecorationWithRoundedCorners(
            //             borderRadius: BorderRadius.circular(8),
            //             backgroundColor: appStore.isDarkModeOn
            //                 ? cardDarkColor
            //                 : primaryExtraLight),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(ic_gallery,
            //                 height: 24, width: 24, color: grayColor),
            //             10.width,
            //             Text(language.addOtherPictures,
            //                 style: secondaryTextStyle()),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            20.height,
          ],
        ).visible(!appStore.isLoading).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  void onChangePriceField(String value) {
    value = formNum(
      value.replaceAll(',', ''),
    );
    priceController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(
        offset: value.length,
      ),
    );
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future getImage() async {
    imageMain = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    mainImagePath = imageMain!.path;
    mainImage = await imageMain!.readAsBytes();
    mainImageName = imageMain!.name;

    setState(() {});
  }
}
