import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../../Constants/colors.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Utils/Helper/helper_controller.dart';
import '../../../Controllers/login_controller.dart';
import '../../ForgetPass/ForgetPassOptions/foregt_pass_modal_bottom_sheet.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: Helper.validateEmail,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user),
                labelText: tEmail,
                hintText: tEmail,
              ),
            ),
            const Gap(10),
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                validator: (value) {
                  if (value!.isEmpty) return 'Insira sua senha.';
                  return null;
                },
                obscureText: controller.showPasswod.value ? false : true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint_rounded),
                  labelText: tPassword,
                  hintText: tPassword,
                  suffixIcon: IconButton(
                    icon: controller.showPasswod.value
                        ? const Icon(Icons.lock_open_rounded)
                        : const Icon(Icons.lock_outline_rounded),
                    onPressed: () => controller.showPasswod.value =
                        !controller.showPasswod.value,
                  ),
                ),
              ),
            ),
            const Gap(10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    ForgetPasswordScreen.buildShowModalBottomSheet(context),
                child: Text(
                  tForgetPassword,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: tFacebookBgColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            Obx(
              () => MyPrimaryButton(
                isLoading: controller.isLoading.value ? true : false,
                text: tLogin,
                onPressed: controller.isGoogleLoading.value
                    ? () {}
                    : controller.isLoading.value
                        ? () {}
                        : () => controller.login(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
