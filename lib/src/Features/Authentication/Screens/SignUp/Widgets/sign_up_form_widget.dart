import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../../Constants/sizes.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Utils/Helper/helper_controller.dart';
import '../../../Controllers/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({Key? key}) : super(key: key);

  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 30),
        child: Form(
          key: controller.signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.fullName,
                validator: (value) =>
                    value!.isEmpty ? 'O campo Nome não pode ficar vazio' : null,
                decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const Gap(10),
              TextFormField(
                controller: controller.emailController,
                validator: Helper.validateEmail,
                decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(10),
              TextFormField(
                controller: controller.phoneNo,
                validator: (value) => value!.isEmpty
                    ? 'O campo Numero de Telefone não pode ficar vazio'
                    : null,
                inputFormatters: [phoneFormatter],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  label: Text(tPhoneNo),
                  prefixIcon: Icon(LineAwesomeIcons.phone),
                ),
              ),
              const Gap(10),
              TextFormField(
                controller: controller.cpf,
                validator: (value) => value!.isEmpty
                    ? 'O campo CPF não pode ficar vazio'
                    : GetUtils.isCpf(controller.cpf.text.trim())
                        ? null
                        : 'O CPF informado é invalido',
                inputFormatters: [cpfFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text(tCpf),
                  prefixIcon: Icon(CupertinoIcons.number),
                ),
              ),
              const Gap(10),
              Obx(
                () => TextFormField(
                  controller: controller.password,
                  validator: Helper.validatePassword,
                  obscureText: controller.showPassword.value ? false : true,
                  decoration: InputDecoration(
                    label: const Text(tPassword),
                    prefixIcon: const Icon(Icons.fingerprint),
                    suffixIcon: IconButton(
                      icon: controller.showPassword.value
                          ? const Icon(Icons.lock_open_rounded)
                          : const Icon(Icons.lock_outline_rounded),
                      onPressed: () => controller.showPassword.value =
                          !controller.showPassword.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: tFormHeight - 10),
              Obx(
                () => MyPrimaryButton(
                  isLoading: controller.isLoading.value,
                  text: "Cadastrar",
                  onPressed: controller.isGoogleLoading.value
                      ? () {}
                      : controller.isLoading.value
                          ? () {}
                          : () => controller
                              .createUser(controller.emailController.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
