// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import '../../../../core/themes/color_mangers.dart';
// import '../../../../core/utils/input_validation.dart';
// import '../../../../generated/l10n.dart';
// import '../../../../widgets/button/custom_button.dart';
// import '../../../../widgets/button/custom_inkwell.dart';
// import '../../../../widgets/input/custom_input.dart';
// import '../../../../widgets/text/custom_text.dart';
// import '../../domain/auth_controller.dart';

// class SingIn extends StatelessWidget {
//   const SingIn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AthControllerImp controller = Get.put(AthControllerImp());

//     return Form(
//         key: controller.formstatelogin,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             CustomTextFormField(
//               height: 50,
//               validator: (p0) {
//                 controller.Inputlogin[0] = p0!;
//                 return validInput(p0, "phone");
//               },
//               inputType: TextInputType.phone,
//               icon: const Icon(Icons.phone),
//               texthint: S.of(context).PhoneNumber,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             CustomButton(
//               text: S.of(context).SignIn,
//               Onpress: () {
//                 controller.loginUser(
//                   controller.Inputlogin[0],
//                   controller.Inputlogin[1],
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   CustomText(
//                     txt: S.of(context).dontHaveAccount,
//                     color: ColorManager.black,
//                     size: Get.width / 23,
//                     fontweight: FontWeight.w400,
//                     spacing: 0,
//                   ),
//                   const Gap(10),
//                   CustomInkWell(
//                     widget: CustomText(
//                       txt: S.of(context).SignUp,
//                       color: ColorManager.blue,
//                       size: Get.width / 22,
//                       fontweight: FontWeight.w700,
//                       spacing: 0,
//                     ),
//                     ontap: () {
//                       controller.singupwidget();
//                       controller.isSignIn = !controller.isSignIn;
//                     },
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }
