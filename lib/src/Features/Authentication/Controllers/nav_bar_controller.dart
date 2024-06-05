import 'package:get/get.dart';

class NavBarController extends GetxController {
  
  var tabIndex = 0;

  
  void chanegTabIndex(int index) {
    tabIndex = index;
    
    update();
  }
}
