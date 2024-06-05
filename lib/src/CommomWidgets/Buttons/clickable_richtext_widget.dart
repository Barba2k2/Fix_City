import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class ClickableRichTextWidget extends StatelessWidget {
  const ClickableRichTextWidget({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onPressed,
  }) : super(key: key);

  final String text1, text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: text1,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextSpan(
                text: text2,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: tFacebookBgColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
