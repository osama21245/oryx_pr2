import 'package:flutter/material.dart';
import 'package:orex/models/dashBoard_response.dart';

class CustomAreaPricesTable extends StatelessWidget {
  final List<AreaPrice> areaPrices;
  final void Function(AreaPrice)? onRowTap;

  const CustomAreaPricesTable({
    Key? key,
    required this.areaPrices,
    this.onRowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (areaPrices.isEmpty) {
      return const Text('No Area Prices Available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table headers
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.grey.shade300,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child:
                    Text('Area', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              // VerticalDivider(
              //   width: 1,
              //   color: Colors.black,
              // ),
              Expanded(
                flex: 1,
                child: Text('Price',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child:
                    Text('type', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Table rows
        ...areaPrices.map((item) {
          return InkWell(
            onTap: () => onRowTap?.call(item),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('${item.area} M',
                        style: const TextStyle(fontSize: 14)),
                  ),
                  // Container(
                  //   width: 1,
                  //   height: 20,
                  //   color: Colors.black, // Vertical line color
                  //   margin: const EdgeInsets.symmetric(horizontal: 8),
                  // ),
                  Expanded(
                    flex: 1,
                    child: Text('${item.price ?? 0}',
                        style: const TextStyle(fontSize: 14)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${item.type ?? ''}',
                        style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
