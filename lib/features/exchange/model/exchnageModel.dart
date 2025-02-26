class CurrencyExchangeModel {
  String fromCurrency;
  String toCurrency;
  double amount;
  double? rate;
  Map<String, dynamic>? rates;
  
  CurrencyExchangeModel({
    this.fromCurrency = 'USD',
    this.toCurrency = 'KRW',
    this.amount = 0.0,
    this.rate,
    this.rates,
  });

  double? get convertedAmount => amount * (rate ?? 0.0);
}
