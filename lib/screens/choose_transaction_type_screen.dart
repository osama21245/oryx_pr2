import 'package:flutter/material.dart';
import 'package:orex/components/transaction_type_card.dart';
import 'package:orex/components/slider_components.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/models/gif_model.dart';
import 'package:orex/models/dashBoard_response.dart';
import 'package:orex/utils/images.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/home_screen.dart';
import 'package:orex/screens/search_screen.dart';
import '../components/meta_banner.dart';
import '../components/oryx_ai.dart';
import '../main.dart';
import '../extensions/system_utils.dart';
import '../network/RestApis.dart';
import '../utils/colors.dart';
import '../extensions/text_styles.dart';
import '../extensions/shared_pref.dart';
import '../utils/constants.dart';
import '../extensions/extension_util/int_extensions.dart';

class ChooseTransactionTypeDropdown extends StatefulWidget {
  // final int? initialValue;
  final ValueChanged<int?>? onChanged;

  const ChooseTransactionTypeDropdown({super.key, this.onChanged});

  @override
  State<ChooseTransactionTypeDropdown> createState() =>
      _ChooseTransactionTypeDropdownState();
}

class _ChooseTransactionTypeDropdownState
    extends State<ChooseTransactionTypeDropdown> {
  int? selectedTransactionTypeId;
  final List<_TransactionType> transactionTypes = const [
    _TransactionType(id: 1, label: 'بيع', imagePath: ic_sale),
    _TransactionType(id: 0, label: 'ايجار', imagePath: ic_rent),
    _TransactionType(id: 3, label: 'مطلوب', imagePath: ic_wanted),
  ];

  @override
  void initState() {
    super.initState();
    // selectedTransactionTypeId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<int>(
        value: selectedTransactionTypeId,
        decoration: InputDecoration(
          labelText: language.transactionType,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: transactionTypes.map((type) {
          return DropdownMenuItem<int>(
            value: type.id,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    type.imagePath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    type.label,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: appStore.isDarkModeOn
                            ? textOnDarkMode
                            : textOnLightMode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedTransactionTypeId = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }

          // DashboardScreen(
          //   transactionType: selectedTransactionTypeId,
          //   isSplash: false,
          // ).launch(context, isNewTask: false);
        },
      ),
    );
  }
}

class _TransactionType {
  final int id;
  final String label;
  final String imagePath;

  const _TransactionType(
      {required this.id, required this.label, required this.imagePath});
}

// make easy backup code 😊

class ChooseTransactionTypeScreen extends StatefulWidget {
  const ChooseTransactionTypeScreen({super.key});

  @override
  State<ChooseTransactionTypeScreen> createState() =>
      _ChooseTransactionTypeScreenState();
}

class _ChooseTransactionTypeScreenState
    extends State<ChooseTransactionTypeScreen> {
  // List<TransactionType> transactionTypes = [];
  int? selectedTransactionTypeId;
  bool isSale = false, isRent = false, isWanted = false;
  late String gifUrl;

  iWantToSale() {
    setState(() {
      isRent = false;
      isWanted = false;
      isSale = true;
    });
  }

  iWantToRent() {
    setState(() {
      isSale = false;
      isWanted = false;
      isRent = true;
    });
  }

  iWantToWanted() {
    setState(() {
      isSale = false;
      isRent = false;
      isWanted = true;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    // fetchTransactionTypes();
  }

  void init() async {
    await fetchGif();
    if (data == null) {
      await fetchDashboardData();
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      appStore.setLoading(true);
      await getDashBoardData({
        "latitude": userStore.latitude,
        "longitude": userStore.longitude,
        "city": userStore.cityName,
        "player_id": getStringAsync(PLAYER_ID)
      }).then((value) {
        data = value;
        setState(() {});
      }).catchError((e) {
        log('Error fetching dashboard data: $e');
      }).whenComplete(() {
        appStore.setLoading(false);
      });
    } catch (e) {
      appStore.setLoading(false);
      log('Error in fetchDashboardData: $e');
    }
  }

  Future<void> fetchGif() async {
    try {
      appStore.setLoading(true);
      GifResponse gifResponse = await getGIFApi();
      gifUrl = gifResponse.url ?? '';
      setState(() {
        appStore.setLoading(false);
      });
    } catch (e) {
      appStore.setLoading(false);
      log('Error fetching GIF: $e');
    }
  }

  // Future<void> fetchTransactionTypes() async {
  //   appStore.setLoading(true);
  //   await getTransactionTypesApi().then((value) {
  //     transactionTypes = value;
  //     appStore.setLoading(false);
  //     setState(() {});
  //   }).catchError((error) {
  //     appStore.setLoading(false);
  //     log(error);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<MSlider>? filteredSliders = data?.slider;
    // Filter sliders based on selected transaction type
    // List<MSlider>? filteredSliders;
    // if (selectedTransactionTypeId != null &&
    //     data != null &&
    //     data!.slider != null &&
    //     data!.property != null) {
    //   filteredSliders = data!.slider!.where((slider) {
    //     // Find the property matching the slider's propertyId
    //     Property? property = data!.property!.firstWhere(
    //       (prop) => prop.id == slider.propertyId,
    //       orElse: () => Property(
    //           id: -1,
    //           name: '',
    //           categoryId: 0,
    //           category: '',
    //           categoryImage: '',
    //           price: 0,
    //           priceFormat: '',
    //           address: '',
    //           status: 0,
    //           premiumProperty: 0,
    //           propertyImage: '',
    //           isFavourite: 0,
    //           propertyTypeId: 0,
    //           propertyType: '',
    //           propertyFor: -1,
    //           advertisementProperty: 0,
    //           advertisementPropertyDate: ''), // Return empty if not found
    //     );
    //     // Check if propertyFor matches selectedTransactionTypeId
    //     return property.propertyFor == selectedTransactionTypeId;
    //   }).toList();
    // }

    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Image.asset(
              ic_logo,
              height: 40,
              width: 40,
            ).paddingOnly(left: 16, top: 8, bottom: 8),
          ),
          title: Text(language.transactionType),
          centerTitle: true,
        ),
        body: appStore.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: context.primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (selectedTransactionTypeId != null)
                      const SizedBox(height: 20),
                    if (filteredSliders != null && filteredSliders.isNotEmpty)
                      SlidesComponents(data: filteredSliders),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              iWantToSale();
                              selectedTransactionTypeId = 1;
                              // userStore.setTransactionType(1);

                              DashboardScreen(
                                transactionType: selectedTransactionTypeId,
                                isSplash: false,
                              ).launch(context, isNewTask: false);
                            },
                            child: TransactionTypeCard(
                              isSelected: isSale,
                              imagePath: ic_sale,
                              type: language.sell,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              iWantToRent();
                              selectedTransactionTypeId = 0;
                              // userStore.setTransactionType(0);

                              DashboardScreen(
                                transactionType: selectedTransactionTypeId,
                                isSplash: false,
                              ).launch(context, isNewTask: true);
                            },
                            child: TransactionTypeCard(
                              isSelected: isRent,
                              imagePath: ic_rent,
                              type: language.rent,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              iWantToWanted();
                              selectedTransactionTypeId = 3;
                              // userStore.setTransactionType(3);

                              DashboardScreen(
                                transactionType: selectedTransactionTypeId,
                                isSplash: false,
                              ).launch(context, isNewTask: false);
                            },
                            child: TransactionTypeCard(
                              isSelected: isWanted,
                              imagePath: ic_wanted,
                              type: language.wantedProperty,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20,top: 0,right: 20,left: 20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 130,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill  ,
                              image: AssetImage(
                            city_view,
                          )),
                          color: Theme.of(context).disabledColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: MetaBanner(),
                        //TODO: check here,
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: OryxAIFloatingButton(),
      );
    });
  }

  Widget _buildOryxAIFloatingButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 16),
      child: FloatingActionButton.extended(
        onPressed: () {
          SearchScreen(
            isBack: true,
            openVoiceDialog: true,
          ).launch(context);
        },
        backgroundColor: primaryColor,
        elevation: 8,
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(6),
          child: Image.asset(
            app_logo,
            fit: BoxFit.contain,
          ),
        ),
        label: Text(
          appStore.selectedLanguage == 'ar' ? 'Oryx AI' : 'Oryx AI',
          style: boldTextStyle(color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
