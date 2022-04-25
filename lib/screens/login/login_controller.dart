import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/data/firebase/sign_in/firebase_sign_in.dart';

import 'package:get/get.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class LoginController extends GetxController {
  final _firebaseSignIn = FirebaseSignIn();

  Future signIn(String email, String password) async {
    final status = await _firebaseSignIn.signInWithEmailAndPassword(
      email,
      password,
    );
    if (status == AuthResultStatus.successful) {
      Get.toNamed('/home');
    } else {
      appWarningDialog(
        title: 'Erro!',
        middleText: 'E-Mail e/ou Senha incorretos',
      );
    }
  }
}
