import 'package:get/get.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import '../service/exchangeService.dart';
import '../widget/currencyListView.dart';

class ExchangeController extends GetxController {
  final fromAmount = ''.obs;
  final toAmount = ''.obs;
  final fromCurrency = 'TND'.obs;
  final toCurrency = 'USD'.obs;
  final currentRate = 0.0.obs;
  final isLoading = false.obs;
  final availableCurrencies = <String, dynamic>{}.obs;

  final ExchangeService _exchangeService = ExchangeService();

  void updateFromAmount(String value) {
    fromAmount.value = value;
    print('Updated fromAmount: $value');
    calculateExchange();
  }

  void calculateExchange() {
    try {
      if (fromAmount.value.isNotEmpty) {
        double amount = double.tryParse(fromAmount.value) ?? 0;
        toAmount.value = (amount * currentRate.value).toStringAsFixed(2);
        print('Calculated toAmount: ${toAmount.value}');
      } else {
        toAmount.value = '';
      }
    } catch (e) {
      print('Error calculating exchange: $e');
      toAmount.value = '0.00';
    }
  }

  Future<void> fetchExchangeRate() async {
    isLoading.value = true;
    print('Fetching exchange rate...');
    try {
      // Get the current rate for conversion
      currentRate.value = await _exchangeService.fetchExchangeRate(
          fromCurrency.value, toCurrency.value);
      print('Fetched exchange rate: ${currentRate.value}');

      // Recalculate when rate changes
      if (fromAmount.value.isNotEmpty) {
        calculateExchange();
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
      currentRate.value = 0.0;
    } finally {
      isLoading.value = false;
      print('Finished fetching exchange rate');
    }
  }

  Future<void> fetchAllCurrencies() async {
    isLoading.value = true;
    print('Fetching all currencies...');
    try {
      final response =
          await _exchangeService.fetchAllCurrencyRates(fromCurrency.value);
      availableCurrencies.value = response['conversion_rates'] ?? {};
      print('Fetched ${availableCurrencies.length} currencies');
    } catch (e) {
      print('Error fetching currencies: $e');
    } finally {
      isLoading.value = false;
      print('Finished fetching all currencies');
    }
  }

  void swapCurrencies() {
    final temp = fromCurrency.value;
    fromCurrency.value = toCurrency.value;
    toCurrency.value = temp;
    print(
        'Swapped currencies: from ${fromCurrency.value} to ${toCurrency.value}');
    fetchExchangeRate();
    calculateExchange();
  }

  void showCurrencySelector(bool isFromCurrency) {
    if (availableCurrencies.isEmpty) {
      Get.snackbar(
        'Loading Currencies',
        'Please wait while we fetch the latest currency data',
        backgroundColor: ColorManager.amber,
        colorText: ColorManager.black,
      );
      return;
    }

    Get.to(() => CurrencyListView(
          isFromCurrency: isFromCurrency,
          conversionRates: availableCurrencies,
        ));
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllCurrencies();
    fetchExchangeRate();
  }
}
