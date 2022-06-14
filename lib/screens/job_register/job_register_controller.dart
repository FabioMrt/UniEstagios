import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/data/firebase/job/firebase_job_data.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:path/path.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class JobRegisterController extends GetxController {
  final _firebaseJobData = FirebaseJobData();
  JobModel jobModel = JobModel();
  final user = Get.find<UserController>();
  final storage = FirebaseStorage.instance;

  Future uploadFile(File? _photo) async {
    if (_photo == null) return;
    final fileName = basename(_photo.path);
    final destination = 'uploads/${user.enterpriseModel.id}/$fileName';
    try {
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo);
      await ref.getDownloadURL().then((value) {
        jobModel.cvPic = value;

        Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Vaga postada com sucesso!',
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
                  Get.offAllNamed('/enterprise');
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

  Future uploadEditFile(File? _photo, JobModel model) async {
    if (_photo == null) return;
    final fileName = basename(_photo.path);
    final destination = 'uploads/${user.enterpriseModel.id}/$fileName';
    try {
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo);
      await ref.getDownloadURL().then((value) {
        model.cvPic = value;

        Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Vaga postada com sucesso!',
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
                  Get.offAllNamed('/enterprise');
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

  Future registerJob() async {
    jobModel.jobDate = DateTime.now();
    jobModel.profilePic = user.enterpriseModel.photo ?? '';
    jobModel.enterpriseName = user.enterpriseModel.socialReason ?? '';
    jobModel.enterpriseEmail = user.enterpriseModel.email ?? '';
    await _firebaseJobData.registerJob(jobModel, user.enterpriseModel);
  }

  Future updateJob(JobModel jobModel) async {
    print(jobModel.id);
    print(jobModel.jobName);
    print(jobModel.jobArea);
    jobModel.jobDate = DateTime.now();
    await _firebaseJobData.updateJob(jobModel);
  }
}
