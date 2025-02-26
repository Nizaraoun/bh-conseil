import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import 'package:my_bh/widgets/text/custom_text.dart';
import '../controller/exchangeController.dart';

class CurrencyListView extends GetView<ExchangeController> {
  final bool isFromCurrency;
  final Map<String, dynamic> conversionRates;

  const CurrencyListView({
    Key? key,
    required this.isFromCurrency,
    required this.conversionRates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        title: CustomText(
          txt: 'Select Currency',
          color: ColorManager.white,
          fontweight: FontWeight.w500,
          size: 20,
          spacing: 0.0,
          fontfamily: 'Tajawal',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorManager.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: ColorManager.primaryColor.withOpacity(0.1),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search currency',
                prefixIcon: Icon(Icons.search, color: ColorManager.primaryColor),
                filled: true,
                fillColor: ColorManager.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorManager.primaryColor),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
                // This would filter the list based on search input
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: conversionRates.length,
              itemBuilder: (context, index) {
                final currencyCode = conversionRates.keys.toList()[index];
                final rate = conversionRates[currencyCode];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ColorManager.primaryColor.withOpacity(0.2),
                    child: Text(
                      currencyCode.substring(0, 1),
                      style: TextStyle(
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    currencyCode,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '1 TND = ${rate.toString()} $currencyCode',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  trailing: Obx(() {
                    final selectedCurrency = isFromCurrency
                        ? controller.fromCurrency.value
                        : controller.toCurrency.value;
                    return selectedCurrency == currencyCode
                        ? Icon(
                            Icons.check_circle,
                            color: ColorManager.primaryColor,
                          )
                        : SizedBox();
                  }),
                  onTap: () {
                    if (isFromCurrency) {
                      controller.fromCurrency.value = currencyCode;
                    } else {
                      controller.toCurrency.value = currencyCode;
                    }
                    controller.fetchExchangeRate();
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}