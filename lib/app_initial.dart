import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitial extends GetxController {
  setAccess() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstAccess', true);
  }

  getAccess() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstAccess = prefs.getBool('firstAccess') ?? false;

    if (!firstAccess) {
      Get.toNamed('/onboarding');
    } else {
      Get.toNamed('/home');
    }
  }
}
