import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/models/job_model.dart';
import 'package:uniestagios/screens/candidate_register/candidate_register_controller.dart';
import 'package:uniestagios/screens/job_register/job_register_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class CandidateRegisterPage extends StatefulWidget {
  const CandidateRegisterPage({Key? key}) : super(key: key);

  @override
  State<CandidateRegisterPage> createState() => _CandidateRegisterPageState();
}

class _CandidateRegisterPageState extends State<CandidateRegisterPage> {
  final controller = Get.find<CandidateRegisterController>();

  final formKey = GlobalKey<FormState>();
  JobModel jobModel = Get.arguments;

  final _loading = Get.find<LoadingController>();

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? _photo;

  @override
  void initState() {
    super.initState();
    print(jobModel.jobName);
  }

  Future imgFromGallery() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowMultiple: false,
    );
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.files.first.path!);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Envie seu currículo'),
            backgroundColor: kPrimaryColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: kDefaultPadding,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        TextButton.icon(
                          icon: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              kPrimaryColor,
                            ),
                          ),
                          onPressed: () {
                            imgFromGallery();
                          },
                          label: Text(
                            'Carregar currículo',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Obs: seu currículo precisa estar em formato PNG, JPG ou JPEG',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 30),
                        _photo != null
                            ? Image.file(
                                _photo!,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.fitWidth,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState?.save();

                if (_photo == null) {
                  appWarningDialog(
                    title: 'Erro!',
                    middleText: 'Você precisa inserir uma foto',
                  );
                }

                try {
                  _loading.on();
                  await controller.uploadFile(_photo).then(
                        (_) async => {
                          await controller.registerJob(jobModel),
                        },
                      );
                } finally {
                  _loading.out();
                }
              }
            },
            label: Text('Enviar'),
            icon: Icon(Icons.send),
            backgroundColor: kSecondaryColor,
          ),
        ),
        Obx(
          () => Visibility(
            visible: _loading.status.value,
            child: AppOverlay(),
          ),
        ),
      ],
    );
  }
}
