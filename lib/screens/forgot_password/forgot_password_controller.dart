import 'package:get/get.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/data/firebase/forgot_password/firebase_forgot_password.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class ForgotPasswordController extends GetxController {
  final _firebaseForgotPassword = FirebaseForgotPassword();

  String email = '';
  var checked = false.obs;

  Future resetPassword() async {
    final status = await _firebaseForgotPassword.resetPassword(email);
    if (status == AuthResultStatus.successful) {
      checked.value = true;
      Get.offAndToNamed('/login');
    } else if (status == AuthResultStatus.userNotFound) {
      appWarningDialog(
        title: 'Erro!',
        middleText: 'Não existe um usuário com essa conta',
      );
    } else {
      appWarningDialog(
        title: 'Erro!',
        middleText: 'Tente novamente',
      );
    }
  }
}
