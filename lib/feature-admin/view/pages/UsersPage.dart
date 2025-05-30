import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  Future<void> _createUser(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    // Add controllers for card data
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardPasswordController =
        TextEditingController();
    final TextEditingController balanceController =
        TextEditingController(text: "1500.00");
    final TextEditingController cardTypeController =
        TextEditingController(text: "Gold");

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Créer un utilisateur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                ),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Nom complet'),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Genre'),
                ),
                // Add card details fields
                SizedBox(height: 20),
                Text("Informations de la carte",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(labelText: 'Numéro de carte'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cardPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Mot de passe de la carte'),
                  obscureText: true,
                ),
                TextField(
                  controller: balanceController,
                  decoration: InputDecoration(labelText: 'Solde'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cardTypeController,
                  decoration: InputDecoration(labelText: 'Type de carte'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final String email = emailController.text;
                final String password = passwordController.text;
                final String fullName = fullNameController.text;
                final String age = "";
                final String dependents = "";
                final String financial = "";
                final String hasVehicle = "";
                final String maritalStatus = "";
                final String professional = "";
                final String vehicle = "";
                final String gender = genderController.text;

                try {
                  // Create the user in Firebase Auth
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  String userId = userCredential.user?.uid ?? "";

                  // Create user document in users collection
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .set({
                    'email': email,
                    'fullName': fullName,
                    'age': age,
                    'dependents': dependents,
                    'financial': financial,
                    'gender': gender,
                    'hasVehicle': hasVehicle,
                    'maritalStatus': maritalStatus,
                    'professional': professional,
                    'vehicle': vehicle,
                  });

                  // Create dashboard document
                  await FirebaseFirestore.instance
                      .collection('dashboard')
                      .doc(userId)
                      .set({
                    'card': {
                      'balance': balanceController.text,
                      'cardNumber': cardNumberController.text,
                      'cardType': cardTypeController.text,
                      'password': cardPasswordController.text,
                    },
                    'userName': fullName,
                    'recentActivity': [
                      {
                        'name': 'création de compte',
                        'transaction': 'solde initial',
                        'amount': balanceController.text,
                        'date': DateTime.now()
                            .toIso8601String(), // Use a timestamp string instead of FieldValue.serverTimestamp()
                      }
                    ]
                  });

                  Navigator.of(context).pop();
                } catch (e) {
                  // Show error dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Erreur'),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(BuildContext context, String userId,
      Map<String, dynamic> userData) async {
    final TextEditingController fullNameController =
        TextEditingController(text: userData['fullName']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier l\'utilisateur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Nom complet'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({
                    'fullName': fullNameController.text,
                    'updatedAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  // Show error
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Erreur'),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          }

          final users = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nom')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Genre')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(Text(userData['fullName'] ?? 'N/A')),
                  DataCell(Text(userData['email'] ?? 'N/A')),
                  DataCell(Text(userData['gender'] ?? 'N/A')),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(context, doc.id, userData),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirmer la suppression'),
                                content: Text(
                                    'Êtes-vous sûr de vouloir supprimer cet utilisateur?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(doc.id)
                                          .delete();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Supprimer',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createUser(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
