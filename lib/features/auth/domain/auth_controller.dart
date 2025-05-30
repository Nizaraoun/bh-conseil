// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bh/routes/app_routing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bh/core/utils/localData.dart';

abstract class Authcontroller extends GetxController {
  void singinwidget();
  void singupwidget();
  void back();
  loginUser(
    String email,
    String password,
  );
  registerUser(
    String email,
    String password,
    String fullName,
  );
}

class AthControllerImp extends Authcontroller {
  GlobalKey<FormState> formstatelogin = GlobalKey<FormState>();
  GlobalKey<FormState> formstatesingup = GlobalKey<FormState>();
  GlobalKey<FormState> formstateotp = GlobalKey<FormState>();
  List<String> Inputlogin = [
    "",
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
  Future<String?> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please fill in all fields.";
    }
    else if (email=="bh@admin.com" || password=="bhadmin123") {
      AppRoutes().goToEnd(
        AppRoutes.homeadmine,
      );
    }
    else 
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the user ID to local storage
      String? userId = userCredential.user?.uid;
      if (userId != null) {
        print("User ID: $userId");
        await LocalData.saveUserId(userId);
      }

      AppRoutes().goToEnd(
        AppRoutes.homepage,
      );

      return "Login successful! Welcome ${userCredential.user!.email}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found with this email.");
        return "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        print("Incorrect password.");
        return "Incorrect password.";
      }
      print("Login failed: ${e.message}");
      return "Login failed: ${e.message}";
    } catch (e) {
      print("errrrrrrrr");
      return "Error: $e";
    }
  }

  @override
  Future<String?> registerUser(
      String email, String password, String fullName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "fullName": fullName,
        "email": email,
        "createdAt": DateTime.now(),
      });

      return "User registered successfully!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return "The email is already in use.";
      }
      return "Registration failed: ${e.message}";
    } catch (e) {
      return "Error: $e";
    }
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
