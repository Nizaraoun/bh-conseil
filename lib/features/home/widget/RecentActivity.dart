// transaction_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/themes/color_mangers.dart';
import '../controller/TransactionController .dart';

class RecentActivity extends StatelessWidget {
  RecentActivity({Key? key}) : super(key: key);

  final TransactionRapportController controller = Get.put(TransactionRapportController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent Activity',
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
              child: Obx(
                () => Row(
                  children: controller.periods.map((period) {
                    bool isSelected = controller.selectedPeriod.value == period;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => controller.changePeriod(period),
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
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
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
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.currentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = controller.currentTransactions[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
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
                          '${transaction.isPositive ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
