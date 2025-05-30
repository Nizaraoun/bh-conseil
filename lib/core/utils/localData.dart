import 'package:shared_preferences/shared_preferences.dart';

  class LocalData {
  static Future<void> saveCardData({
    required String userName,
    required String bankName,
    required String cardBalance,
    required String cardCurrency,
    required String cardNumber,
    required String cardType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('bankName', bankName);
    await prefs.setString('cardBalance', cardBalance);
    await prefs.setString('cardCurrency', cardCurrency);
    await prefs.setString('cardNumber', cardNumber);
    await prefs.setString('cardType', cardType);
  }

  static Future<Map<String, String>> getCardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userName': prefs.getString('userName') ?? 'User',
      'bankName': prefs.getString('bankName') ?? 'BH Bank',
      'cardBalance': prefs.getString('cardBalance') ?? '0.0',
      'cardCurrency': prefs.getString('cardCurrency') ?? 'TND',
      'cardNumber': prefs.getString('cardNumber') ?? '5555 5555 5555 5555',
      'cardType': prefs.getString('cardType') ?? 'VISA',
    };
  }

  static Future<String?> getCardDataByName(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
   static Future<bool> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
