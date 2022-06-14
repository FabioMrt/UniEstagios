import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniestagios/models/candidate_model.dart';

class FirebaseCandidateData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<CandidateModel>> getEnterpriseCandidates(String id) async {
    final List<CandidateModel> candidatesList = [];

    try {
      final data = await _firestore
          .collection('candidatos')
          .where('empresaId', isEqualTo: id)
          .get();

      for (var doc in data.docs) {
        candidatesList.add(CandidateModel.fromJson(doc.data()));
      }

      return candidatesList;
    } on FirebaseException {
      rethrow;
    }
  }
}
