import 'package:get/get.dart';

validInput(String val, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "الأسم غير صحيح";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "Votre email est incorrect";  }
  }

  // if (type == "phone") {
  //   if (!GetUtils.isTunisiaNumber(val)) {
  //     return "الهاتف غير صحيح";
  //   }
  // }
  if (type == "NumericOnly") {
    if (!GetUtils.isNumericOnly(val)) {
      return "كلمة المرور ضعيفة";
    }
  }
  if (type == "DateTime") {
    if (!GetUtils.isDateTime(val)) {
      return "not valid day";
    }
  }
  if (type == "password") {
    if (!GetUtils.isLengthBetween(val, 6, 20)) {
      return "Password faible";
    }
  }
  if (val.isEmpty) {
    return "الحقل فارغ";
  }
}
