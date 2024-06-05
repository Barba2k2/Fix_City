import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../Constants/text_strings.dart';
import '../ForgetPassEmail/forget_pass_email.dart';
import 'forget_pass_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              tForgetPasswordTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              tForgetPasswordSubTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),
            FgtPassBtnWidget(
              btnIcon: CupertinoIcons.envelope_fill,
              title: tEmail,
              subTitle: tResetViaEMail,
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  () => const ForgetPasswordMailScreen(),
                );
              },
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
