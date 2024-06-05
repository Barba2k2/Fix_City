import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../CommomWidgets/Form/form_header_widget.dart';
import '../../../../../Constants/colors.dart';
import '../../../../../Constants/image_strings.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../../../../Utils/Helper/helper_controller.dart';
import '../../../Controllers/login_controller.dart';
import '../../EmailHasSent/email_sent.dart';
import '../../Welcome/home_page.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              Get.offAll(() => const WelcomeScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(80),
                FormHeaderWidget(
                  image: tForgetPasswordImage,
                  imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                  title: tForgetPassword,
                  subTitle: tForgetMailSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                Form(
                  key: controller.resetPassEmailFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: Helper.validateEmail,
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: sendResetPasswordEmail,
                          child: Text(
                            'Enviar',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendResetPasswordEmail() async {
    try {
      final email = emailController.text;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log('E-mail enviado para: $email');
      await Get.to(
        () => const MailSend(),
      );
    } on FirebaseAuthException catch (e) {
      Helper.errorSnackBar(
        title: tOps,
        message: e.message,
      );
    } catch (e) {
      Helper.errorSnackBar(
        title: tOps,
        message: e.toString(),
      );
    }
  }
}
