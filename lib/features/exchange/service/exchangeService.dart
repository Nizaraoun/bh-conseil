import 'package:http/http.dart' as http;
import 'dart:convert';

class ExchangeService {
  static const String apiKey = 'f77642c6661ee96685076ecf';
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';

  Future<double> fetchExchangeRate(
      String fromCurrency, String toCurrency) async {
    try {
      final ratesData = await fetchAllCurrencyRates(fromCurrency);
      if (ratesData['result'] == 'success') {
        return ratesData['conversion_rates'][toCurrency] ?? 0.0;
      } else {
        throw Exception(
            'Failed to fetch exchange rate: ${ratesData['error-type']}');
      }
    } catch (e) {
      print('Error in fetchExchangeRate: $e');
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> fetchAllCurrencyRates(
      String baseCurrency) async {
    final url = '$baseUrl/$apiKey/latest/$baseCurrency';
    try {
      final response = await http.get(Uri.parse(url));
      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all rates: $e');
      return {
        'result': 'error',
        'error-type': e.toString(),
        'conversion_rates': {}
      };
    }
  }
}
