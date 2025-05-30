import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('advice').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun conseil trouvé.'));
          }

          final adviceDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: adviceDocs.length,
            itemBuilder: (context, index) {
              final advice = adviceDocs[index].data() as Map<String, dynamic>;
              final adviceId = adviceDocs[index].id;

              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advice['title'] ?? 'Sans titre',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        advice['description'] ?? 'Aucune description',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16.0),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          Chip(
                            label: Text(
                                'Catégorie: ${advice['category'] ?? 'Non spécifiée'}'),
                            backgroundColor: Colors.blue.withOpacity(0.2),
                          ),
                          ...(advice['targetCriteria'] as Map<String, dynamic>?)
                                  ?.entries
                                  .map((entry) {
                                if (entry.value is Map) {
                                  return Chip(
                                    label: Text(
                                        '${entry.key}: ${entry.value.entries.first.value}'),
                                    backgroundColor:
                                        Colors.green.withOpacity(0.2),
                                  );
                                } else if (entry.value is List) {
                                  return Chip(
                                    label: Text(
                                        '${entry.key}: ${entry.value.join(', ')}'),
                                    backgroundColor:
                                        Colors.orange.withOpacity(0.2),
                                  );
                                } else {
                                  return Chip(
                                    label: Text('${entry.key}: ${entry.value}'),
                                    backgroundColor:
                                        Colors.purple.withOpacity(0.2),
                                  );
                                }
                              }).toList() ??
                              [],
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editAdvice(context, adviceId, advice);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteAdvice(context, adviceId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addAdvice(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editAdvice(
      BuildContext context, String adviceId, Map<String, dynamic> advice) {
    final titleController = TextEditingController(text: advice['title'] ?? '');
    final descriptionController =
        TextEditingController(text: advice['description'] ?? '');
    final categoryController =
        TextEditingController(text: advice['category'] ?? '');

    // Safely access nested fields with null checks
    final targetCriteria =
        advice['targetCriteria'] as Map<String, dynamic>? ?? {};
    final financialGoals = targetCriteria['financialGoals'] as List? ?? [];
    final financialGoalsController =
        TextEditingController(text: financialGoals.join(', '));

    List<String> selectedCategories = categoryController.text.isEmpty
        ? []
        : categoryController.text.split(',').map((e) => e.trim()).toList();
    List<String> selectedFinancialGoals = financialGoalsController.text.isEmpty
        ? []
        : financialGoalsController.text
            .split(',')
            .map((e) => e.trim())
            .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modifier le conseil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Titre'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        'investissement',
                        'épargne',
                        'famille',
                        'retraite',
                                                'credit',

                      ].map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: selectedCategories.contains(category),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                              categoryController.text =
                                  selectedCategories.join(', ');
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        'épargne',
                        'investissement',
                        'achat_maison',
                        'santé',
                        'credit',
                      ].map((goal) {
                        return FilterChip(
                          label: Text(goal),
                          selected: selectedFinancialGoals.contains(goal),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedFinancialGoals.add(goal);
                              } else {
                                selectedFinancialGoals.remove(goal);
                              }
                              financialGoalsController.text =
                                  selectedFinancialGoals.join(', ');
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Prepare update data with null checks
                    final updateData = {
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'category': categoryController.text,
                    };

                    // Only update financialGoals if they exist
                    if (selectedFinancialGoals.isNotEmpty) {
                      updateData['targetCriteria.financialGoals'] =
                          selectedFinancialGoals as String;
                    }

                    FirebaseFirestore.instance
                        .collection('advice')
                        .doc(adviceId)
                        .update(updateData);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAdvice(BuildContext context, String adviceId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le conseil'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce conseil?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('advice')
                    .doc(adviceId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _addAdvice(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final incomeController = TextEditingController(text: '0'); // Default value
    final riskProfileController = TextEditingController();
    final financialGoalsController = TextEditingController();

    List<String> selectedCategories = [];
    List<String> selectedFinancialGoals = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un nouveau conseil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Titre'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        'investissement',
                        'épargne',
                        'famille',
                        'retraite',
                                                'credit',

                      ].map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: selectedCategories.contains(category),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                              categoryController.text =
                                  selectedCategories.join(', ');
                            });
                          },
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: incomeController,
                      decoration: const InputDecoration(hintText: 'Revenu'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: riskProfileController,
                      decoration:
                          const InputDecoration(hintText: 'Profil de risque'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        'épargne',
                                                'credit',

                        'investissement',
                        'fonds_urgence',
                        'achat_maison',
                        'fonds_éducation',
                        'santé',
                        'planification_successorale',
                        'diversification_investissements',
                        'planification_retraite'
                      ].map((goal) {
                        return FilterChip(
                          label: Text(goal),
                          selected: selectedFinancialGoals.contains(goal),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedFinancialGoals.add(goal);
                              } else {
                                selectedFinancialGoals.remove(goal);
                              }
                              financialGoalsController.text =
                                  selectedFinancialGoals.join(', ');
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Use try-catch to handle potential parsing errors
                    try {
                      final income = incomeController.text.isEmpty
                          ? 0
                          : int.parse(incomeController.text);

                      FirebaseFirestore.instance.collection('advice').add({
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'category': categoryController.text,
                        'targetCriteria': {
                          'income': {'>': income},
                          'riskProfile': riskProfileController.text,
                          'financialGoals': selectedFinancialGoals,
                        },
                      });
                      Navigator.of(context).pop();
                    } catch (e) {
                      // Show error dialog if income parsing fails
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Erreur'),
                          content: Text(
                              'Valeur de revenu invalide: ${incomeController.text}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
