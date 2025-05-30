import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/themes/color_mangers.dart';
import '../../../firebase_options.dart';
import '../../../widgets/icons/custom_button.dart';
import '../../../core/utils/localData.dart';

class HomeController extends GetxController {
  // Loading state
  final RxBool isLoading = true.obs;

  // User data
  final RxString userName = "User".obs;

  // Card data
  final RxString bankName = "".obs;
  final RxString cardBalance = "".obs;
  final RxString cardCurrency = "TND".obs;
  final RxString cardNumber = "".obs;
  final RxString cardType = "".obs;

  // Recent activity
  final RxList<Map<String, dynamic>> recentActivities =
      <Map<String, dynamic>>[].obs;

  // Monthly trends
  final RxMap<String, Map<String, dynamic>> monthlyTrends =
      <String, Map<String, dynamic>>{}.obs;

  // Expense breakdown
  final RxMap<String, dynamic> expenseBreakdown = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await loadDashboardData();
        // After data is loaded, show the dialog
      } catch (e) {
        print("Error performing Firestore operations: $e");
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    Map<String, dynamic>? dashboardData = await getDashboardData();

    if (dashboardData != null) {
      // Set user data
      userName.value = dashboardData['userName'] ?? "User";

      // Set card data
      Map<String, dynamic> card = dashboardData['card'] ?? {};
      bankName.value = card['bankName'] ?? "BH Bank";
      cardBalance.value = (card['balance']) ?? "0.0";
      cardCurrency.value = card['currency'] ?? "TND";
      cardNumber.value = card['cardNumber'] ?? "5555 5555 5555 5555";
      cardType.value = card['cardType'] ?? "VISA";

      // Save card data to local storage
      await LocalData.saveCardData(
        userName: userName.value,
        bankName: bankName.value,
        cardBalance: cardBalance.value,
        cardCurrency: cardCurrency.value,
        cardNumber: cardNumber.value,
        cardType: cardType.value,
      );

      // Set recent activities
      List<dynamic> rawActivities = dashboardData['recentActivity'] ?? [];
      recentActivities.clear();

// Format dates properly for the transaction controller
      for (var activity in rawActivities) {
        Map<String, dynamic> formattedActivity =
            Map<String, dynamic>.from(activity);

        if (formattedActivity.containsKey('date') &&
            formattedActivity['date'] is String) {
          // Parse the string date and format it as needed
          try {
            // If your date is stored in ISO format
            DateTime dateTime = DateTime.parse(formattedActivity['date']);

            // Format it to your desired format
            formattedActivity['date'] =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

            // Alternatively, you could keep it as a DateTime object if that's more useful
            // formattedActivity['date'] = dateTime;
          } catch (e) {
            // Handle parsing errors
            print(
                'Error parsing date: ${formattedActivity['date']}, Error: $e');
            // Keep the original string or set a default
            // formattedActivity['date'] = 'Invalid date';
          }
        }

        // Make sure amount is a number if it exists
        if (formattedActivity.containsKey('amount') &&
            formattedActivity['amount'] is String) {
          try {
            formattedActivity['amount'] =
                double.parse(formattedActivity['amount']);
          } catch (e) {
            print(
                'Error parsing amount: ${formattedActivity['amount']}, Error: $e');
          }
        }

        recentActivities.add(formattedActivity);
      }

      // Set monthly trends
      Map<String, dynamic> rawTrends = dashboardData['monthlyTrends'] ?? {};
      monthlyTrends.clear();
      rawTrends.forEach((key, value) {
        monthlyTrends[key] = Map<String, dynamic>.from(value);
      });

      // Set expense breakdown
      expenseBreakdown.value =
          Map<String, dynamic>.from(dashboardData['expenseBreakdown'] ?? {});

      print("Dashboard data loaded successfully!");
    } else {
      print("No dashboard data available!");
    }

    isLoading.value = false;
  }

  Future<Map<String, dynamic>?> getDashboardData() async {
    try {
      // Get the userId from SharedPreferences
      String? userId = await getUserId();

      // If userId is null or empty, return null
      if (userId == null || userId.isEmpty) {
        print("User ID not found in SharedPreferences!");
        return null;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Use the userId to fetch the document
      DocumentSnapshot document =
          await firestore.collection('dashboard').doc(userId).get();

      if (document.exists) {
        print("Dashboard data retrieved successfully for user: $userId");
        // Return the data as a Map
        return document.data() as Map<String, dynamic>;
      } else {
        print("Dashboard document does not exist for user: $userId");
        return null;
      }
    } catch (e) {
      print("Error retrieving dashboard data: $e");
      return null;
    }
  }

// Keep this function unchanged
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}

