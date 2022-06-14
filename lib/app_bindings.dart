import 'package:uniestagios/app_initial.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/screens/candidate_register/candidate_register_controller.dart';
import 'package:uniestagios/screens/enterprise/enterprise_controller.dart';
import 'package:uniestagios/screens/forgot_password/forgot_password_controller.dart';
import 'package:uniestagios/screens/home/controllers/home_controller.dart';
import 'package:uniestagios/screens/job_register/job_register_controller.dart';
import 'package:uniestagios/screens/login/login_controller.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // CONTROLLERS
    Get.put(UserController(), permanent: true);
    Get.put(AppInitial(), permanent: true);
    Get.put(LoginController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(EnterpriseController(), permanent: true);
    Get.put(SignUpController(), permanent: true);
    Get.put(JobRegisterController(), permanent: true);
    Get.put(CandidateRegisterController(), permanent: true);
    Get.put(ForgotPasswordController(), permanent: true);
    Get.put(LoadingController(), permanent: true);
  }
}
