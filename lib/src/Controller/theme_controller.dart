import 'package:get/get.dart';
import '../Utils/Theme/theme.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  bool get currentTheme => isDarkMode.value;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeTheme(
      isDarkMode.value ? MyAppTheme.darkTheme : MyAppTheme.lightTheme,
    );
  }
}
