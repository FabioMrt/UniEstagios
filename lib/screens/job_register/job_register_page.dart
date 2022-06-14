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
import 'package:uniestagios/screens/job_register/job_register_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/areas.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class JobRegisterPage extends StatefulWidget {
  const JobRegisterPage({Key? key}) : super(key: key);

  @override
  State<JobRegisterPage> createState() => _JobRegisterPageState();
}

class _JobRegisterPageState extends State<JobRegisterPage> {
  final controller = Get.find<JobRegisterController>();

  final formKey = GlobalKey<FormState>();

  final _loading = Get.find<LoadingController>();
  JobModel? model = Get.arguments;
  TextEditingController nameController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? _photo;

  @override
  void initState() {
    super.initState();
    if (model != null) {
      print(model!.jobArea);
      getJobPic();
      nameController.text = model!.jobName;
    }
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

  String _selectedItem = '';
  String cvPic = '';

  Future<String> getJobPic() async {
    var data = await firestore.collection('vagas').doc(model!.id).get();
    cvPic = data['fotoVaga'];
    return cvPic;
  }

  @override
  Widget build(BuildContext context) {
    return model == null ? creating() : editing();
  }

  Widget creating() {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Cadastre uma vaga'),
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
                        AppInput(
                          controller: nameController,
                          hintText: 'Nome da vaga',
                          validator: (value) => validateForm(
                            value,
                            ValidationMethod.SIMPLE_FIELD,
                          ),
                          onSaved: (value) {
                            controller.jobModel.jobName = value ?? '';
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Área de atuação',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: 10,
                              ),
                            ),
                            child: ButtonTheme(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: Container(color: Colors.transparent),
                                items: appAreas
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            controller.jobModel.jobArea = e;
                                          });
                                        },
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedItem = value ?? '';
                                    controller.jobModel.jobArea = value ?? '';
                                  });
                                },
                                value: _selectedItem.isEmpty
                                    ? appAreas.first
                                    : _selectedItem,
                              ),
                            ),
                          ),
                        ),
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
                            'Carregar imagem',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _photo != null
                            ? Image.file(
                                _photo!,
                                fit: BoxFit.fill,
                              )
                            : Container()
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

                if (_selectedItem == '') {
                  print('entrou');
                  controller.jobModel.jobArea = 'COMPUTAÇÃO';
                }

                try {
                  _loading.on();
                  await controller.uploadFile(_photo).then(
                        (_) async => {
                          await controller.registerJob(),
                        },
                      );
                } finally {
                  _loading.out();
                }
              }
            },
            label: Text('Postar vaga'),
            icon: Icon(Icons.add),
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

  Widget editing() {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Atualizar vaga'),
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
                        AppInput(
                          controller: nameController,
                          hintText: 'Nome da vaga',
                          validator: (value) => validateForm(
                            value,
                            ValidationMethod.SIMPLE_FIELD,
                          ),
                          onSaved: (value) {
                            model!.jobName = value ?? '';
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Área de atuação',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: 10,
                              ),
                            ),
                            child: ButtonTheme(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: Container(color: Colors.transparent),
                                items: appAreas
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            model!.jobArea = e;
                                          });
                                        },
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedItem = value ?? '';
                                    model!.jobArea = value ?? '';
                                  });
                                },
                                value: model!.jobArea != ''
                                    ? model!.jobArea
                                    : _selectedItem.isEmpty
                                        ? appAreas.first
                                        : _selectedItem,
                              ),
                            ),
                          ),
                        ),
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
                            'Carregar imagem',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _photo != null
                            ? Image.file(
                                _photo!,
                                fit: BoxFit.fill,
                              )
                            : FutureBuilder<String>(
                                future: getJobPic(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircleAvatar(
                                      backgroundColor: kPrimaryColor,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                  String? picture =
                                      snapshot.data == '' ? '' : snapshot.data;

                                  return Image.network(
                                    picture!,
                                    fit: BoxFit.fill,
                                  );
                                },
                              )
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
                  await controller.uploadEditFile(_photo, model!).then(
                        (_) async => {
                          await controller.updateJob(model!),
                        },
                      );
                } finally {
                  _loading.out();
                }
              }
            },
            label: Text('Atualizar vaga'),
            icon: Icon(Icons.update),
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
