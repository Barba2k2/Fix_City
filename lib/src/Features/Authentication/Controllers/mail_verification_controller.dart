import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../../../Constants/text_strings.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../../Utils/Helper/helper_controller.dart';

class MailVerificationController extends GetxController {
  late Timer timer;

  int _attempts = 0;

  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  void sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Helper.successSnackBar(
        title: "Sucesso",
        message: "E-mail enviado com sucesso!",
      );
    } catch (e) {
      Helper.errorSnackBar(
        title: tOps,
        message: e.toString(),
      );
    }
  }

  void setTimerForAutoRedirect() {
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        try {
          await Future.delayed(const Duration(seconds: 1));

          await FirebaseAuth.instance.currentUser?.reload();
        } catch (e) {
          throw ("Erro ao recarregar o usuário: $e");
        }

        final user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          timer.cancel();
          AuthenticationRepository.instance.setInitialScreen(user);
        } else if (_attempts > 20) {
          timer.cancel();
          Helper.errorSnackBar(
              title: "Erro", message: "Verifique manualmente seu e-mail");
        }

        _attempts++;
      },
    );
  }

  void manuallyCheckEmailVerifcationStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      await FirebaseAuth.instance.currentUser?.reload();
    } catch (e) {
      throw ("Erro ao recarregar o usuário: $e");
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user!.emailVerified) {
      AuthenticationRepository.instance.setInitialScreen(user);
    } else {
      Helper.errorSnackBar(
        title: "Erro",
        message: "E-mail ainda não verificado",
      );
    }
  }
}
