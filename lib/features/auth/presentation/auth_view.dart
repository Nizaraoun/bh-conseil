import '../../../core/themes/color_mangers.dart';
import '/../widgets/input/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/input_validation.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/text/custom_text.dart';
import '../domain/auth_controller.dart';
import 'widget/button.dart';

class HomeAuth extends StatelessWidget {
  HomeAuth({super.key});
  AthControllerImp controller = Get.put(AthControllerImp());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formstatelogin,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomText(
              txt: "Se connecter à votre compte",
              color: ColorManager.SoftBlack,
              fontweight: FontWeight.w700,
              size: Get.width / 20,
              spacing: 1,
              fontfamily: "Montserrat",
            ),
            SizedBox(
              height: Get.height / 25,
            ),
            CustomTextFormField(
              height: Get.height / 15,
              validator: (p0) {
                print(p0);
                if (p0 != null && p0.isNotEmpty) {
                  controller.Inputlogin[0] = p0; // Save email value
                }
                return validInput(p0!, "email");
              },
              inputType: TextInputType.text,
              icon: const Icon(Icons.mail),
              texthint: "Votre Email",
            ),
            CustomTextFormField(
              height: Get.height / 15,
              validator: (p1) {
                if (p1 != null && p1.isNotEmpty) {
                  controller.Inputlogin[1] = p1; // Save password value
                }
                return validInput(p1!, "password");
              },
              inputType: TextInputType.text,
              obscureText: true,
              icon: const Icon(Icons.password),
              texthint: "mot de passe",
            ),
            Button(
              txtcolor: ColorManager.white,
              color: ColorManager.primaryColor,
              txt: "Se connecter",
              OnPressd: () {
                if (controller.formstatelogin.currentState!.validate()) {
                  // Form is valid, proceed with login
                  controller.loginUser(
                    controller.Inputlogin[0],
                    controller.Inputlogin[1],
                  );
                }
              },
            ),
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       children: [
            //         CustomText(
            //           txt: S.of(context).HaveAccount,
            //           color: ColorManager.black,
            //           size: Get.width / 23,
            //           fontweight: FontWeight.w400,
            //           spacing: 0,
            //         ),
            //         const Gap(10),
            //         CustomInkWell(
            //           widget: CustomText(
            //             txt: S.of(context).SignIn,
            //             color: ColorManager.SoftBlack,
            //             size: Get.width / 22,
            //             fontweight: FontWeight.w700,
            //             spacing: 0,
            //           ),
            //           ontap: () {
            //             controller.singinwidget();
            //           },
            //         )
            //       ],
            //     ),
            //   )
            //
          ],
        ));
  }
}
