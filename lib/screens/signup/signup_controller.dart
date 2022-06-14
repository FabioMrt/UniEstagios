import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/data/firebase/sign_up/firebase_sign_up.dart';
import 'package:uniestagios/models/enterprise_model.dart';
import 'package:uniestagios/models/intern_model.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:get/get.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class SignUpController extends GetxController {
  final _firebaseSignUp = FirebaseSignUp();

  InternModel internModel = InternModel();
  EnterpriseModel enterpriseModel = EnterpriseModel();
  UserModel userInternModel = UserModel();
  UserModel userEnterpriseModel = UserModel();

  Future<User> signIntern() async {
    final user =
        await _firebaseSignUp.createInternUser(userInternModel, internModel);
    return user;
  }

  Future<User> signEnterprise() async {
    final user = await _firebaseSignUp.createEnterpriseUser(
        userEnterpriseModel, enterpriseModel);
    return user;
  }
}
