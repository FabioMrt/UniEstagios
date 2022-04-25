import 'package:uniestagios/app_initial.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/screens/login/login_controller.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // CONTROLLERS
    Get.lazyPut<AppInitial>(() => AppInitial());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
    Get.lazyPut<LoadingController>(() => LoadingController());
  }
}
