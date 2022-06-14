import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniestagios/core/errors/firebase/firebase_errors.dart';
import 'package:uniestagios/models/enterprise_model.dart';
import 'package:uniestagios/models/intern_model.dart';
import 'package:uniestagios/models/user_model.dart';

class FirebaseSignUp {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthResultStatus status = AuthResultStatus.undefined;
  late User user;

  Future<User> createInternUser(
      UserModel userModel, InternModel internModel) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (credential.user != null) {
        user = credential.user!;
        _updateDisplayName(user, userModel.name);
        _setRole(user, 'estagiario');
        _setInternFirestoreUser(user, userModel, internModel);
        _setStorageUser(user);
        status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      user.displayName == null;
      print(e);
      status = AuthExceptionHandler.handleException(e);
    }

    return user;
  }

  Future<User> createEnterpriseUser(
      UserModel userModel, EnterpriseModel enterpriseModel) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (credential.user != null) {
        user = credential.user!;
        _updateDisplayName(user, userModel.name);
        _setRole(user, 'empresa');
        _setEnterpriseFirestoreUser(user, userModel, enterpriseModel);
        _setStorageUser(user);
        status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      user.displayName == null;
      print(e);
      status = AuthExceptionHandler.handleException(e);
    }

    return user;
  }

  Future _updateDisplayName(User user, String name) async {
    return await user.updateDisplayName(name);
  }

  Future _setRole(User user, String role) async {
    return await _firestore.collection('users').doc(user.uid).set({
      "role": role,
    });
  }

  Future _setInternFirestoreUser(
      User user, UserModel userModel, InternModel internModel) async {
    return await _firestore.collection('estagiarios').doc(user.uid).set({
      'id': user.uid,
      'nome': userModel.name,
      'email': userModel.email,
      'telefone': userModel.phone,
      'universidade': internModel.university,
      'curso': internModel.course,
      'idade': internModel.age,
      'estado': internModel.state,
      'cidade': internModel.city,
      'fotoPerfil': '',
      'curriculo': '',
    });
  }

  Future _setEnterpriseFirestoreUser(
      User user, UserModel userModel, EnterpriseModel enterpriseModel) async {
    return await _firestore.collection('empresas').doc(user.uid).set({
      'id': user.uid,
      'nome': enterpriseModel.socialReason,
      'email': userModel.email,
      'area': enterpriseModel.area,
      'telefone': userModel.phone,
      'razaosocial': enterpriseModel.socialReason,
      'cnpj': enterpriseModel.cnpj,
      'estado': enterpriseModel.state,
      'cidade': enterpriseModel.city,
      'foto': '',
    });
  }

  Future _setStorageUser(User user) async {
    return await _storage
        .ref('uploads/${user.uid}/created.txt')
        .putString('created');
  }
}
