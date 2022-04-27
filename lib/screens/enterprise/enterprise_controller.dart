import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/models/enterprise_model.dart';

class EnterpriseController extends GetxController {
  final _userController = Get.find<UserController>();

  Future<EnterpriseModel> getJobs() async {
    final user = await _userController.getCurrentEnterprise();
    return user;
  }
}
