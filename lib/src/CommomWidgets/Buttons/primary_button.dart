import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Controller/theme_controller.dart';
import 'button_loagind_widget.dart';

class MyPrimaryButton extends StatelessWidget {
  const MyPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width = 100.0,
  }) : super(key: key);

  final String text;

  final VoidCallback onPressed;

  final bool isLoading;

  final bool isFullWidth;

  final double width;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: isDark ? blackColor : whiteColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
              ),
      ),
    );
  }
}
