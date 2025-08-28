import 'package:flutter/material.dart';
import 'package:orex/components/transaction_type_card.dart';
import 'package:orex/extensions/extension_util/context_extensions.dart';
import 'package:orex/models/gif_model.dart';
import 'package:orex/utils/images.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/home_screen.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:orex/components/transaction_type_card.dart';
import 'package:orex/extensions/colors.dart';
import 'package:orex/extensions/extension_util/widget_extensions.dart';
import 'package:orex/screens/dashboard_screen.dart';
import 'package:orex/screens/home_screen.dart';
import 'package:orex/utils/images.dart';
import '../components/app_bar_components.dart';
import '../extensions/loader_widget.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../network/RestApis.dart';
import '../utils/app_config.dart';
import 'no_data_screen.dart';

class ChooseTransactionTypeDropdown extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int?>? onChanged;
  const ChooseTransactionTypeDropdown(
      {Key? key, this.initialValue, this.onChanged})
      : super(key: key);

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
  ];

  @override
  void initState() {
    super.initState();
    selectedTransactionTypeId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<int>(
        value: selectedTransactionTypeId,
        decoration: InputDecoration(
          labelText: 'اختار نوع المعاملة',
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
  const ChooseTransactionTypeScreen({Key? key}) : super(key: key);

  @override
  State<ChooseTransactionTypeScreen> createState() =>
      _ChooseTransactionTypeScreenState();
}

class _ChooseTransactionTypeScreenState
    extends State<ChooseTransactionTypeScreen> {
  // List<TransactionType> transactionTypes = [];
  int? selectedTransactionTypeId;
  bool isSale = false, isRent = false;
  late String gifUrl;
  iWantToSale() {
    setState(() {
      isRent = false;
      isSale = true;
    });
  }

  iWantToRent() {
    setState(() {
      isSale = false;
      isRent = true;
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
    var size = MediaQuery.of(context).size;
    print('dataaaaaaaaa:${data!.slider!.length}');
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            ic_logo,
            height: 40,
            width:
                40, /* color: appStore.isDarkModeOn ? Colors.white : primaryColor, fit: BoxFit.fill */
          ).paddingOnly(left: 16, top: 8, bottom: 8),
          title: Text("اختار نوع المعاملة"),
          centerTitle: true,
        ),
        // body: appStore.isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(
        //           color: context.primaryColor,
        //         ),
        //       )
        //     : SingleChildScrollView(
        //         child: Padding(
        //           padding: const EdgeInsets.all(24.0),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               TransactionTypeCard(
        //                 isSelected: false,
        //                 imagePath: gifUrl,
        //                 padding: 0,
        //                 // type: '',
        //                 isGif: true,
        //               ),
        //               const SizedBox(
        //                 height: 24,
        //               ),
        //               GestureDetector(
        //                 onTap: () {
        //                   iWantToSale();
        //                   selectedTransactionTypeId =
        //                       1; // Assuming 1 is the ID for Sale
        //                   DashboardScreen(
        //                     transactionType: selectedTransactionTypeId,
        //                     isSplash: false,
        //                   ).launch(context, isNewTask: false);
        //                 },
        //                 child: TransactionTypeCard(
        //                     // height: size.height * .2,
        //                     isSelected: isSale,
        //                     imagePath: ic_sale,
        //                     type: 'بيع'),
        //               ),
        //               const SizedBox(
        //                 height: 24,
        //               ),
        //               GestureDetector(
        //                 onTap: () {
        //                   iWantToRent();
        //                   selectedTransactionTypeId =
        //                       0; // Assuming 0 is the ID for Rent
        //                   DashboardScreen(
        //                     transactionType: selectedTransactionTypeId,
        //                     isSplash: false,
        //                   ).launch(context, isNewTask: true);
        //                 },
        //                 child: TransactionTypeCard(
        //                     isSelected: isRent,
        //                     imagePath: ic_rent,
        //                     type: 'ايجار'),
        //               ),
        //               const SizedBox(
        //                 height: 24,
        //               ),
        //               Container(
        //                 width: size.width * 0.9,
        //                 padding: EdgeInsets.symmetric(vertical: 16),
        //                 decoration: BoxDecoration(
        //                     color: Theme.of(context)
        //                         .disabledColor
        //                         .withOpacity(0.1),
        //                     borderRadius: BorderRadius.circular(23)),
        //                 child: Text(
        //                   "مساحة اعلانية",
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.w700,
        //                     fontSize: 24,
        //                     fontFamily: 'Cairo',
        //                     color: appStore.isDarkModeOn
        //                         ? textOnDarkMode
        //                         : textOnLightMode,
        //                   ),
        //                 ).paddingOnly(top: 16, bottom: 16),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: ElevatedButton(
        //     onPressed: selectedTransactionTypeId != null
        //         ? () {
        //             // Navigate to the next screen with the selected transaction type
        //             log("Selected Transaction Type ID: $selectedTransactionTypeId");
        //           }
        //         : null,
        //     child: Text("Continue"),
        //     style: ElevatedButton.styleFrom(
        //       // primary: Theme.of(context).primaryColor,
        //       // onPrimary: Theme.of(context).cardColor,
        //       padding: EdgeInsets.symmetric(vertical: 16),
        //       textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        body: appStore.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: context.primaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // وسط الشاشة
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TransactionTypeCard(
                      isSelected: false,
                      imagePath: gifUrl,
                      padding: 0,
                      isGif: true,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        iWantToSale();
                        selectedTransactionTypeId = 1;
                        DashboardScreen(
                          transactionType: selectedTransactionTypeId,
                          isSplash: false,
                        ).launch(context, isNewTask: false);
                      },
                      child: TransactionTypeCard(
                        isSelected: isSale,
                        imagePath: ic_sale,
                        type: 'بيع',
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        iWantToRent();
                        selectedTransactionTypeId = 0;
                        DashboardScreen(
                          transactionType: selectedTransactionTypeId,
                          isSplash: false,
                        ).launch(context, isNewTask: true);
                      },
                      child: TransactionTypeCard(
                        isSelected: isRent,
                        imagePath: ic_rent,
                        type: 'ايجار',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Text(
                        "مساحة اعلانية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          fontFamily: 'Cairo',
                          color: appStore.isDarkModeOn
                              ? textOnDarkMode
                              : textOnLightMode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
