import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';

class FirebaseSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus status = AuthResultStatus.undefined;

  Future<AuthResultStatus> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleException(e);
    }

    return status;
  }
}
