// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/themes/color_mangers.dart';
import '../../../../core/utils/input_validation.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/button/custom_button.dart';
import '../../../../widgets/button/custom_inkwell.dart';
import '../../../../widgets/input/custom_input.dart';
import '../../../../widgets/text/custom_text.dart';
import '../../domain/auth_controller.dart';

class SingUp extends StatelessWidget {
  SingUp({super.key});
  AthControllerImp controller = Get.put(AthControllerImp());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formstatesingup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            height: 50,
            validator: (p0) {
              controller.Inputsingup[0] = p0!;
              return validInput(p0, "username");
            },
            inputType: TextInputType.text,
            icon: const Icon(Icons.person),
            texthint: "Your Name",
          ),
          CustomTextFormField(
            height: 50,
            validator: (p0) {
              controller.Inputsingup[1] = p0!;
              return validInput(p0, "email");
            },
            inputType: TextInputType.text,
            icon: const Icon(Icons.mail),
            texthint: "Your Mail",
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            height: 50,
            validator: (p0) {
              controller.Inputsingup[2] = p0!;
              return validInput(p0, "phone");
            },
            inputType: TextInputType.phone,
            icon: const Icon(Icons.phone),
            texthint: "Phone Number",
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: S.of(context).SignUp,
            Onpress: () {
              controller.Singup();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CustomText(
                  txt: S.of(context).HaveAccount,
                  color: ColorManager.black,
                  size: Get.width / 23,
                  fontweight: FontWeight.w400,
                  spacing: 0,
                ),
                const Gap(10),
                CustomInkWell(
                  widget: CustomText(
                    txt: S.of(context).SignIn,
                    color: ColorManager.blue,
                    size: Get.width / 22,
                    fontweight: FontWeight.w700,
                    spacing: 0,
                  ),
                  ontap: () {
                    controller.singinwidget();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
