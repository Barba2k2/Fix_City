import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Screens/ChangePass/password_change_screen.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    try {
      var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);

      if (isVerified) {
        Get.to(() => const PasswordChangeScreen());
      } else {
        _showErrorSnackbar(
          'Erro na Verificação',
          'OTP incorreto. Por favor, tente novamente.',
        );
      }
    } catch (e) {
      log('Erro de OTP: $e');
      _showErrorSnackbar('Erro', 'Ocorreu um erro ao verificar o OTP: $e');
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
