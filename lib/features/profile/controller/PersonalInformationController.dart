import 'package:get/get.dart';

import '../model/userInfo.dart';

class PersonalInformationController extends GetxController {
  final personalInfo = PersonalInformation().obs;

  void updatePersonalInfo({
    String? fullName,
    DateTime? birthDate,
    String? gender,
    String? maritalStatus,
    int? dependents,
    bool? hasVehicle,
  }) {
    personalInfo.update((info) {
      info?.fullName = fullName ?? info.fullName;
      info?.birthDate = birthDate ?? info.birthDate;
      info?.gender = gender ?? info.gender;
      info?.maritalStatus = maritalStatus ?? info.maritalStatus;
      info?.dependents = dependents ?? info.dependents;
      info?.hasVehicle = hasVehicle ?? info.hasVehicle;
    });
  }

  void updateVehicleInfo({
    String? brand,
    String? model,
    int? acquisitionYear,
    double? estimatedValue,
    bool? isFinanced,
  }) {
    if (personalInfo.value.vehicle == null) {
      personalInfo.value.vehicle = Vehicle();
    }
    personalInfo.update((info) {
      info?.vehicle?.brand = brand ?? info.vehicle?.brand;
      info?.vehicle?.model = model ?? info.vehicle?.model;
      info?.vehicle?.acquisitionYear =
          acquisitionYear ?? info.vehicle?.acquisitionYear;
      info?.vehicle?.estimatedValue =
          estimatedValue ?? info.vehicle?.estimatedValue;
      info?.vehicle?.isFinanced = isFinanced ?? info.vehicle?.isFinanced;
    });
  }

  void updateProfessionalInfo({
    String? profession,
    String? sector,
    String? employer,
    String? contractType,
    int? yearsOfService,
  }) {
    if (personalInfo.value.professional == null) {
      personalInfo.value.professional = Professional();
    }
    personalInfo.update((info) {
      info?.professional?.profession =
          profession ?? info.professional?.profession;
      info?.professional?.sector = sector ?? info.professional?.sector;
      info?.professional?.employer = employer ?? info.professional?.employer;
      info?.professional?.contractType =
          contractType ?? info.professional?.contractType;
      info?.professional?.yearsOfService =
          yearsOfService ?? info.professional?.yearsOfService;
    });
  }

  void updateFinancialInfo({
    double? monthlyNetSalary,
    double? additionalIncome,
    double? fixedCharges,
  }) {
    if (personalInfo.value.financial == null) {
      personalInfo.value.financial = Financial();
    }
    personalInfo.update((info) {
      info?.financial?.monthlyNetSalary =
          monthlyNetSalary ?? info.financial?.monthlyNetSalary;
      info?.financial?.additionalIncome =
          additionalIncome ?? info.financial?.additionalIncome;
      info?.financial?.fixedCharges =
          fixedCharges ?? info.financial?.fixedCharges;
    });
  }

  void submitForm() {
    // Handle form submission
    print(personalInfo.value.toJson());
  }
}
