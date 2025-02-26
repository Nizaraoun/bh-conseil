// transaction_controller.dart
import 'package:get/get.dart';
import '../model/tansaction.dart';

class TransactionRapportController extends GetxController {
  final selectedPeriod = 'This Week'.obs;
  final periods = [
    'This Day',
    'This Week',
    'This Month',
    '6 Month',
  ];

  final allTransactions = {
    'This Day': [
      Transaction(
        name: "Today's Transaction",
        date: '14 February 2025',
        amount: 150.00,
        isPositive: true,
      ),
    ],
    'This Week': [
      Transaction(
        name: "Hector's Inc.",
        date: '14 February 2025',
        amount: 500.00,
        isPositive: true,
      ),
      Transaction(
        name: "Clara's Inc.",
        date: '12 February 2025',
        amount: 350.00,
        isPositive: false,
      ),
      Transaction(
        name: "Lively's",
        date: '10 February 2025',
        amount: 200.00,
        isPositive: true,
      ),
    ],
    'This Month': [
      Transaction(
        name: "Monthly Service",
        date: '14 February 2025',
        amount: 1500.00,
        isPositive: true,
      ),
      Transaction(
        name: "Monthly Service",
        date: '14 February 2025',
        amount: 1500.00,
        isPositive: true,
      ),
      Transaction(
        name: "Monthly Service",
        date: '14 February 2025',
        amount: 1500.00,
        isPositive: true,
      ),
      Transaction(
        name: "Monthly Rent",
        date: '5 February 2025',
        amount: 2000.00,
        isPositive: false,
      ),
      Transaction(
        name: "Monthly Salary",
        date: '1 February 2025',
        amount: 5000.00,
        isPositive: true,
      ),
    ],
    '6 Month': [
      Transaction(
        name: "Big Project",
        date: '14 February 2025',
        amount: 10000.00,
        isPositive: true,
      ),
      Transaction(
        name: "Investment",
        date: '15 December 2024',
        amount: 5000.00,
        isPositive: false,
      ),
      Transaction(
        name: "Bonus",
        date: '1 November 2024',
        amount: 3000.00,
        isPositive: true,
      ),
    ],
  };

  List<Transaction> get currentTransactions =>
      allTransactions[selectedPeriod.value] ?? [];

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }
}
