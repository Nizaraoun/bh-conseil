import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:get/get.dart';
import '../../../core/themes/color_mangers.dart';
import '../../../core/utils/constants.dart';
import '../../transactions/controller/TransactionController.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final TransactionController controller = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: true,
            pinned: true,
            backgroundColor: ColorManager.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: 0.0,
                  fontFamily: 'Tajawal',
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 150,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  // Replace with your SVG picture if needed:
                  // SvgPicture.asset(
                  //   'assets/images/transactions.svg',
                  //   fit: BoxFit.contain,
                  //   height: 150,
                  // ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: Get.height / 1.08,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Category Filter
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filtrer par catégorie',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: GetBuilder<TransactionController>(
                                builder: (controller) => DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Toutes les catégories'),
                                  value: controller.selectedCategory.value,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  borderRadius: BorderRadius.circular(10),
                                  onChanged: (String? newValue) {
                                    controller.changeCategory(newValue);
                                  },
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('Toutes les catégories'),
                                    ),
                                    ...categoryIcons.keys
                                        .map<DropdownMenuItem<String>>(
                                            (String key) {
                                      return DropdownMenuItem<String>(
                                        value: key,
                                        child: Row(
                                          children: [
                                            Icon(categoryIcons[key],
                                                color: categoryColors[key]),
                                            const SizedBox(width: 12),
                                            Text(
                                              key,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Horizontal Category Chips
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCategoryChip(
                              'Tous', Icons.apps, Colors.grey, controller),
                          ...categoryIcons.keys
                              .map(
                                (category) => _buildCategoryChip(
                                    category,
                                    categoryIcons[category] ?? Icons.category,
                                    categoryColors[category] ?? Colors.grey,
                                    controller),
                              )
                              .toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Transactions List
                    Expanded(
                      child: GetBuilder<TransactionController>(
                        builder: (controller) => ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                controller.filteredTransactions[index];
                            final bool isExpense = transaction['amount'] < 0;
                            final String category = transaction['category'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: (categoryColors[category] ??
                                            Colors.grey)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    categoryIcons[category] ??
                                        FeatherIcons.grid,
                                    color:
                                        categoryColors[category] ?? Colors.grey,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  transaction['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  '${transaction['date']} • ${transaction['category']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Text(
                                  '${isExpense ? '-' : '+'}${(isExpense ? -transaction['amount'] : transaction['amount']).toStringAsFixed(2)} TND',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        isExpense ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        child: const Icon(
          Icons.add,
          color: ColorManager.white,
        ),
        onPressed: () {
          // Call the controller method to add a transaction for the selected category
          Get.find<TransactionController>().addTransactionForCategory();
        },
        splashColor: Colors.white,
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color,
      TransactionController controller) {
    return GetBuilder<TransactionController>(builder: (_) {
      final bool isSelected =
          (controller.selectedCategory.value == null && label == 'Tous') ||
              controller.selectedCategory.value == label;

      return GestureDetector(
        onTap: () {
          controller.changeCategory(label == 'Tous' ? null : label);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? color : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
