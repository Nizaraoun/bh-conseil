import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import 'TransactionForm.dart';

class TransactionController extends GetxController {
  var selectedCategory = Rx<String?>(null);
  final transactions = [
    {
      'title': 'Courses au supermarché',
      'amount': -120.50,
      'date': '24 Fév 2025',
      'category': 'Épicerie'
    },
    {
      'title': 'Dépôt de salaire',
      'amount': 3500.00,
      'date': '20 Fév 2025',
      'category': 'Salaire'
    },
    {
      'title': 'Abonnement Netflix',
      'amount': -14.99,
      'date': '19 Fév 2025',
      'category': 'Divertissement'
    },
    {
      'title': 'Facture d\'électricité',
      'amount': -85.75,
      'date': '18 Fév 2025',
      'category': 'Services publics'
    },
    {
      'title': 'Dîner au restaurant',
      'amount': -62.30,
      'date': '15 Fév 2025',
      'category': 'Nourriture'
    },
  ].obs;

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedCategory.value == null) {
      return transactions;
    }
    return transactions
        .where((tx) => tx['category'] == selectedCategory.value)
        .toList();
  }

  void changeCategory(String? category) {
    selectedCategory.value = category;
    update();
  }

  void addTransactionForCategory() {
    if (selectedCategory.value == null) {
      print(
          'Aucune catégorie sélectionnée. Veuillez sélectionner une catégorie.');
      Get.snackbar(
        'Attention',
        'Aucune catégorie sélectionnée. Veuillez sélectionner une catégorie.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
      return;
    }

    // Show custom alert dialog to fill in transaction details
    Get.defaultDialog(
      title: 'Nouvelle transaction',
      content: TransactionForm(
        onSubmit: (title, amount, date) {
          final Map<String, Object> newTransaction = {
            'title': title,
            'amount': amount,
            'date': date,
            'category': selectedCategory.value!,
          };

          transactions.add(newTransaction);

          print('Nouvelle transaction ajoutée:');
          print('Catégorie: ${newTransaction['category']}');
          print('Titre: ${newTransaction['title']}');
          print('Montant: ${newTransaction['amount']} €');
          print('Date: ${newTransaction['date']}');

          Get.snackbar(
            'Succès',
            'Transaction ajoutée pour la catégorie ${selectedCategory.value}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            duration: const Duration(seconds: 3),
          );

          update();
        },
      ),
    );
  }
}
