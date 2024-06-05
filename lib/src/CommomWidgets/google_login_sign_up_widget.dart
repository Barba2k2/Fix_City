import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/colors.dart';
import '../Constants/image_strings.dart';

class GoogleLoginSignUpWidget extends StatelessWidget {
  const GoogleLoginSignUpWidget({
    super.key,
    required this.text,
    required this.onPreseed,
  });

  final String text;
  final VoidCallback onPreseed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'OU',
          style: GoogleFonts.inter(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Gap(10),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPreseed,
              icon: const Image(
                image: AssetImage(googleLogo),
                width: 20,
              ),
              label: Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
