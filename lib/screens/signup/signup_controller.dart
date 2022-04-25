import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/data/firebase/sign_up/firebase_sign_up.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:get/get.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class SignUpController extends GetxController {
  final _firebaseSignUp = FirebaseSignUp();

  Future signUp(UserModel model) async {
    final status = await _firebaseSignUp.createUserWithEmailAndPassword(
      model,
    );
    if (status == AuthResultStatus.successful) {
      Get.toNamed('/home');
    } else {
      appWarningDialog(
        title: 'Erro!',
        middleText: 'Tente novamente',
      );
    }
  }
}
