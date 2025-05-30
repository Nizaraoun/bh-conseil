import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:my_bh/core/themes/color_mangers.dart';

class ActualitesBH extends StatefulWidget {
  const ActualitesBH({super.key});

  @override
  State<ActualitesBH> createState() => _ActualitesBHState();
}

class _ActualitesBHState extends State<ActualitesBH> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  String? _imageUrl;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Future<String?> _uploadImage() async {
  //   if (_selectedImage == null) return null;

  //   try {
  //     final String fileName =
  //         'actualites/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final ref = _storage.ref().child(fileName);
  //     await ref.putFile(_selectedImage!);
  //     return await ref.getDownloadURL();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error uploading image: $e')),
  //     );
  //     return null;
  //   }
  // }

  Future<void> _addActualite() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Le titre et le contenu sont obligatoires')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _imageUrl;
      // if (_selectedImage != null) {
      //   imageUrl = await _uploadImage();
      // }

      await _firestore.collection('actualites').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'imageUrl': imageUrl,
        'date': Timestamp.now(),
        'isVisible': true,
      });

      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedImage = null;
        _imageUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actualité ajoutée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout de l\'actualité: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteActualite(String docId, String? imageUrl) async {
    try {
      await _firestore.collection('actualites').doc(docId).delete();

      // if (imageUrl != null) {
      //   await _storage.refFromURL(imageUrl).delete();
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actualité supprimée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la suppression de l\'actualité: $e')),
      );
    }
  }

  Future<void> _editActualite(DocumentSnapshot doc) async {
    _titleController.text = doc['title'];
    _contentController.text = doc['content'];
    setState(() {
      _imageUrl = doc['imageUrl'];
    });

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'actualité'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Contenu'),
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              if (_imageUrl != null)
                Column(
                  children: [
                    Image.network(_imageUrl!, height: 100),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _imageUrl = null;
                        });
                        Navigator.pop(context);
                        _editActualite(doc);
                      },
                      child: const Text('Supprimer l\'image'),
                    ),
                  ],
                ),
              if (_imageUrl == null)
                TextButton(
                  onPressed: () async {
                    await _pickImage();
                    Navigator.pop(context);
                    _editActualite(doc);
                  },
                  child: const Text('Sélectionner une image'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _contentController.clear();
              setState(() {
                _imageUrl = null;
                _selectedImage = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (_titleController.text.isEmpty ||
                  _contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Le titre et le contenu sont obligatoires')),
                );
                return;
              }

              String? newImageUrl = _imageUrl;
              // if (_selectedImage != null) {
              //   newImageUrl = await _uploadImage();
              // }

              await _firestore.collection('actualites').doc(doc.id).update({
                'title': _titleController.text,
                'content': _contentController.text,
                'imageUrl': newImageUrl,
                'updatedAt': Timestamp.now(),
              });

              _titleController.clear();
              _contentController.clear();
              setState(() {
                _imageUrl = null;
                _selectedImage = null;
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Actualité mise à jour avec succès')),
              );
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleVisibility(String docId, bool currentValue) async {
    await _firestore.collection('actualites').doc(docId).update({
      'isVisible': !currentValue,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Actualité ${!currentValue ? 'publiée' : 'masquée'} avec succès')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ajouter une actualité',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Titre',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                              labelText: 'Contenu',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _addActualite,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Publier l\'actualité',
                                style: TextStyle(
                                    fontSize: 16, color: ColorManager.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Actualités récentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('actualites')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('Aucune actualité pour le moment'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;

                          Timestamp timestamp = data['date'];
                          DateTime date = timestamp.toDate();
                          String formattedDate =
                              DateFormat('dd MMM yyyy, HH:mm').format(date);

                          bool isVisible = data['isVisible'] ?? true;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isVisible
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data['imageUrl'] != null)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      data['imageUrl'],
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data['title'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isVisible
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          if (!isVisible)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'Masqué',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        data['content'],
                                        style: TextStyle(
                                          color: isVisible
                                              ? Colors.black87
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: isVisible
                                                  ? Colors.orange
                                                  : Colors.green,
                                            ),
                                            onPressed: () => _toggleVisibility(
                                                doc.id, isVisible),
                                            tooltip: isVisible
                                                ? 'Masquer'
                                                : 'Afficher',
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () =>
                                                _editActualite(doc),
                                            tooltip: 'Modifier',
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () => _deleteActualite(
                                                doc.id, data['imageUrl']),
                                            tooltip: 'Supprimer',
                                          ),
                                        ],
                                      ),
                                    ],
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
            ),
    );
  }
}
