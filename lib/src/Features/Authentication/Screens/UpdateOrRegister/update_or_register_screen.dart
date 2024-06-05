import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Constants/text_strings.dart';
import '../../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Login/login_screen.dart';
import '../Welcome/home_page.dart';

class UpdateOrRegisterScreen extends StatelessWidget {
  const UpdateOrRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_iphone_rounded,
                  size: 120,
                ),
                const Gap(80),
                Text(
                  verifyCredentials,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Gap(30),
                Text(
                  verfyPhoneSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                Text(
                  verifyPhoneSubtitle2,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gap(120),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: Text(
                      "VOLTAR",
                      style: GoogleFonts.poppins(
                        letterSpacing: 1.0,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(80),
                TextButton(
                  onPressed: () {
                    Get.offAll(
                      () => const WelcomeScreen(),
                    );
                    AuthenticationRepository.instance.logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_ios_rounded),
                      const Gap(5),
                      Text(
                        backToLogin,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
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
