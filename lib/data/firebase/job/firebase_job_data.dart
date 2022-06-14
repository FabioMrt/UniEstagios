import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniestagios/models/enterprise_model.dart';
import 'package:uniestagios/models/job_model.dart';

class FirebaseJobData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<JobModel>> getJobsByCity(String city) async {
    final List<JobModel> jobsList = [];

    try {
      final data = await _firestore
          .collection('vagas')
          .where('cidade', isEqualTo: city)
          .where('disponivel', isEqualTo: true)
          .orderBy('dataVaga', descending: true)
          .get();

      for (var doc in data.docs) {
        jobsList.add(JobModel.fromJson(doc.data()));
      }

      return jobsList;
    } on FirebaseException {
      rethrow;
    }
  }

  Future<List<JobModel>> getEnterpriseJobs(String id) async {
    final List<JobModel> jobsList = [];

    try {
      final data = await _firestore
          .collection('vagas')
          .where('empresaId', isEqualTo: id)
          .orderBy('dataVaga', descending: true)
          .get();

      for (var doc in data.docs) {
        jobsList.add(JobModel.fromJson(doc.data()));
      }

      return jobsList;
    } on FirebaseException {
      rethrow;
    }
  }

  Future registerJob(JobModel model, EnterpriseModel enterpriseModel) async {
    return await _firestore.collection('vagas').add({
      'area': model.jobArea,
      'cidade': enterpriseModel.city,
      'dataVaga': model.jobDate,
      'nomeVaga': model.jobName,
      'disponivel': model.available,
      'empresaId': enterpriseModel.id,
      'fotoPerfil': model.profilePic,
      'fotoVaga': model.cvPic,
      'nomeEmpresa': model.enterpriseName,
      'emailEmpresa': model.enterpriseEmail,
    }).then((doc) async {
      String id = doc.id;
      await doc.update({
        'id': id,
      });
    });
  }

  Future updateJob(JobModel model) async {
    return await _firestore.collection('vagas').doc(model.id).update({
      'area': model.jobArea,
      'dataVaga': model.jobDate,
      'nomeVaga': model.jobName,
      'fotoVaga': model.cvPic,
    });
  }

  Future updateJobAvailable(String id, bool available) async {
    return await _firestore.collection('vagas').doc(id).update({
      'disponivel': available,
    });
  }

  Future removeJob(String id) async {
    return await _firestore.collection('vagas').doc(id).delete();
  }
}
