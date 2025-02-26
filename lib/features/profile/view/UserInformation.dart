import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import 'package:my_bh/widgets/CustomElevatedButton.dart';
import 'package:my_bh/widgets/customIcon.dart';
import 'package:my_bh/widgets/input/custom_input.dart';
import 'package:my_bh/widgets/text/custom_text.dart';
import '../../../widgets/input/custom_drop_down.dart';
import '../controller/PersonalInformationController.dart';

class PersonalInformationView extends GetView<PersonalInformationController> {
  const PersonalInformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PersonalInformationController());

    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: true,
            pinned: true,
            backgroundColor: ColorManager.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomIconButton(
                icon: Icons.arrow_back,
                
                onPressed: () {
                  Get.back();
                },
                color: ColorManager.white,
                size: 30,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: CustomText(
                txt: 'Informations Personnelles',
                color: ColorManager.white,
                fontweight: FontWeight.w500,
                size: 20,
                spacing: 0.0,
                fontfamily: 'Tajawal',
              ),
              background: Container(
                decoration: const BoxDecoration(
                  color: ColorManager.primaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/document.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
              ),
            ),
          ),
          // Rest of the code remains the same
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPersonalSection(),
                    const SizedBox(height: 24),
                    _buildVehicleSection(),
                    const SizedBox(height: 24),
                    _buildProfessionalSection(),
                    const SizedBox(height: 24),
                    _buildFinancialSection(),
                    const SizedBox(height: 32),
                    customElevatedButton(
                        onPressed: controller.submitForm,
                        text: 'Soumettre',
                        color: ColorManager.primaryColor,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: ColorManager.whitePrimary,
                            fontWeight: FontWeight.bold),
                        width: Get.width * 0.5,
                        height: Get.height * 0.08,
                        borderRadius: 20),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the widget methods (_buildPersonalSection(), etc.) remain the same
  Widget _buildPersonalSection() {
    return Card(
      elevation: 5,
      color: ColorManager.whitePrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              txt: 'Information Personnelle',
              color: ColorManager.SoftBlack,
              fontweight: FontWeight.w500,
              size: 20,
              spacing: 0.0,
              fontfamily: 'Tajawal',
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              formOnChanged: (value) {
                controller.updatePersonalInfo(fullName: value);
              },
              height: 60,
              icon: Icon(Icons.person),
              inputType: TextInputType.text,
              texthint: 'Nom',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
              color: ColorManager.white,
            ),
            Gap(20),
            Row(
              children: [
                Expanded(
                    child: CustomDropDown(
                        labes: 'genre',
                        items: ['Homme', 'Femme']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          controller.updatePersonalInfo(gender: value);
                        })),
                const SizedBox(width: 16),
                Expanded(
                    child: CustomDropDown(
                  labes: 'Statut marital',
                  items: ['Célibataire', 'Marié(e)', 'Divorcé(e)', 'Veuf/Veuve']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) =>
                      controller.updatePersonalInfo(maritalStatus: value),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Obx(() => Card(
          elevation: 5,
          color: ColorManager.whitePrimary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  txt: 'Information Véhicule',
                  color: ColorManager.SoftBlack,
                  fontweight: FontWeight.w500,
                  size: 20,
                  spacing: 0.0,
                  fontfamily: 'Tajawal',
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Possédez-vous un véhicule?'),
                  value: controller.personalInfo.value.hasVehicle ?? false,
                  onChanged: (value) =>
                      controller.updatePersonalInfo(hasVehicle: value),
                ),
                if (controller.personalInfo.value.hasVehicle == true) ...[
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    formOnChanged: (value) {
                      controller.updateVehicleInfo(brand: value);
                    },  
                    height: 60,
                    icon: Icon(Icons.directions_car),
                    inputType: TextInputType.text,
                    texthint: 'model',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    formOnChanged: (value) {
                      controller.updateVehicleInfo(model: value);
                    },
                    height: 60,
                    icon: Icon(Icons.directions_car),
                    inputType: TextInputType.text,
                    texthint: 'Marque',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre marque';
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        ));
  }

  Widget _buildProfessionalSection() {
    return Card(
      elevation: 5,
      color: ColorManager.whitePrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations Professionnelles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              formOnChanged: (value) {
                controller.updateProfessionalInfo(profession: value);
              },
              height: 60,
              icon: Icon(Icons.work),
              inputType: TextInputType.text,
              texthint: 'Profession',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre profession';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              formOnChanged: (value) {
                controller.updateProfessionalInfo(employer: value);
              },
              height: 60,
              icon: Icon(Icons.business),
              inputType: TextInputType.text,
              texthint: 'Secteur d\'activité',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre secteur d\'activité';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSection() {
    return Card(
      elevation: 5,
      color: ColorManager.whitePrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations Financières',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              formOnChanged: (value) {
                controller.updateFinancialInfo(monthlyNetSalary: double.parse(value));
              },
              height: 60,
              icon: Icon(Icons.monetization_on),
              inputType: TextInputType.number,
              texthint: 'Salaire',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre salaire';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              formOnChanged: (value) {
                controller.updateFinancialInfo(additionalIncome: double.parse(value));
              },
              height: 60,
              icon: Icon(Icons.monetization_on),
              inputType: TextInputType.number,
              texthint: 'Autres revenus',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer vos autres revenus';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
