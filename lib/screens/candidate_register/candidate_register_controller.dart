import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/data/firebase/job/firebase_candidate_job_data.dart';
import 'package:uniestagios/data/mail/send_mail.dart';
import 'package:uniestagios/models/candidate_model.dart';
import 'package:path/path.dart';
import 'package:uniestagios/models/intern_model.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class CandidateRegisterController extends GetxController {
  final _firebaseCandidateData = FirebaseCandidateJobData();
  CandidateModel candidateModel = CandidateModel();
  final user = Get.find<UserController>();
  final storage = FirebaseStorage.instance;

  Future uploadFile(File? _photo) async {
    if (_photo == null) return;
    final fileName = basename(_photo.path);
    final destination = 'uploads/${user.internModel.id}/$fileName';
    try {
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo);
      await ref.getDownloadURL().then((value) {
        user.internModel.cv = value;

        Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Currículo atualizado com sucesso!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );
      });
    } catch (e) {
      print('error occured');
    }
  }

  Future registerJob(JobModel jobModel) async {
    candidateModel.sendDate = DateTime.now();
    candidateModel.internImage = user.internModel.photo ?? '';
    candidateModel.internResume = user.internModel.cv ?? '';
    candidateModel.internName = user.internModel.name ?? '';
    candidateModel.jobTitle = jobModel.jobName;
    candidateModel.internEmail = user.email ?? '';
    candidateModel.enterpriseId = jobModel.enterpriseId;
    await _firebaseCandidateData
        .registerCandidateJob(candidateModel, user.internModel)
        .then((value) async {
      final code = await sendMail(
        fromName: candidateModel.internName,
        fromEmail: candidateModel.internEmail,
        name: candidateModel.internName,
        email: jobModel.enterpriseEmail,
        subject: 'Novo currículo',
        message:
            'Olá, ${jobModel.enterpriseName}. Você recebeu uma nova candidatura para a vaga ${jobModel.jobName}, confira no app Uniestágios. Nome do(a) candidato(a): ${candidateModel.internName}',
      );

      if (code == 200) {
        appWarningDialog(
          title: 'Currículo enviado!',
          middleText: 'Aguarde informações no seu e-mail',
        );
      } else if (code == 404 || code == 400 || code == 422) {
        appWarningDialog(
          title: 'Ocorreu um erro!',
          middleText: 'Tente novamente',
        );
      }
    });
  }

  Future registerCv(InternModel internModel) async {
    await _firebaseCandidateData.registerCandidateCv(internModel);
  }
}
