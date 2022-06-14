import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniestagios/models/candidate_model.dart';
import 'package:uniestagios/models/intern_model.dart';

class FirebaseCandidateJobData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future registerCandidateJob(
      CandidateModel model, InternModel internModel) async {
    await _firestore.collection('candidatos').add({
      'cidadeEstagiario': internModel.city,
      'emailEstagiario': model.internEmail,
      'empresaId': model.enterpriseId,
      'respondido': false,
      'estagiarioId': internModel.id,
      'imagemEstagiario': model.internImage,
      'imagemCurriculo': model.internResume,
      'dataEnvio': model.sendDate,
      'nomeEstagiario': internModel.name,
      'tituloVaga': model.jobTitle,
      'universidadeEstagiario': internModel.university,
    }).then((doc) async {
      String id = doc.id;

      await doc.update({
        'id': id,
      });
      await _firestore
          .collection('vagas')
          .doc(id)
          .collection('vagasEnviadas')
          .add(
        {'estagiarioId': internModel.id},
      );
    });
  }

  Future registerCandidateCv(InternModel internModel) async {
    return await _firestore
        .collection('estagiarios')
        .doc(internModel.id)
        .update({
      'curriculo': internModel.cv,
    });
  }
}
