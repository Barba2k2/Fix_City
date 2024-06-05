import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../CommomWidgets/Form/form_divider_widget.dart';
import '../../../../CommomWidgets/Form/form_header_widget.dart';
import '../../../../CommomWidgets/Form/social_footer.dart';
import '../../../../Constants/image_strings.dart';
import '../../../../Constants/text_strings.dart';
import '../Login/login_screen.dart';
import '../Welcome/home_page.dart';
import 'Widgets/sign_up_form_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              Get.offAll(
                () => const WelcomeScreen(),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormHeaderWidget(
                  image: homeImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.1,
                ),
                SignUpFormWidget(),
                const MyFormDividerWidget(),
                SocialFooter(
                    text1: tAlreadyHaveAnAccount,
                    text2: tLogin,
                    onPressed: () => Get.off(() => const LoginScreen())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
