import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../core/themes/assets_manager.dart';
import '../../core/themes/color_mangers.dart';
import '../../core/themes/string_manager.dart';
import '../../routes/app_routing.dart';
import '../../widgets/CustomElevatedButton.dart';
import '../../widgets/customText.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          AssetsManager.splashLogo,
          fit: BoxFit.cover,
          width: 500,
          height: 250,
        ),
        Text(
          textAlign: TextAlign.left,
          "Bienvenue à BH Conseil ",
          style: StylesManager.headline1,
        ),
        Gap(20),
        customText(
            text:
                'Gérez vos comptes, effectuez vos transactions et accédez à tous vos services bancaires en toute simplicité. Sécurisé, rapide et pratique !',
            textStyle: StylesManager.subtitle2,
            textAlign: TextAlign.center),
        Gap(Get.height * 0.15),
        customElevatedButton(
            onPressed: () {
              AppRoutes().goToEnd(
                AppRoutes.home,
              );
            },
            text: "Commencer",
            textStyle: StylesManager.buttonText,
            width: Get.width * 0.8,
            height: 50,
            borderRadius: 10,
            color: ColorManager.white)
      ]),
    );
  }
}
