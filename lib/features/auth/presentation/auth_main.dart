import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import '../../../core/themes/assets_manager.dart';
import '../domain/auth_controller.dart';
import 'auth_view.dart';
import 'widget/signup_form.dart';

class AuthentifactionPage extends StatelessWidget {
  const AuthentifactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: AlignmentDirectional.bottomStart, children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor,
                Color.fromARGB(255, 137, 137, 137),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 9,
            top: MediaQuery.of(context).size.height / 8,
          ),
          child: Image(
              height: Get.height / 2.5,
              alignment: Alignment.centerLeft,
              image: AssetImage(AssetsManager.logo)),
        ),
        GetBuilder<AthControllerImp>(
            init: AthControllerImp(),
            builder: (controller) {
              return AnimatedContainer(
                  curve: Curves.easeInOutCirc,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  duration: const Duration(milliseconds: 500),
                  height: controller.height / 1.4,
                  decoration: BoxDecoration(
                      boxShadow: [],
                      color: Color.fromARGB(255, 205, 205, 205),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // hedhy awal page tet7al  ba3ed el splash screen
                        if (controller.welcome) const HomeAuth(),
                        if (!controller.isSignIn) SingUp(),
                      ],
                    ),
                  ));
            }),
      ]),
    );
  }
}
