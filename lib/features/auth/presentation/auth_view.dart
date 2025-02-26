
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
  const HomeAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AthControllerImp>(
        init: AthControllerImp(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              CustomText(
                txt: "Login a votre compte",
                color: ColorManager.SoftBlack,
                fontweight: FontWeight.w700,
                size: Get.width / 15,
                spacing: 1,
                fontfamily: "Montserrat",
              ),
              SizedBox(
                height: Get.height / 25,
              ),
              CustomTextFormField(
                height: Get.height / 15,
                validator: (p0) {
                  controller.Inputlogin[0] = p0!;
                  return validInput(p0, "email");
                },
                inputType: TextInputType.text,
                obscureText: true,
                icon: const Icon(Icons.mail),
                texthint: S.of(context).email,
              ),
              CustomTextFormField(
                height: Get.height / 15,
                validator: (p0) {
                  controller.Inputlogin[0] = p0!;
                  return validInput(p0, "website");
                },
                inputType: TextInputType.text,
                obscureText: true,
                icon: const Icon(Icons.password),
                texthint: S.of(context).Password,
              ),
              Button(
                txtcolor: ColorManager.white,
                color: ColorManager.primaryColor,
                txt: S.of(context).Login,
                OnPressd: () {
                  controller.login();
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
          );
        });
  }
}
