import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants/colors.dart';
import '../../Constants/text_strings.dart';

class Helper extends GetxController {
  //* ========= VALIDAÇÕES ========= *//

  static String? validateEmail(value) {
    if (value == null || value.isEmpty) return tEmailCannotEmpty;

    if (!GetUtils.isEmail(value)) return tInvalidEmailFormat;
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) return 'Campo Senha não pode ser vazio';

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'A senha deve ter 8 caracteres, com uma letra maiúscula,\num número e um símbolo.';
    }
    return null;
  }

  //* =========== SNACK-BARS =========== *//

  static successSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tSuccessSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.check_circle,
        color: tWhiteColor,
      ),
    );
  }

  static warningSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tWarningSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.exclamation_circle,
        color: tWhiteColor,
      ),
    );
  }

  static errorSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tErrorSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.times_circle,
        color: tWhiteColor,
      ),
    );
  }

  static modernSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.blueGrey,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(12),
    );
  }
}
