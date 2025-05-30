import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/userInfo.dart';

class PersonalInformationController extends GetxController {
  final personalInfo = PersonalInformation().obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;

  // Get current user ID
  String? get userId => _auth.currentUser?.uid;

  void updatePersonalInfo({
    String? fullName,
    double? age,
    String? gender,
    String? maritalStatus,
    int? dependents,
    bool? hasVehicle,
    bool? hasHouse,
  }) {
    personalInfo.update((info) {
      info?.fullName = fullName ?? info.fullName;
      info?.age = age ?? info.age;
      info?.gender = gender ?? info.gender;
      info?.maritalStatus = maritalStatus ?? info.maritalStatus;
      info?.dependents = dependents ?? info.dependents;
      info?.hasVehicle = hasVehicle ?? info.hasVehicle;
      info?.hasHouse = hasHouse ?? info.hasHouse;
    });
  }

  double? safeParseDouble(String value) {
    if (value.isEmpty) {
      return null;
    }

    try {
      return double.parse(value.replaceAll(' ', '').replaceAll(',', '.'));
    } catch (e) {
      print('Error parsing double: $e');
      return null;
    }
  }

// Helper method to safely parse int values
  int? safeParseInt(String value) {
    if (value.isEmpty) {
      return null;
    }

    try {
      return int.parse(value.replaceAll(' ', ''));
    } catch (e) {
      print('Error parsing int: $e');
      return null;
    }
  }

// Update your methods to use these safe parsers
  void updateVehicleInfo({
    String? brand,
    String? model,
    String? acquisitionYearStr,
    String? estimatedValueStr,
    bool? isFinanced,
  }) {
    // Parse numeric values safely
    int? acquisitionYear =
        acquisitionYearStr != null ? safeParseInt(acquisitionYearStr) : null;

    double? estimatedValue =
        estimatedValueStr != null ? safeParseDouble(estimatedValueStr) : null;

    if (personalInfo.value.vehicle == null) {
      personalInfo.value.vehicle = Vehicle();
    }

    personalInfo.update((info) {
      info?.vehicle?.brand = brand ?? info.vehicle?.brand;
      info?.vehicle?.model = model ?? info.vehicle?.model;
      info?.vehicle?.acquisitionYear =
          acquisitionYear ?? info.vehicle?.acquisitionYear;
      info?.vehicle?.estimatedValue =
          estimatedValue ?? info.vehicle?.estimatedValue;
      info?.vehicle?.isFinanced = isFinanced ?? info.vehicle?.isFinanced;
    });
  }

  void updateProfessionalInfo({
    String? profession,
    String? sector,
    String? employer,
    String? contractType,
    int? yearsOfService,
  }) {
    if (personalInfo.value.professional == null) {
      personalInfo.value.professional = Professional();
    }
    personalInfo.update((info) {
      info?.professional?.profession =
          profession ?? info.professional?.profession;
      info?.professional?.sector = sector ?? info.professional?.sector;
      info?.professional?.employer = employer ?? info.professional?.employer;
      info?.professional?.contractType =
          contractType ?? info.professional?.contractType;
      info?.professional?.yearsOfService =
          yearsOfService ?? info.professional?.yearsOfService;
    });
  }

  void updateFinancialInfo({
    String? monthlyNetSalaryStr,
    String? additionalIncomeStr,
    String? fixedChargesStr,
  }) {
    // Parse numeric values safely
    double? monthlyNetSalary = monthlyNetSalaryStr != null
        ? safeParseDouble(monthlyNetSalaryStr)
        : null;

    double? additionalIncome = additionalIncomeStr != null
        ? safeParseDouble(additionalIncomeStr)
        : null;

    double? fixedCharges =
        fixedChargesStr != null ? safeParseDouble(fixedChargesStr) : null;

    if (personalInfo.value.financial == null) {
      personalInfo.value.financial = Financial();
    }

    personalInfo.update((info) {
      info?.financial?.monthlyNetSalary =
          monthlyNetSalary ?? info.financial?.monthlyNetSalary;
      info?.financial?.additionalIncome =
          additionalIncome ?? info.financial?.additionalIncome;
      info?.financial?.fixedCharges =
          fixedCharges ?? info.financial?.fixedCharges;
    });
  }

// Add this method to your PersonalInformationController class

  bool validateForm() {
    if (personalInfo.value.fullName == null ||
        personalInfo.value.fullName!.isEmpty) {
      Get.snackbar('Erreur de validation', 'Veuillez entrer votre nom complet',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return false;
    }

    if (personalInfo.value.gender == null) {
      Get.snackbar('Erreur de validation', 'Veuillez sélectionner votre genre',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return false;
    }

    if (personalInfo.value.maritalStatus == null) {
      Get.snackbar(
          'Erreur de validation', 'Veuillez sélectionner votre statut marital',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return false;
    }

    // Validate vehicle information if the user has a vehicle
    if (personalInfo.value.hasVehicle == true) {
      if (personalInfo.value.vehicle?.brand == null ||
          personalInfo.value.vehicle!.brand!.isEmpty) {
        Get.snackbar('Erreur de validation',
            'Veuillez entrer la marque de votre véhicule',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
        return false;
      }

      if (personalInfo.value.vehicle?.model == null ||
          personalInfo.value.vehicle!.model!.isEmpty) {
        Get.snackbar('Erreur de validation',
            'Veuillez entrer le modèle de votre véhicule',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
        return false;
      }
    }

    // Validate professional information
    if (personalInfo.value.professional?.profession == null ||
        personalInfo.value.professional!.profession!.isEmpty) {
      Get.snackbar('Erreur de validation', 'Veuillez entrer votre profession',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return false;
    }

    // Validate financial information
    if (personalInfo.value.financial?.monthlyNetSalary == null) {
      Get.snackbar(
          'Erreur de validation', 'Veuillez entrer votre salaire mensuel net',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      return false;
    }

    return true;
  }

// Update your submitForm method to use the validation
  Future<void> submitForm() async {
    try {
      // Validate form
      if (!validateForm()) {
        return;
      }

      // Set loading state
      isLoading.value = true;

      // Check if user is authenticated
      if (userId == null) {
        Get.snackbar('Erreur',
            'Vous devez être connecté pour soumettre vos informations',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
        return;
      }

      // Convert personal info to JSON
      final userData = personalInfo.value.toJson();

      // Add timestamp
      userData['updatedAt'] = FieldValue.serverTimestamp();

      // Save to Firestore
      await _firestore.collection('users').doc(userId).set(
            userData,
            SetOptions(
                merge: true), // This will merge data with existing document
          );

      Get.snackbar(
          'Succès', 'Vos informations ont été enregistrées avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      // Match user advice and save
      await matchUserAdviceAndSave(
        userId: userId!,
        userInfo: personalInfo.value,
        firestore: _firestore,
      );

      // Optionally navigate back or to another screen
      // Get.back();
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
      print('Error saving data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String calculateRiskProfile(PersonalInformation userInfo) {
    // Calculer l'âge en années
    final age = userInfo.age ?? 0;
    // Obtenir le revenu mensuel net, utiliser 0 comme valeur par défaut
    final income = userInfo.financial?.monthlyNetSalary ?? 0;

    // Vérifier si l'utilisateur a des personnes à charge
    final hasDependents =
        userInfo.dependents != null && userInfo.dependents! > 0;

    // Vérifier si l'utilisateur a des dettes importantes
    final hasDebt = userInfo.financial?.fixedCharges != null &&
        userInfo.financial!.fixedCharges! > 0;

    // Calculer le profil de risque en fonction des critères
    if (age < 30 && income > 5000 && !hasDependents) {
      return 'high'; // Profil de risque élevé pour les jeunes avec un revenu élevé sans personnes à charge
    } else if (age < 30 && income > 5000 && hasDependents) {
      return 'medium'; // Profil de risque moyen pour les jeunes avec un revenu élevé mais avec personnes à charge
    } else if (age >= 30 && age < 50 && income > 3000) {
      return 'medium'; // Profil de risque moyen pour les adultes avec un revenu moyen
    } else if (age >= 50 && income > 4000 && !hasDebt) {
      return 'medium'; // Profil de risque moyen pour les personnes plus âgées avec un bon revenu sans dettes
    } else if (hasDependents || hasDebt) {
      return 'low'; // Profil de risque faible pour les personnes avec des personnes à charge ou des dettes
    } else if (age >= 60) {
      return 'very_low'; // Profil de risque très faible pour les personnes proches de la retraite
    } else {
      return 'unknown'; // Profil de risque inconnu pour les autres cas
    }
  }

  List<String> determineFinancialGoals(PersonalInformation userInfo) {
    // Calculer l'âge en années
    final age = userInfo.age != null ? userInfo.age : 0;

    // Obtenir le revenu mensuel net, utiliser 0 comme valeur par défaut
    final income = userInfo.financial?.monthlyNetSalary ?? 0;

    // Vérifier le statut marital
    final isMarried = userInfo.maritalStatus == 'Marié(e)';
    print('isMarried: $isMarried');

    // Vérifier si l'utilisateur a des personnes à charge
    final hasDependents =
        userInfo.dependents != null && userInfo.dependents! > 0;

    // Vérifier si l'utilisateur a un logement
    final hasHousing = userInfo.hasHouse == 'Propriétaire';

    // Liste pour stocker les objectifs financiers
    final goals = <String>[];

    // Déterminer les objectifs en fonction des critères
    if (age! < 30) {
      goals.add('investissement'); // Les jeunes ont tendance à investir

      if (!hasHousing && income > 3000) {
        goals.add(
            'achat_maison'); // Objectif d'achat de maison pour les jeunes avec un bon revenu
      }

      goals.add('fonds_urgence'); // Fonds d'urgence important pour les jeunes
    }

    if (age >= 30 && age < 45) {
      if (income > 4000) {
        goals.add('épargne'); // Revenu élevé => épargne
        goals.add(
            'investissement'); // Investissement pour croissance à moyen terme
      }

      if (isMarried || hasDependents) {
        if (!hasHousing) {
          goals.add(
              'achat_maison'); // Objectif d'achat de maison pour les familles
        }
        goals.add('fonds_éducation'); // Fonds pour l'éducation des enfants
      }
    }

    if (age >= 45 && age < 55) {
      goals.add('planification_retraite'); // Planification de la retraite

      if (income > 5000) {
        goals.add(
            'diversification_investissements'); // Diversification des investissements
      }
    }

    if (age >= 55) {
      goals.add('retraite'); // Objectif de retraite pour les personnes âgées
      goals.add('planification_successorale'); // Planification successorale
      goals.add('santé'); // Préparation aux dépenses de santé
    }
    //  épargne investissement fonds_urgence achat_maison investissement achat_maison  fonds_éducation santé planification_successorale planification_successorale diversification_investissements planification_retraite

    return goals.isNotEmpty ? goals : ['inconnu'];
  }

  Future<List<String>> matchUserAdviceAndSave({
    required String userId,
    required PersonalInformation userInfo,
    required FirebaseFirestore firestore,
  }) async {
    try {
      // 1. Obtenir le profil de risque et les objectifs financiers de l'utilisateur
      final String riskProfile = calculateRiskProfile(userInfo);
      final List<String> userGoals = determineFinancialGoals(userInfo);
      final double income = userInfo.financial?.monthlyNetSalary ?? 0;

      print(
          'Profil utilisateur - Risque: $riskProfile, Objectifs: ${userGoals.join(", ")}, Revenu: $income');

      // 2. Récupérer tous les conseils disponibles
      final QuerySnapshot adviceSnapshot =
          await firestore.collection('advice').get();

      // Stocker les IDs des conseils correspondants
      final List<String> matchedAdviceIds = [];

      // 3. Pour chaque conseil, vérifier s'il correspond au profil de l'utilisateur
      for (var adviceDoc in adviceSnapshot.docs) {
        final String adviceId = adviceDoc.id;
        final Map<String, dynamic> adviceData =
            adviceDoc.data() as Map<String, dynamic>;

        bool isMatch = true;

        // Vérifier les critères cibles si présents
        if (adviceData.containsKey('targetCriteria')) {
          final targetCriteria =
              adviceData['targetCriteria'] as Map<String, dynamic>;

          // Vérifier le profil de risque
          if (targetCriteria.containsKey('riskProfile')) {
            final String requiredRiskProfile = targetCriteria['riskProfile'];
            if (riskProfile != requiredRiskProfile) {
              isMatch = false;
              print(
                  'Conseil $adviceId non retenu: profil de risque non compatible ($requiredRiskProfile ≠ $riskProfile)');
            }
          }

          // Vérifier les objectifs financiers (si au moins un objectif correspond)
          if (isMatch && targetCriteria.containsKey('financialGoals')) {
            final List<dynamic> requiredGoals =
                targetCriteria['financialGoals'];
            bool hasMatchingGoal = false;

            for (var goal in requiredGoals) {
              if (userGoals.contains(goal)) {
                hasMatchingGoal = true;
                break;
              }
            }

            if (!hasMatchingGoal) {
              isMatch = false;
              print(
                  'Conseil $adviceId non retenu: aucun objectif financier compatible');
            }
          }

          // Vérifier les critères de revenu
          if (isMatch && targetCriteria.containsKey('income')) {
            final incomeMap = targetCriteria['income'] as Map<String, dynamic>;

            // Vérifier > (supérieur à)
            if (incomeMap.containsKey('>')) {
              final double threshold = incomeMap['>'].toDouble();
              if (income <= threshold) {
                isMatch = false;
                print(
                    'Conseil $adviceId non retenu: revenu insuffisant (> $threshold requis)');
              }
            }

            // Ajouter d'autres opérateurs si nécessaire (<, ==, >=, <=)
            if (isMatch && incomeMap.containsKey('<')) {
              final double threshold = incomeMap['<'].toDouble();
              if (income >= threshold) {
                isMatch = false;
                print(
                    'Conseil $adviceId non retenu: revenu trop élevé (< $threshold requis)');
              }
            }

            if (isMatch && incomeMap.containsKey('==')) {
              final double target = incomeMap['=='].toDouble();
              // Utiliser une marge de tolérance pour l'égalité des nombres à virgule flottante
              if ((income - target).abs() > 0.001) {
                isMatch = false;
                print(
                    'Conseil $adviceId non retenu: revenu différent (== $target requis)');
              }
            }

            if (isMatch && incomeMap.containsKey('>=')) {
              final double threshold = incomeMap['>='].toDouble();
              if (income < threshold) {
                isMatch = false;
                print(
                    'Conseil $adviceId non retenu: revenu insuffisant (>= $threshold requis)');
              }
            }

            if (isMatch && incomeMap.containsKey('<=')) {
              final double threshold = incomeMap['<='].toDouble();
              if (income > threshold) {
                isMatch = false;
                print(
                    'Conseil $adviceId non retenu: revenu trop élevé (<= $threshold requis)');
              }
            }
          }

          // Vérifier d'autres critères potentiels ici si nécessaire
          // Par exemple l'âge, le statut marital, etc.
        }

        // 4. Si le conseil correspond, l'ajouter à la liste des correspondances
        // et le sauvegarder dans UserAdvice
        if (isMatch) {
          matchedAdviceIds.add(adviceId);
          print('Conseil $adviceId retenu pour l\'utilisateur $userId');

          // Créer l'ID combiné pour le document UserAdvice
          final String userAdviceId = '${userId}_${adviceId}';

          // Vérifier si ce document existe déjà pour éviter les doublons
          final docRef = firestore.collection('userAdvice').doc(userAdviceId);
          final docSnapshot = await docRef.get();

          if (!docSnapshot.exists) {
            // Créer le document UserAdvice
            await docRef.set({
              'userId': userId,
              'adviceId': adviceId,
              'isRead': false,
              'isUseful': null,
              'createdAt': FieldValue.serverTimestamp(),

              // Ajouter d'autres champs si nécessaire
              'title': adviceData['title'],
              'category': adviceData['category'],
              'description': adviceData['description'],
            });

            print('Document UserAdvice créé: $userAdviceId');
          } else {
            print('Document UserAdvice existant pour: $userAdviceId');
          }
        }
      }

      print(
          'Nombre total de conseils correspondants: ${matchedAdviceIds.length}');
      return matchedAdviceIds;
    } catch (e) {
      print('Erreur lors du matching des conseils: $e');
      return [];
    }
  }

// Fonction pour récupérer les conseils d'un utilisateur
  Future<List<Map<String, dynamic>>> getUserAdvice(
      String userId, FirebaseFirestore firestore) async {
    try {
      // Récupérer tous les conseils de l'utilisateur
      final QuerySnapshot userAdviceSnapshot = await firestore
          .collection('userAdvice')
          .where('userId', isEqualTo: userId)
          .get();

      // Liste pour stocker les conseils complets
      final List<Map<String, dynamic>> userAdviceList = [];

      // Pour chaque userAdvice, récupérer les détails du conseil
      for (var userAdviceDoc in userAdviceSnapshot.docs) {
        final Map<String, dynamic> userAdviceData =
            userAdviceDoc.data() as Map<String, dynamic>;
        final String adviceId = userAdviceData['adviceId'];

        // Récupérer les détails du conseil
        final DocumentSnapshot adviceDoc =
            await firestore.collection('advice').doc(adviceId).get();

        if (adviceDoc.exists) {
          final Map<String, dynamic> adviceData =
              adviceDoc.data() as Map<String, dynamic>;

          // Combiner les données du conseil et du userAdvice
          userAdviceList.add({
            'userAdviceId': userAdviceDoc.id,
            'isRead': userAdviceData['isRead'],
            'isUseful': userAdviceData['isUseful'],
            'adviceId': adviceId,
            'title': adviceData['title'],
            'description': adviceData['description'],
            'category': adviceData['category'],
          });
        }
      }

      return userAdviceList;
    } catch (e) {
      print('Erreur lors de la récupération des conseils utilisateur: $e');
      return [];
    }
  }

// Fonction pour marquer un conseil comme lu
  Future<void> markAdviceAsRead(
      String userAdviceId, FirebaseFirestore firestore) async {
    try {
      await firestore
          .collection('userAdvice')
          .doc(userAdviceId)
          .update({'isRead': true, 'readAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Erreur lors du marquage du conseil comme lu: $e');
    }
  }

// Fonction pour évaluer un conseil (utile ou non)
  Future<void> rateAdvice(
      String userAdviceId, bool isUseful, FirebaseFirestore firestore) async {
    try {
      await firestore.collection('userAdvice').doc(userAdviceId).update(
          {'isUseful': isUseful, 'ratedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Erreur lors de l\'évaluation du conseil: $e');
    }
  }
}
