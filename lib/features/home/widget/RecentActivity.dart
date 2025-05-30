import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Make sure to import this for date handling

import '../../../core/themes/color_mangers.dart';
import '../controller/TransactionController .dart';

class RecentActivity extends StatelessWidget {
  final RxList<Map<String, dynamic>> activities;

  RecentActivity({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the controller without calling methods in build
    final TransactionRapportController controller =
        Get.put(TransactionRapportController());

    // Use a worker to watch for changes to activities and update the controller
    ever(activities, (dynamic updatedActivities) {
      controller.initializeTransactions(updatedActivities);
    });

    // Initialize on first build - runs only once thanks to GetX dependency injection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeTransactions(activities);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Activité récente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Tabs Section
        Container(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GetX<TransactionRapportController>(
              builder: (ctrl) => Row(
                children: ctrl.periods.map((period) {
                  bool isSelected = ctrl.selectedPeriod.value == period;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => ctrl.changePeriod(period),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            period,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // List Section
        Expanded(
          child: GetX<TransactionRapportController>(
            builder: (ctrl) {
              if (ctrl.currentTransactions.isEmpty) {
                return Center(
                    child: Text('Aucune transaction pour cette période'));
              }

              return ListView.builder(
                itemCount: ctrl.currentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = ctrl.currentTransactions[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: transaction.isPositive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            transaction.isPositive
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.isPositive
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction.date,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${transaction.amount.toStringAsFixed(2)} TND',
                          style: TextStyle(
                            color: transaction.isPositive
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
