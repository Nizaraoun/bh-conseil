import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_bh/core/themes/color_mangers.dart';

class ConseilDetails extends StatefulWidget {
  const ConseilDetails({super.key});

  @override
  State<ConseilDetails> createState() => _ConseilDetailsState();
}

class _ConseilDetailsState extends State<ConseilDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _userAdviceStream;

  @override
  void initState() {
    super.initState();
    // Récupérer l'ID de l'utilisateur actuel
    String uid = _auth.currentUser?.uid ?? '';

    // Initialiser le stream pour récupérer tous les conseils de l'utilisateur
    _userAdviceStream = _firestore
        .collection('userAdvice')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  Future<void> _markAsRead(String adviceId) async {
    await _firestore
        .collection('userAdvice')
        .doc(adviceId)
        .update({'isRead': true});
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'investissement':
        return '💰';
      case 'épargne':
        return '💲';
      case 'achat_maison':
        return '🏠';
      case 'retraite':
        return '👴';
      case 'éducation':
        return '🎓';
      case 'santé':
        return '🏥';
      case 'succession':
      case 'patrimoine':
        return '📜';
      default:
        return '📋';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'investissement':
        return Colors.blue;
      case 'épargne':
        return Colors.green;
      case 'achat_maison':
        return Colors.brown;
      case 'retraite':
        return Colors.purple;
      case 'éducation':
        return Colors.orange;
      case 'santé':
        return Colors.red;
      case 'succession':
      case 'patrimoine':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Mes Conseils Financiers',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
        backgroundColor: ColorManager.primaryColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userAdviceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun conseil disponible pour le moment',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenez plus tard pour découvrir des conseils personnalisés',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Trier les conseils: non lus d'abord, puis par date
          List<DocumentSnapshot> sortedDocs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              bool aIsRead =
                  (a.data() as Map<String, dynamic>)['isRead'] ?? false;
              bool bIsRead =
                  (b.data() as Map<String, dynamic>)['isRead'] ?? false;

              if (aIsRead != bIsRead) {
                return aIsRead ? 1 : -1;
              }

              Timestamp aTimestamp =
                  (a.data() as Map<String, dynamic>)['createdAt'] ??
                      Timestamp.now();
              Timestamp bTimestamp =
                  (b.data() as Map<String, dynamic>)['createdAt'] ??
                      Timestamp.now();

              return bTimestamp.compareTo(aTimestamp);
            });

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section d'en-tête avec statistiques
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          snapshot.data!.docs.length.toString(),
                          'Total',
                          Icons.library_books,
                        ),
                        const SizedBox(height: 24, child: VerticalDivider()),
                        _buildStatColumn(
                          snapshot.data!.docs
                              .where((doc) =>
                                  !(doc.data()
                                      as Map<String, dynamic>)['isRead'] ??
                                  false)
                              .length
                              .toString(),
                          'Non lus',
                          Icons.mark_email_unread,
                        ),
                        const SizedBox(height: 24, child: VerticalDivider()),
                        _buildStatColumn(
                          snapshot.data!.docs
                              .where((doc) =>
                                  (doc.data()
                                      as Map<String, dynamic>)['isUseful'] ==
                                  true)
                              .length
                              .toString(),
                          'Utiles',
                          Icons.thumb_up,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    'Mes conseils financiers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Liste des conseils
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedDocs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = sortedDocs[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      String title = data['title'] ?? 'Sans titre';
                      String description = data['description'] ?? '';
                      String category = data['category'] ?? '';
                      List<String> categories =
                          category.split(',').map((e) => e.trim()).toList();
                      bool isRead = data['isRead'] ?? false;
                      Timestamp? createdAtTimestamp =
                          data['createdAt'] as Timestamp?;
                      String formattedDate = createdAtTimestamp != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(createdAtTimestamp.toDate())
                          : '';

                      return Card(
                        color: const Color.fromARGB(255, 252, 254, 255),
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 2.0),
                        elevation: isRead ? 1 : 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isRead
                              ? BorderSide.none
                              : BorderSide(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  width: 1),
                        ),
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            // Marquer comme lu et naviguer vers les détails
                            if (!isRead) {
                              _markAsRead(doc.id);
                            }

                            // Ouvrir les détails ou effectuer une action
                            // Navigation vers une page de détails pourrait être ajoutée ici
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.85,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                expand: false,
                                builder: (_, scrollController) =>
                                    SingleChildScrollView(
                                  controller: scrollController,
                                  child: _buildAdviceDetailView(data, doc.id),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Indicateur de non-lu
                                    if (!isRead)
                                      Container(
                                        width: 12,
                                        height: 12,
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 8),
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .blueAccent, // Change primary color to red
                                          shape: BoxShape.circle,
                                        ),
                                      ),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isRead
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  children: [
                                    // Catégories
                                    Wrap(
                                      spacing: 4,
                                      children: categories.take(2).map((cat) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getCategoryColor(cat)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _getCategoryColor(cat)
                                                  .withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(_getCategoryIcon(cat) + ' '),
                                              Text(
                                                cat,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: _getCategoryColor(cat),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    // Date
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent), // Change primary color to red
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAdviceDetailView(Map<String, dynamic> data, String docId) {
    String title = data['title'] ?? 'Sans titre';
    String description = data['description'] ?? 'Aucune description disponible';
    String category = data['category'] ?? '';
    bool isUseful = data['isUseful'] ?? false;
    Timestamp? createdAtTimestamp = data['createdAt'] as Timestamp?;
    String createdAt = createdAtTimestamp != null
        ? DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR')
            .format(createdAtTimestamp.toDate())
        : 'Date inconnue';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),
          ),

          // En-tête avec catégorie et date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              category.isNotEmpty
                  ? Chip(
                      label: Text(
                        category.split(',').first.trim(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor:
                          _getCategoryColor(category.split(',').first.trim()),
                    )
                  : const SizedBox.shrink(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  createdAt,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Titre du conseil
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Description du conseil
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // Évaluation
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ce conseil vous a-t-il été utile ?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.thumb_up),
                        label: const Text('Oui'),
                        onPressed: () async {
                          await _firestore
                              .collection('userAdvice')
                              .doc(docId)
                              .update({'isUseful': true});
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isUseful ? Colors.green : null,
                          foregroundColor: isUseful ? Colors.white : null,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.thumb_down),
                        label: const Text('Non'),
                        onPressed: () async {
                          await _firestore
                              .collection('userAdvice')
                              .doc(docId)
                              .update({'isUseful': false});
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isUseful == false ? Colors.red : null,
                          foregroundColor:
                              isUseful == false ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
