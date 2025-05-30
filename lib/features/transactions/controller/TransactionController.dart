import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/localData.dart';
import 'TransactionForm.dart';

class TransactionController extends GetxController {
  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var selectedCategory = Rx<String?>(null);
  var isLoading = false.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  String? userId;
  
  @override
  void onInit() {
    super.onInit();
    initUser();
  }
  
  // Initialize user and fetch their transactions
  Future<void> initUser() async {
    userId = await LocalData.getUserId();
    if (userId != null) {
      fetchTransactions();
    } else {
      print('Error: No user ID found');
      Get.snackbar(
        'Erreur',
        'Impossible d\'identifier l\'utilisateur',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }
  
  // Fetch transactions from the user's document
  Future<void> fetchTransactions() async {
    if (userId == null) return;
    
    isLoading.value = true;
    update();
    
    try {
      // Get the user's transactions document
      final DocumentSnapshot doc = await _firestore.collection('transactions').doc(userId).get();
      
      transactions.clear();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('transactions')) {
          final List<dynamic> txList = data['transactions'];
          
          // Convert to our format
          for (var tx in txList) {
            transactions.add({
              'id': tx['id'],
              'title': tx['title'],
              'amount': tx['amount'],
              'date': tx['date'],
              'category': tx['category'],
              'timestamp': tx['timestamp'],
            });
          }
          
          // Sort by timestamp (newest first)
          transactions.sort((a, b) {
            final aTimestamp = a['timestamp'] as Timestamp;
            final bTimestamp = b['timestamp'] as Timestamp;
            return bTimestamp.compareTo(aTimestamp);
          });
        }
      } else {
        // Create the document if it doesn't exist
        await _firestore.collection('transactions').doc(userId).set({
          'transactions': [],
          'userId': userId,
          'lastUpdated': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les transactions: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

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
  
  // Add a new transaction to the user's document
  Future<void> addTransaction(String title, double amount, String date, String category) async {
    if (userId == null) return;
    
    isLoading.value = true;
    update();
    
    try {
      // Generate unique transaction ID
      final String txId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create transaction object
      final transactionData = {
        'id': txId,
        'title': title,
        'amount': amount,
        'date': date,
        'category': category,
        'timestamp': Timestamp.now(),
      };
      
      // Update Firestore - add transaction to the array
      await _firestore.collection('transactions').doc(userId).update({
        'transactions': FieldValue.arrayUnion([transactionData]),
        'lastUpdated': Timestamp.now(),
      });
      
      // Add to local list
      transactions.add(transactionData);
      
      // Sort by timestamp (newest first)
      transactions.sort((a, b) {
        final aTimestamp = a['timestamp'] as Timestamp;
        final bTimestamp = b['timestamp'] as Timestamp;
        return bTimestamp.compareTo(aTimestamp);
      });
      
      Get.snackbar(
        'Succès',
        'Transaction ajoutée pour la catégorie $category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error adding transaction: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter la transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }
  
  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    if (userId == null) return;
    
    try {
      // Find the transaction to remove
      final transactionToDelete = transactions.firstWhere((tx) => tx['id'] == id);
      
      // Remove from local list
      transactions.removeWhere((tx) => tx['id'] == id);
      update();
      
      // Get current transactions array
      final DocumentSnapshot doc = await _firestore.collection('transactions').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('transactions')) {
          final List<dynamic> txList = List.from(data['transactions']);
          
          // Remove the transaction with matching ID
          txList.removeWhere((tx) => tx['id'] == id);
          
          // Update the document with the new list
          await _firestore.collection('transactions').doc(userId).update({
            'transactions': txList,
            'lastUpdated': Timestamp.now(),
          });
          
          Get.snackbar(
            'Succès',
            'Transaction supprimée',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
          );
        }
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer la transaction: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  void addTransactionForCategory() {
    if (userId == null) {
      Get.snackbar(
        'Erreur',
        'Utilisateur non identifié',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return;
    }
    
    if (selectedCategory.value == null) {
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
          addTransaction(title, amount, date, selectedCategory.value!);
          Get.back();
        },
      ),
    );
  }
}
