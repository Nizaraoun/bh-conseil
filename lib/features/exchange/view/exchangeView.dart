import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import 'package:my_bh/widgets/CustomElevatedButton.dart';
import 'package:my_bh/widgets/customIcon.dart';
import 'package:my_bh/widgets/input/custom_input.dart';
import 'package:my_bh/widgets/text/custom_text.dart';

import '../controller/exchangeController.dart';

class ExchangeView extends GetView<ExchangeController> {
  const ExchangeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(ExchangeController());

    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: true,
            pinned: true,
            backgroundColor: ColorManager.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Get.back(),
                color: ColorManager.white,
                size: 30,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: CustomText(
                txt: 'Exchange Currency',
                color: ColorManager.white,
                fontweight: FontWeight.w500,
                size: 20,
                spacing: 0.0,
                fontfamily: 'Tajawal',
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/transfer.svg',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: Get.height / 1.08,
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildExchangeSection(controller),
                    Gap(24),
                    _buildRateSection(controller),
                    Gap(32),
                    customElevatedButton(
                      onPressed: controller.swapCurrencies,
                      text: 'Exchange Now',
                      color: ColorManager.primaryColor,
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: ColorManager.whitePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      width: Get.width * 0.5,
                      height: Get.height * 0.08,
                      borderRadius: 20,
                    ),
                    Gap(24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeSection(ExchangeController controller) {
    final fromAmountController = TextEditingController();
    final toAmountController = TextEditingController();

    return Card(
      elevation: 5,
      color: ColorManager.whitePrimary,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              txt: 'Currency Exchange',
              color: ColorManager.SoftBlack,
              fontweight: FontWeight.w500,
              size: 20,
              spacing: 0.0,
              fontfamily: 'Tajawal',
            ),
            Gap(16),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Obx(() {
                    fromAmountController.text = controller.fromAmount.value;
                    return CustomTextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      height: 60,
                      icon: Icon(Icons.attach_money),
                      inputType: TextInputType.number,
                      texthint: 'Amount',
                      formOnChanged: (value) {
                        controller.updateFromAmount(value);
                      },
                      formcontroller: fromAmountController,
                      color: ColorManager.white,
                    );
                  }),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => controller.showCurrencySelector(true),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.fromCurrency.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.swap_vert,
                      color: ColorManager.primaryColor, size: 30),
                  onPressed: controller.swapCurrencies,
                ),
              ],
            ),
            Gap(20),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Obx(() {
                    toAmountController.text = controller.toAmount.value;
                    return CustomTextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      height: 60,
                      icon: Icon(Icons.currency_exchange),
                      inputType: TextInputType.number,
                      texthint: 'Converted amount',
                      enabled: false,
                      formcontroller: toAmountController,
                      color: ColorManager.white,
                    );
                  }),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => controller.showCurrencySelector(false),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.toCurrency.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateSection(ExchangeController controller) {
    return Card(
      elevation: 5,
      color: ColorManager.whitePrimary,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              txt: 'Current Rate',
              color: ColorManager.SoftBlack,
              fontweight: FontWeight.w500,
              size: 20,
              spacing: 0.0,
              fontfamily: 'Tajawal',
            ),
            Gap(16),
            Center(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  );
                }
                return CustomText(
                  txt:
                      '1 ${controller.fromCurrency.value} = ${controller.currentRate.value} ${controller.toCurrency.value}',
                  color: ColorManager.primaryColor,
                  fontweight: FontWeight.w500,
                  size: 18,
                  spacing: 0.0,
                  fontfamily: 'Tajawal',
                );
              }),
            ),
            Gap(16),
            Obx(() => controller.availableCurrencies.isEmpty
                ? Center(
                    child: Text(
                      "Loading all currencies...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Center(
                    child: Text(
                      "${controller.availableCurrencies.length} currencies available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
