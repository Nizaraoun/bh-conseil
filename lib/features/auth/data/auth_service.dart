import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/snak_error.dart';
import '../domain/auth_controller.dart';

AthControllerImp controller = Get.put(AthControllerImp());

class AuthService {
  Future<void> singupapi(
    String name, String mail, String phoneNumber, bool isSing) async {
  final dio = Dio();
  final url = "https://taxiscooter.dam-j.co/api/signup";

  try {
    final response = await dio.post(
      url,
      data: {
        "first_name": name, // can be null
        "email": mail, // can be null
        "phone": phoneNumber, // required
      },
    );

    if (response.statusCode == 200) {
      controller.HaveAccount = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("nom", name);
      sharedPreferences.setString("mail", mail);
      sharedPreferences.setString("phone", phoneNumber);
      print(response.data);
    } else {
      showSnackError("Error", "this phone number Or Mail IS Used");
    }
  } catch (e) {
    // Handle errors here
    print('Error: $e');
    showSnackError('Internet', "Please Check Your Internet");
  }
}
Future<void> Singinapi(String phoneNumber) async {
  final dio = Dio();
  final url = "https://taxiscooter.dam-j.co/api/get_otp";

  try {
    final response = await dio.post(
      url,
      data: {
        "phone": phoneNumber, // required
      },
    );
    if (response.statusCode == 200) {
      controller.HaveAccount = true;
      print('*****************goood**************************');
    } else {
      print(response.statusCode);
      print('*****************bad**************************');
      showSnackError("Error", "Please Check Your Phone Number");
    }
  } catch (e) {
    showSnackError("Network Error", "Please Check Internet Connection");
  }
}


// otp verification
Future<void> loginWithOtp(String phoneNumber, String otp) async {
  final dio = Dio();
  final url = 'https://taxiscooter.dam-j.co/api/login';

  try {
    final response = await dio.post(
      url,
      data: {
        'otp': otp,
        'phone': phoneNumber,

        // Add any other required parameters
      },
    );
    if (response.statusCode == 200) {
      controller.isLogin = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("Status", "Login");
      print("login ************");
    } else {
      showSnackError('Error', "Please Check Code Otp");
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // Handle errors here
    Get.snackbar("Error", "Please Check Your Internet");
  }
}

  
}