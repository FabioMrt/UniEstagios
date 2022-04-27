import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
          .get();

      for (var doc in data.docs) {
        jobsList.add(JobModel.fromJson(doc.data()));
      }

      return jobsList;
    } on FirebaseException {
      rethrow;
    }
  }
}
