import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uniestagios/models/enterprise_model.dart';
import 'package:uniestagios/models/intern_model.dart';

class UserController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<User?> get authState => _auth.authStateChanges();
  String? get userId => _auth.currentUser?.uid ?? '';

  EnterpriseModel enterpriseModel = EnterpriseModel();

  getRole() async {
    final data = await _firestore.collection('users').doc(userId).get();
    final snapshot = data.data();
    if (snapshot != null) {
      return snapshot["role"];
    }
  }

  Future<InternModel> getCurrentIntern() async {
    final data = await _firestore.collection('estagiarios').doc(userId).get();
    return InternModel.fromJson(data.data() ?? {});
  }

  Future getCurrentEnterprise() async {
    final data = await _firestore.collection('empresas').doc(userId).get();
    enterpriseModel = EnterpriseModel.fromJson(data.data() ?? {});
    return enterpriseModel;
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) => Get.toNamed('/login'));
  }
}
