// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/snak_error.dart';
import '../data/auth_service.dart';

abstract class Authcontroller extends GetxController {
  void singinwidget();
  void singupwidget();
  void back();
  login();
  Singup();
}

class AthControllerImp extends Authcontroller {
  GlobalKey<FormState> formstatelogin = GlobalKey<FormState>();
  GlobalKey<FormState> formstatesingup = GlobalKey<FormState>();
  GlobalKey<FormState> formstateotp = GlobalKey<FormState>();
  List<String> Inputlogin = [
    "",
  ];
  List<String> Inputotp = ["", "", "", "", ""];
  List<String> Inputsingup = ["", "", "", ""];
  bool welcome = true;
  double height = Get.height / 1.8;
  Color color = const Color.fromARGB(122, 0, 0, 0);
  bool isSignIn = true;
  bool HaveAccount = false;
  bool isLogin = false;

  //
  @override
  void singinwidget() {
    welcome = false;
    height = Get.height / 2;
    isSignIn = !isSignIn;
    update();
  }

  @override
  void singupwidget() {
    welcome = false;
    height = Get.height / 1.3;

    update();
  }


  @override
  void back() {
    welcome = true;
    height = Get.height / 1.35;
    isSignIn = !isSignIn;
    update();
  }

  @override
  login() async {
    var formdata = formstatelogin.currentState;
    if (formdata!.validate()) {
      Inputlogin.add(formdata.toString());
      await AuthService().Singinapi(Inputlogin[0]);
      if (HaveAccount) {
        update();
      }
      update();

      // Send SMS to my mobile and go to OTP page

      // loginWithOtp(Inputlogin[0]);
    }
    update();
  }

  @override
  Singup() async {
    var formdata = formstatesingup.currentState;
    if (formdata!.validate()) {
      Inputsingup.add(formdata.toString());
      await AuthService().singupapi(
          Inputsingup[0], Inputsingup[1], Inputsingup[2], HaveAccount);

      if (HaveAccount) {
        update();
      }
// Send SMS to my mobile and go to OTP page

      // loginWithOtp(Inputlogin[0]);
      update();
    }
    update();
  }

  

  getuserinfo(String name, String phone) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
      "nom",
      name,
    );
    sharedPreferences.setString(
      "phone",
      phone,
    );
  }
}
