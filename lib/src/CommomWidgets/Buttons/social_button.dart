import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import 'button_loagind_widget.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.text,
    required this.image,
    this.isLoading = false,
    required this.background,
    required this.onPressed,
    required this.foreground,
  }) : super(key: key);

  final String text;

  final String image;

  final Color foreground, background;

  final VoidCallback onPressed;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: foreground,
          backgroundColor: background,
          side: BorderSide.none,
        ),
        icon: isLoading
            ? const SizedBox()
            : Image(
                image: AssetImage(image),
                width: 24,
                height: 24,
              ),
        label: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: blackColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
      ),
    );
  }
}
