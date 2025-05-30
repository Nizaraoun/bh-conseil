import 'package:gap/gap.dart';
import 'package:my_bh/features/home/controller/homeController.dart';
import 'package:my_bh/widgets/customText.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bh/widgets/text/custom_text.dart';
import '../widget/RecentActivity.dart';
import '/../core/themes/color_mangers.dart';
import '../../../widgets/customIcon.dart';
import '../widget/customDrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isCardNumberVisible = false.obs;
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      drawer: customDrawer(context: context),
      appBar: AppBar(
          actionsIconTheme: const IconThemeData(
            color: ColorManager.white,
          ),
          iconTheme: const IconThemeData(color: ColorManager.white, size: 30),
          backgroundColor: ColorManager.primaryColor,
          toolbarHeight: Get.height * 0.07,
          shadowColor: ColorManager.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Gap(
                    Get.width / 7.5,
                  ),
                  customText(
                      text: 'Page d\'accueil',
                      textStyle: TextStyle(
                          color: ColorManager.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  Spacer(),
                ],
              ),
            ],
          )),
      body: FutureBuilder(
        future: homeController.loadDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20),
                    customText(
                      text: "Économisons votre argent",
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: Get.width * 0.055,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Use GetX instead of Obx for this username
                    GetX<HomeController>(
                      builder: (controller) => customText(
                        text: 'Salut , ${controller.userName.value}',
                        textStyle: TextStyle(
                          color: ColorManager.grayColor,
                          fontSize: Get.width * 0.045,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(20),
                    customText(
                      text: 'Mon Solde',
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: Get.width * 0.052,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(10),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.black.withOpacity(0.8),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            width: Get.width * 0.9,
                            'assets/images/card3.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.08,
                          right: Get.width * 0.35,
                          child: GetX<HomeController>(
                            builder: (controller) => CustomText(
                              txt:
                                  '${controller.cardCurrency.value} ${controller.cardBalance.value}',
                              color: ColorManager.white,
                              size: Get.width * 0.06,
                              fontweight: FontWeight.w500,
                              fontfamily: 'Barlow',
                              spacing: 0.0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.145,
                          right: Get.width * 0.02,
                          child: Row(
                            children: [
                              Obx(
                                () => CustomText(
                                  txt: isCardNumberVisible.value
                                      ? homeController.cardNumber.value
                                      : '**** **** **** ****',
                                  color: ColorManager.white,
                                  size: isCardNumberVisible.value
                                      ? Get.width * 0.07
                                      : Get.width * 0.09,
                                  fontweight: FontWeight.w500,
                                  fontfamily: 'Barlow',
                                  spacing: 0.0,
                                ),
                              ),
                              Obx(
                                () => CustomIconButton(
                                  size: 30,
                                  icon: isCardNumberVisible.value
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                  onPressed: () {
                                    isCardNumberVisible.value =
                                        !isCardNumberVisible.value;
                                  },
                                  color: ColorManager.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RecentActivity(
                  activities: homeController.recentActivities,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
