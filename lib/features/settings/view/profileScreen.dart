import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

import '../../../../generated/l10n.dart';
import '../../../core/themes/color_mangers.dart';
import '../../../routes/app_routing.dart';
import '../../../widgets/custom_profile_image.dart';
import '../../../widgets/drawer_widget.dart';
import '../../../widgets/icons/custom_button.dart';
import '../../../widgets/text/custom_text.dart';
import '../../../core/utils/localData.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<String> _getUserName() async {
    return await LocalData.getCardDataByName('userName') ?? 'User';
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Changer le mot de passe"),
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  decoration:
                      InputDecoration(labelText: "le mot de passe actuel"),
                  obscureText: true,
                ),
                TextField(
                  controller: newPasswordController,
                  decoration:
                      InputDecoration(labelText: "novueau mot de passe"),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(labelText: "confirmer le mot de passe"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Check if new passwords match
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("les mots de passe ne correspondent pas")),
                  );
                  return;
                }

                try {
                  // Get current Firebase user
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Reauthenticate the user with their current password
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: currentPasswordController.text,
                    );

                    await user.reauthenticateWithCredential(credential);

                    // Now update the password
                    await user.updatePassword(newPasswordController.text);

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Mot de passe changé avec succès"),
                      ),
                    );
                  } else {
                    throw Exception("User not logged in");
                  }
                } on FirebaseAuthException catch (e) {
                  String errorMessage = "An error occurred";

                  switch (e.code) {
                    case 'wrong-password':
                      errorMessage = "Current password is incorrect";
                      break;
                    case 'weak-password':
                      errorMessage = "New password is too weak";
                      break;
                    case 'requires-recent-login':
                      errorMessage = "Please log in again and retry";
                      break;
                    default:
                      errorMessage = e.message ?? "An error occurred";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("le mot de passe est incorrect")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text("Change"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greybg,
      body: FutureBuilder<String>(
        future: _getUserName(),
        builder: (context, snapshot) {
          String userName = snapshot.data ?? 'User';
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: Get.height * 0.005),
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorManager.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.lightGrey2,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  width: Get.width,
                  height: Get.height / 3,
                  child: Column(
                    children: [
                      Gap(Get.height * 0.05),
                      Row(
                        children: [
                          const Gap(10),
                          CustomIconButton(
                            padding: EdgeInsets.all(Get.width / 35),
                            icon: const Icon(FontAwesomeIcons.xmark),
                            onPressed: () {
                              Get.back();
                            },
                            color: ColorManager.black,
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(7),
                              shadowColor:
                                  WidgetStateProperty.all(ColorManager.black),
                              backgroundColor:
                                  WidgetStateProperty.all(ColorManager.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            tooltip: S.of(context).back,
                            iconSize: Get.width / 20,
                            alignment: Alignment.centerLeft,
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            autofocus: true,
                          ),
                        ],
                      ),
                      customProfieImage(
                        redius: 50,
                      ),
                      const Gap(10),
                      CustomText(
                        txt: userName,
                        color: ColorManager.white,
                        size: 20,
                        fontweight: FontWeight.bold,
                        spacing: 1,
                        fontfamily: 'Cairo',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomText(
                    txt: "Paramètres",
                    color: ColorManager.black,
                    size: Get.width / 17,
                    fontweight: FontWeight.bold,
                    spacing: 1,
                    fontfamily: 'Cairo',
                  ),
                ),
                customContainerWithListTile(
                  title: "Changer le mot de passe",
                  onTap: () {
                    _showChangePasswordDialog(context);
                  },
                  icon: const Icon(
                    FeatherIcons.lock,
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomText(
                    txt: "A propos",
                    color: ColorManager.black,
                    size: Get.width / 17,
                    fontweight: FontWeight.bold,
                    spacing: 1,
                    fontfamily: 'Cairo',
                  ),
                ),
               
                customContainerWithListTile(
                  title: "Deconnexion",
                  onTap: () {
                    AppRoutes().goToEnd(AppRoutes.home);
                  },
                  icon: const Icon(
                    FeatherIcons.logOut,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
