import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Constants/image_strings.dart';
import '../../Constants/text_strings.dart';
import '../../Features/Authentication/Controllers/login_controller.dart';
import '../Buttons/clickable_richtext_widget.dart';
import '../Buttons/social_button.dart';

class SocialFooter extends StatelessWidget {
  final String text1;

  final String text2;

  final VoidCallback onPressed;

  const SocialFooter({
    Key? key,
    this.text1 = tDontHaveAnAccount,
    this.text2 = tSignup,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Obx(
            () => SocialButton(
              image: googleLogo,
              background: tGoogleBgColor,
              foreground: tGoogleForegroundColor,
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              isLoading: controller.isGoogleLoading.value,
              onPressed: controller.isLoading.value
                  ? () {}
                  : controller.isGoogleLoading.value
                      ? () {}
                      : () => controller.googleSignIn(),
            ),
          ),
          const Gap(20),
          ClickableRichTextWidget(
            text1: text1.tr,
            text2: text2.tr,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
