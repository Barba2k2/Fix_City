import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Constants/text_strings.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../../Repository/UserRepository/user_repository.dart';
import '../../../Utils/Helper/helper_controller.dart';
import '../../Core/NavBar/navigation_bar.dart';
import '../Models/user_model.dart';
import '../Screens/ForgetPass/ForgetPassOtp/otp_screen.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final showPasswod = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final resetPassEmailFormKey = GlobalKey<FormState>();
  final resetPasswordEmailFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      isLoading.value = true;

      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final auth = AuthenticationRepository.instance;

      final loginResult = await auth.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!loginResult.success) {
        Helper.errorSnackBar(
          title: tOps,
          message: loginResult.errorMessage!,
        );
        isLoading.value = false;
        return;
      }

      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;

      await auth.signInWithGoogle();
      isGoogleLoading.value = false;

      if (!await UserRepository.instance.recordExist(auth.getUserEmail)) {
        UserModel user = UserModel(
          id: auth.getUserID,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
          phoneNo: auth.getPhoneNo,
        );
        await UserRepository.instance.createUserWithGoogle(user);
        Get.to(const MyNavigationBar());
      }
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  Future<void> facebookSignIn() async {
    try {
      isFacebookLoading.value = true;
      final auth = AuthenticationRepository.instance;

      await auth.signInWithFacebook();

      if (!await UserRepository.instance.recordExist(auth.getUserID)) {
        UserModel user = UserModel(
          id: auth.getUserID,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
          phoneNo: auth.getPhoneNo,
        );
        await UserRepository.instance.createUser(user);
      }
      isFacebookLoading.value = false;
    } catch (e) {
      isFacebookLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  Future<void> resetPasswordEmail() async {
    try {
      if (resetPassEmailFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      isLoading.value = true;

      await AuthenticationRepository.instance.resetPasswordEmail(
        emailController.text.trim(),
      );
      Get.to(() => const OTPScreen());
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }
}
