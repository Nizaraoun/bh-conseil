import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/themes/color_mangers.dart';
import '../../../firebase_options.dart';
import '../../../widgets/icons/custom_button.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async{

      
      // Only after initialization is complete, perform Firestore operations
      try {
        await addUserData();
        await addTransactions();
        _showAlertDialog(Get.context!);
      } catch (e) {
        print("Error performing Firestore operations: $e");
      }
    });
  }

  }

  Future<void> addUserData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc('nizar_aoun').set({
      'name': 'Nizar Aoun',
      'email': 'nizar.aoun@example.com',
      'phone': '+216 50 123 456',
      'gender': 'Male',
      'maritalStatus': 'Single',
      'profession': 'Full Stack Developer',
      'industry': 'Software Development',
      'vehicleOwner': true,
    });

    print("User data added successfully!");
  }

  Future<void> addTransactions() async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');
    print("Transactions added successfully!");

    List<Map<String, dynamic>> fakeTransactions = [
      {
        'transactionId': 'txn_001',
        'userId': 'nizar_aoun',
        'date': DateTime(2025, 2, 1, 12, 0, 0).toUtc(),
        'amount': -120.00,
        'type': 'expense',
        'category': 'Food',
        'subCategory': 'Groceries',
        'beneficiary': 'Carrefour',
        'justification': 'https://example.com/receipt1',
        'description': 'Weekly grocery shopping'
      },
      {
        'transactionId': 'txn_002',
        'userId': 'nizar_aoun',
        'date': DateTime(2025, 2, 5, 18, 30, 0).toUtc(),
        'amount': -75.00,
        'type': 'expense',
        'category': 'Water & Utilities',
        'subCategory': 'Electricity Bill',
        'beneficiary': 'STEG',
        'justification': 'https://example.com/bill',
        'description': 'February electricity bill'
      }

      
    ];

    for (var txn in fakeTransactions) {
      await transactions.doc(txn['transactionId']).set(txn);
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: ColorManager.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: const AssetImage('assets/images/car_notif.jpg'),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CustomIconButton(
                    padding: EdgeInsets.all(Get.width / 35),
                    icon: const Icon(FontAwesomeIcons.xmark),
                    onPressed: () {
                      Get.back();
                    },
                    color: ColorManager.black,
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(7),
                      shadowColor: WidgetStateProperty.all(ColorManager.black),
                      backgroundColor:
                          WidgetStateProperty.all(ColorManager.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    tooltip: 'Fermé',
                    iconSize: Get.width / 20,
                    alignment: Alignment.centerLeft,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    autofocus: true,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  
}
