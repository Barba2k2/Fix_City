import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../CommomWidgets/Form/form_divider_widget.dart';
import '../../../../CommomWidgets/Form/form_header_widget.dart';
import '../../../../CommomWidgets/Form/social_footer.dart';
import '../../../../Constants/image_strings.dart';
import '../../../../Constants/text_strings.dart';
import '../SignUp/signup_screen.dart';
import '../Welcome/home_page.dart';
import 'Widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30.0,
            ),
            onPressed: () {
              Get.offAll(
                () => const WelcomeScreen(),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormHeaderWidget(
                  image: homeImage,
                  title: tLoginTitle,
                  subTitle: tLoginSubTitle,
                ),
                const LoginFormWidget(),
                const MyFormDividerWidget(),
                SocialFooter(
                  text1: tDontHaveAnAccount,
                  text2: tSignup,
                  onPressed: () => Get.off(
                    () => const SignupScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
