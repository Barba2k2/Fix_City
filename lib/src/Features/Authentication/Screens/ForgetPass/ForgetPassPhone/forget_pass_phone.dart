import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../CommomWidgets/Form/form_header_widget.dart';
import '../../../../../Constants/colors.dart';
import '../../../../../Constants/image_strings.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../Welcome/home_page.dart';
import '../ForgetPassOtp/otp_screen.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    final controller = Get.put(AuthenticationRepository());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
              color: isDark ? whiteColor : blackColor,
            ),
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
                  subTitle: tForgetPhoneSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: phoneNo,
                        decoration: const InputDecoration(
                          label: Text(tPhoneNo),
                          hintText: tPhoneNo,
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          phoneFormatter,
                        ],
                        keyboardType: TextInputType.phone,
                      ),
                      const Gap(20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.phoneAuthentication(
                              phoneNo.text.trim(),
                            );
                            Get.to(() => const OTPScreen());
                          },
                          child: const Text(tNext),
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
}
