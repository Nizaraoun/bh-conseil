import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import 'package:my_bh/widgets/text/custom_text.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/constants.dart';

// Import the LocalData class
class LocalData {
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}

// Category colors map
Map<String, Color> categoryColors = {
  'Nourriture': Colors.orange,
  'Salaire': Colors.green,
  'Cadeau': Colors.pink,
  'Investissement': Colors.blue,
  'Loyer': Colors.brown,
  'Prêt': Colors.red,
  'Assurance': Colors.teal,
  'Services publics': Colors.grey,
  'Eau': Colors.blueAccent,
  'Santé': Colors.redAccent,
  'Éducation': Colors.indigo,
  'Shopping': Colors.purple,
  'Transport': Colors.yellow,
  'Divertissement': Colors.deepPurple,
  'Factures': Colors.cyan,
  'Épicerie': Colors.lightGreen,
  'Voyage': Colors.deepOrange,
  'Fitness': Colors.lime,
  'Autres': Colors.black,
};

class Reportview extends StatefulWidget {
  const Reportview({Key? key}) : super(key: key);

  @override
  State<Reportview> createState() => _ReportviewState();
}

class _ReportviewState extends State<Reportview> {
  Map<String, double> dataMap = {};
  List<Map<String, dynamic>> categoryDetails = [];
  String userId = '';
  bool isLoading = true;

  // Filter variables
  double minAmount = 0;
  double maxAmount = double.infinity;
  DateTime? startDate;
  DateTime? endDate;
  bool isFilterActive = false;

  // Original unfiltered data
  List<Map<String, dynamic>> allTransactions = [];

  // Filter controllers
  final TextEditingController minAmountController = TextEditingController();
  final TextEditingController maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    minAmountController.dispose();
    maxAmountController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    String? id = await LocalData.getUserId();
    if (id != null) {
      setState(() {
        userId = id;
      });
      await fetchAllTransactionData();
    }
  }

  Future<void> fetchAllTransactionData() async {
    setState(() {
      isLoading = true;
      dataMap = {};
      categoryDetails = [];
      allTransactions = [];
    });

    try {
      // Query Firestore for all user transactions
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();

      // Process all transactions data and store in allTransactions list
      List<Map<String, dynamic>> tempAllTransactions = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> transactions = data['transactions'] ?? [];

        for (var tx in transactions) {
          String category = tx['category'] ?? 'Autres';
          double amount = 0;
          DateTime? transactionDate;

          // Parse amount
          if (tx['amount'] is int) {
            amount = (tx['amount'] as int).toDouble();
          } else if (tx['amount'] is double) {
            amount = tx['amount'];
          } else if (tx['amount'] is String) {
            try {
              amount = double.parse(tx['amount']);
            } catch (e) {
              print('Error parsing amount: ${tx['amount']}');
            }
          }

          // Parse date
          if (tx['date'] is String) {
            try {
              // Handle different possible date formats
              if (tx['date'].contains('UTC')) {
                transactionDate = DateTime.parse(tx['date']);
              } else {
                // Handle format like "28 Feb 2025"
                transactionDate = DateFormat('d MMM yyyy').parse(tx['date']);
              }
            } catch (e) {
              print('Error parsing date: ${tx['date']}');
            }
          } else if (tx['timestamp'] != null) {
            try {
              if (tx['timestamp'] is Timestamp) {
                transactionDate = (tx['timestamp'] as Timestamp).toDate();
              } else if (tx['timestamp'] is String) {
                transactionDate = DateTime.parse(tx['timestamp']);
              }
            } catch (e) {
              print('Error parsing timestamp: ${tx['timestamp']}');
            }
          }

          tempAllTransactions.add({
            'category': category,
            'amount': amount,
            'date': transactionDate,
            'title': tx['title'] ?? '',
            'id': tx['id'] ?? '',
          });
        }
      }

      setState(() {
        allTransactions = tempAllTransactions;
        isLoading = false;
      });

      // Apply initial processing with no filters
      processTransactions();
    } catch (e) {
      print('Error fetching transaction data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void processTransactions() {
    // Filter transactions based on current filter settings
    List<Map<String, dynamic>> filteredTransactions =
        allTransactions.where((tx) {
      bool passesAmountFilter =
          tx['amount'] >= minAmount && tx['amount'] <= maxAmount;

      bool passesDateFilter = true;
      if (startDate != null && tx['date'] != null) {
        passesDateFilter = tx['date'].isAfter(startDate!) ||
            tx['date'].isAtSameMomentAs(startDate!);
      }

      if (endDate != null && tx['date'] != null && passesDateFilter) {
        passesDateFilter = tx['date'].isBefore(endDate!) ||
            tx['date'].isAtSameMomentAs(endDate!);
      }

      return passesAmountFilter && passesDateFilter;
    }).toList();

    // Process the filtered transactions for chart display
    Map<String, double> tempDataMap = {};

    for (var tx in filteredTransactions) {
      String category = tx['category'];
      double amount = tx['amount'];

      // Add to data map for pie chart
      if (tempDataMap.containsKey(category)) {
        tempDataMap[category] = tempDataMap[category]! + amount;
      } else {
        tempDataMap[category] = amount;
      }
    }

    // Create category details list
    List<Map<String, dynamic>> tempCategoryDetails = [];
    tempDataMap.forEach((category, amount) {
      tempCategoryDetails.add({
        'category': category,
        'amount': amount,
        'color': categoryColors[category] ?? Colors.black,
      });
    });

    // Sort by amount (highest first)
    tempCategoryDetails.sort((a, b) => b['amount'].compareTo(a['amount']));

    setState(() {
      dataMap = tempDataMap;
      categoryDetails = tempCategoryDetails;
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Filtrer les dépenses'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Amount range filter
                  const Text('Montant',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min',
                            hintText: '0',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: maxAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max',
                            hintText: 'illimité',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date range filter
                  const Text('Période',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text(startDate == null
                        ? 'Date de début'
                        : DateFormat('dd MMM yyyy').format(startDate!)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          startDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(endDate == null
                        ? 'Date de fin'
                        : DateFormat('dd MMM yyyy').format(endDate!)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          endDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Réinitialiser'),
                onPressed: () {
                  setDialogState(() {
                    minAmountController.clear();
                    maxAmountController.clear();
                    startDate = null;
                    endDate = null;
                  });
                },
              ),
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Appliquer'),
                onPressed: () {
                  setState(() {
                    // Apply amount filters
                    minAmount = minAmountController.text.isEmpty
                        ? 0
                        : double.parse(minAmountController.text);

                    maxAmount = maxAmountController.text.isEmpty
                        ? double.infinity
                        : double.parse(maxAmountController.text);

                    // Track if filter is active
                    isFilterActive = minAmount > 0 ||
                        maxAmount < double.infinity ||
                        startDate != null ||
                        endDate != null;
                  });

                  // Process transactions with new filters
                  processTransactions();

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorList =
        categoryDetails.map((item) => item['color'] as Color).toList();

    // If colors list is empty, provide default colors
    if (colorList.isEmpty) {
      colorList = [Colors.blue, Colors.red, Colors.green, Colors.yellow];
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const CustomText(
          txt: 'Rapport des dépenses',
          color: Colors.white,
          size: 20,
          fontweight: FontWeight.bold,
          spacing: 1,
          fontfamily: 'Cairo',
        ),
        centerTitle: true,
        backgroundColor: ColorManager.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                // Filter Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [     
                    const CustomText(
                        txt: 'Dépenses',
                        color: Colors.black,
                        size: 15,
                        fontweight: FontWeight.bold,
                        spacing: 1,
                        fontfamily: 'Cairo',
                      ),
                      const Spacer(),
                      // Filter Button
                      ElevatedButton.icon(
                        onPressed: showFilterDialog,
                        icon: Icon(
                          FeatherIcons.filter,
                          color: isFilterActive ? Colors.blue : Colors.grey,
                          size: 18,
                        ),
                        label: Text(
                          'Filtre',
                          style: TextStyle(
                            color: isFilterActive ? Colors.blue : Colors.grey,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: isFilterActive ? 3 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isFilterActive ? Colors.blue : Colors.grey,
                              width: isFilterActive ? 2 : 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Filter Indicator
                if (isFilterActive)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(FeatherIcons.alertCircle,
                            color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            txt: 'Filtres actifs: ' +
                                (minAmount > 0 ? 'Min $minAmount, ' : '') +
                                (maxAmount < double.infinity
                                    ? 'Max $maxAmount, '
                                    : '') +
                                (startDate != null
                                    ? 'Depuis ${DateFormat('dd/MM/yyyy').format(startDate!)}, '
                                    : '') +
                                (endDate != null
                                    ? 'Jusqu\'à ${DateFormat('dd/MM/yyyy').format(endDate!)}, '
                                    : ''),
                            color: Colors.blue,
                            size: 12,
                            fontweight: FontWeight.normal,
                            spacing: 1,
                            fontfamily: 'Cairo',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              minAmount = 0;
                              maxAmount = double.infinity;
                              startDate = null;
                              endDate = null;
                              isFilterActive = false;
                              minAmountController.clear();
                              maxAmountController.clear();
                            });
                            processTransactions();
                          },
                          child: const Icon(FeatherIcons.x,
                              color: Colors.red, size: 16),
                        ),
                      ],
                    ),
                  ),

                if (dataMap.isEmpty)
                  const Expanded(
                    child: Center(
                      child: CustomText(
                        txt: 'Pas de données',
                        color: Colors.black54,
                        size: 15,
                        fontweight: FontWeight.normal,
                        spacing: 1,
                        fontfamily: 'Cairo',
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                            vertical: 16,
                          ),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartLegendSpacing: 40,
                            chartRadius: MediaQuery.of(context).size.width / 2,
                            colorList: colorList,
                            initialAngleInDegree: 0,
                            chartType: ChartType.disc,
                            ringStrokeWidth: 50,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.left,
                              showLegends: true,
                              legendShape: BoxShape.rectangle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Text(
                            "details :",
                            style: TextStyle(
                                color: ColorManager.SoftBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: categoryDetails.length,
                            itemBuilder: (context, index) {
                              final detail = categoryDetails[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.lightGrey,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    categoryIcons[detail['category']] ??
                                        FeatherIcons.grid,
                                    color: detail['color'],
                                    shadows: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  title: CustomText(
                                    txt: detail['category'],
                                    color: Colors.black,
                                    size: 15,
                                    fontweight: FontWeight.bold,
                                    spacing: 1,
                                    fontfamily: 'Cairo',
                                  ),
                                  trailing: CustomText(
                                    txt: detail['amount'].toStringAsFixed(0) +
                                        ' TND',
                                    color: Colors.black,
                                    size: 15,
                                    fontweight: FontWeight.bold,
                                    spacing: 1,
                                    fontfamily: 'Cairo',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
