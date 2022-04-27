import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniestagios/controllers/user_controller.dart';

class AppInitial extends GetxController {
  final _userController = Get.find<UserController>();

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
      _userController.authState.listen(
        (event) async {
          if (event != null) {
            String role = await _userController.getRole();
            if (role == "estagiario") {
              Get.toNamed('/home');
            } else {
              Get.toNamed('/enterprise');
            }
          } else {
            Get.toNamed(
              '/login',
            );
          }
        },
        onError: (_) => Get.toNamed('/login'),
        cancelOnError: false,
      );
    }
  }
}
