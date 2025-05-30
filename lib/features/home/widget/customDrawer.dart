import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_bh/features/home/controller/homeController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_bh/core/utils/localData.dart';

import '../../../../generated/l10n.dart';
import '../../../core/themes/color_mangers.dart';
import '../../../core/themes/string_manager.dart';
import '../../../routes/app_routing.dart';
import '../../../widgets/customText.dart';
import '../../../widgets/custom_profile_image.dart';
import '../../../widgets/drawer_widget.dart';
import '../../../widgets/text/custom_text.dart';

Widget customDrawer({
  required BuildContext context,
}) {
  // Get reference to the HomeController
  final HomeController homeController = Get.find<HomeController>();

  return Drawer(
    surfaceTintColor: const Color.fromARGB(104, 255, 255, 255),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        color: ColorManager.greybg
            .withOpacity(0.8), // Adjust the opacity as needed
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: Get.height * 0.005),
                margin: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: Get.width,
                height: Get.height / 4.5,
                child: Column(
                  children: [
                    customProfieImage(
                      redius: 50,
                    ),
                    const Gap(10),
                    // Use Obx to reactively update when userName changes
                    Obx(() => CustomText(
                          txt: homeController.userName.value,
                          color: ColorManager.blackLight,
                          size: 18,
                          fontweight: FontWeight.bold,
                          spacing: 1,
                          fontfamily: 'Cairo',
                        )),
                  ],
                ),
              ),
              Gap(Get.height * 0.05),
              customContainerWithListTile(
                title: S.of(context).profile,
                onTap: () {
                  AppRoutes().goTo(AppRoutes.profile);
                },
                icon: const Icon(
                  FeatherIcons.user,
                ),
              ),
              customContainerWithListTile(
                title: "taux de change  ",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.Exchange);
                },
                icon: const Icon(
                  FeatherIcons.list,
                ),
              ),
              customContainerWithListTile(
                title: "Notification ",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.notification);
                },
                icon: const Icon(
                  FeatherIcons.bell,
                ),
              ),
              customContainerWithListTile(
                title: "conseil ",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.consielDetails);
                },
                icon: const Icon(
                  FeatherIcons.bell,
                ),
              ),
              customContainerWithListTile(
                title: "Informations personnelles",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.personalInformation);
                },
                icon: const Icon(
                  FeatherIcons.lock,
                ),
              ),
              customContainerWithListTile(
                title: "Transaction",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.transactions);
                },
                icon: const Icon(
                  FeatherIcons.creditCard,
                ),
              ),
              customContainerWithListTile(
                title: "Routine Report",
                onTap: () {
                  AppRoutes().goTo(AppRoutes.report);
                },
                icon: const Icon(
                  FeatherIcons.fileText,
                ),
              ),
              SizedBox(height: 40),
              customContainerWithListTile(
                title: "Deconnexion",
                onTap: () {
                  AppRoutes().goToEnd(AppRoutes.login);
                },
                icon: const Icon(
                  FeatherIcons.fileText,
                ),
              ),
              // Replace Spacer with SizedBox
              CustomText(
                txt: 'Version 1.0.0',
                color: ColorManager.blackLight,
                size: 15,
                fontweight: FontWeight.bold,
                spacing: 1,
                fontfamily: 'Cairo',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
