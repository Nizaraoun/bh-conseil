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
    Get.put(HomeController());

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
                      text: 'home page',
                      textStyle: TextStyle(
                          color: ColorManager.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  Spacer(),
                ],
              ),
            ],
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20),
                customText(
                  text: "Let's save your money",
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: Get.width * 0.055,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customText(
                  text: 'Hello , Halima ben rjab',
                  textStyle: TextStyle(
                    color: ColorManager.grayColor,
                    fontSize: Get.width * 0.045,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(20),
                customText(
                  text: 'My Balance',
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
                    // Swiper(
                    //   itemCount: 3,
                    //   itemWidth: Get.width * 0.9,
                    //   itemHeight: Get.height * 0.3,
                    //   layout: SwiperLayout.STACK,
                    //   itemBuilder: (context, index) {
                    //     return Image.asset(
                    //       'assets/images/card3.png',
                    //       fit: BoxFit.cover,
                    //     );
                    //   },
                    // )
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
                        child: CustomText(
                          txt: 'TND 1,000.00',
                          color: ColorManager.white,
                          size: Get.width * 0.06,
                          fontweight: FontWeight.w500,
                          fontfamily: 'Barlow',
                          spacing: 0.0,
                        )),
                    Positioned(
                        top: Get.height * 0.145,
                        right: Get.width * 0.02,
                        child: Row(
                          children: [
                            Obx(
                              () => CustomText(
                                txt: isCardNumberVisible.value
                                    ? '5555 5555 5555 5555'
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
                            )
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
          RecentActivity(),
        ],
      ),
    );
  }
}
