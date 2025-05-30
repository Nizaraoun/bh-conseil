import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionRapportController extends GetxController {
  final RxList<Transaction> allTransactions = <Transaction>[].obs;
  final RxList<Transaction> currentTransactions = <Transaction>[].obs;
  final RxString selectedPeriod = "Tous".obs;
  final List<String> periods = [
    "Tous",
    "Aujourd'hui",
    "Semaine",
    "Mois",
    "Année"
  ];

  @override
  void onInit() {
    super.onInit();
    // If activities are already available, initialize them
    if (Get.arguments != null &&
        Get.arguments is RxList<Map<String, dynamic>>) {
      final activities = Get.arguments as RxList<Map<String, dynamic>>;
      initializeTransactions(activities);

      // Listen for changes in activities and update
      ever(activities, (dynamic newActivities) {
        initializeTransactions(newActivities);
      });
    }
  }

  void initializeTransactions(List<Map<String, dynamic>> activities) {
    allTransactions.clear();

    for (var activity in activities) {
      allTransactions.add(Transaction.fromMap(activity));
    }

    // Initial filter
    filterTransactionsByPeriod(selectedPeriod.value);
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    filterTransactionsByPeriod(period);
  }

  void filterTransactionsByPeriod(String period) {
    DateTime now = DateTime.now();

    switch (period) {
      case "Aujourd'hui":
        currentTransactions.value = allTransactions.where((tx) {
          // Implement date filtering logic for today
          return isSameDay(tx.dateTime, now);
        }).toList();
        break;
      case "Semaine":
        // Filter for week
        currentTransactions.value = allTransactions.where((tx) {
          return isCurrentWeek(tx.dateTime, now);
        }).toList();
        break;
      case "Mois":
        // Filter for month
        currentTransactions.value = allTransactions.where((tx) {
          return isCurrentMonth(tx.dateTime, now);
        }).toList();
        break;
      case "Année":
        // Filter for year
        currentTransactions.value = allTransactions.where((tx) {
          return isCurrentYear(tx.dateTime, now);
        }).toList();
        break;
      default:
        // "All" or any other case
        currentTransactions.value = List.from(allTransactions);
    }
  }

  // Helper methods for date comparison
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isCurrentWeek(DateTime date, DateTime currentDate) {
    // Get the first day of the week
    DateTime firstDayOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    // Get the last day of the week
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    return date.isAfter(firstDayOfWeek.subtract(Duration(days: 1))) &&
        date.isBefore(lastDayOfWeek.add(Duration(days: 1)));
  }

  bool isCurrentMonth(DateTime date, DateTime currentDate) {
    return date.year == currentDate.year && date.month == currentDate.month;
  }

  bool isCurrentYear(DateTime date, DateTime currentDate) {
    return date.year == currentDate.year;
  }
}

class Transaction {
  final String name;
  final String date;
  final DateTime dateTime;
  final double amount;
  final bool isPositive;

  Transaction(
      {required this.name,
      required this.date,
      required this.dateTime,
      required this.amount,
      required this.isPositive});

  factory Transaction.fromMap(Map<String, dynamic> map) {
    // Parse the date string to DateTime
    DateTime dateTime;
    try {
      if (map['timestamp'] != null) {
        dateTime = DateTime.parse(map['timestamp']);
      } else if (map['date'] != null) {
        dateTime = DateFormat('dd MMMM yyyy').parse(map['date']);
      } else {
        dateTime = DateTime.now();
      }
    } catch (e) {
      dateTime = DateTime.now();
    }

    return Transaction(
      name: map['name'] ?? 'Unknown',
      date: map['date'] ?? 'Unknown date',
      dateTime: dateTime,
      amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : 0.0,
      isPositive: (map['amount'] is num) ? (map['amount'] as num) >= 0 : false,
    );
  }
}
