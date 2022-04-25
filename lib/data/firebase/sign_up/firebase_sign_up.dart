import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/models/user_model.dart';

class FirebaseSignUp {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthResultStatus status = AuthResultStatus.undefined;

  Future<AuthResultStatus> createUserWithEmailAndPassword(
      UserModel userModel) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (credential.user != null) {
        final user = credential.user!;
        _updateDisplayName(user, userModel.name);
        _setFirestoreUser(user, userModel);
        _setStorageUser(user);
        status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      status = AuthExceptionHandler.handleException(e);
    }

    return status;
  }

  Future _updateDisplayName(User user, String name) async {
    return await user.updateDisplayName(name);
  }

  Future _setFirestoreUser(User user, UserModel model) async {
    return await _firestore.collection('users').doc(user.uid).set({
      'nome': model.name,
      'cpf': model.cpf,
      'email': model.email,
      'telefone': model.phone,
    });
  }

  Future _setStorageUser(User user) async {
    return await _storage
        .ref('uploads/${user.uid}/created.txt')
        .putString('created');
  }
}
