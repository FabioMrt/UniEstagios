import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';

class FirebaseForgotPassword {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResultStatus?> resetPassword(String mail) async {
    AuthResultStatus? status;

    try {
      await _auth.sendPasswordResetEmail(email: mail);
      status = AuthResultStatus.successful;
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleException(e);
    }
    return status;
  }
}
