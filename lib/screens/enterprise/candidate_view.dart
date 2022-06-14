import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/data/mail/send_mail.dart';
import 'package:uniestagios/models/candidate_model.dart';
import 'package:uniestagios/screens/enterprise/enterprise_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class CandidateView extends StatefulWidget {
  const CandidateView({
    Key? key,
  }) : super(key: key);

  @override
  State<CandidateView> createState() => _CandidateViewState();
}

class _CandidateViewState extends State<CandidateView> {
  final CandidateModel model = Get.arguments;
  final _loading = Get.find<LoadingController>();
  final _firestore = FirebaseFirestore.instance;
  final controller = Get.find<UserController>();

  final formKey = GlobalKey<FormState>();

  Future sendReceived(String id) async {
    return await _firestore
        .collection('candidatos')
        .doc(id)
        .update({'respondido': true});
  }

  Future downloadFile(String url, String intern) async {
    try {
      _loading.on();
      var status = await Permission.storage.request();

      if (status.isGranted) {
        var response = await Dio().get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );

        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(
            response.data,
          ),
          quality: 80,
          name: 'Curriculo',
        );
        print(result);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Currículo baixado com sucesso!',
          ),
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Erro ao baixar o currículo, tente novamente',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      _loading.out();
    } finally {
      _loading.out();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(
              'Currículo de ${model.internName}',
            ),
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
                        Image.network(
                          model.internResume,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  kPrimaryColor,
                                ),
                              ),
                              onPressed: () async {
                                await downloadFile(
                                  model.internResume,
                                  model.internName,
                                );
                              },
                              label: const Text(
                                'Baixar currículo',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            model.answered == false
                                ? TextButton.icon(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        kPrimaryColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      try {
                                        _loading.on();
                                        await sendReceived(model.id)
                                            .then((value) async {
                                          final code = await sendMail(
                                            fromName: controller.enterpriseModel
                                                    .socialReason ??
                                                '',
                                            fromEmail: controller
                                                    .enterpriseModel.email ??
                                                '',
                                            name: model.internName,
                                            email: model.internEmail,
                                            subject:
                                                'Resposta de ${controller.enterpriseModel.socialReason}',
                                            message:
                                                'Olá, ${model.internName}. Sua vaga para ${model.jobTitle} foi recebida e em breve a empresa entrará em contato!',
                                          );

                                          if (code == 200) {
                                            appWarningDialog(
                                                title: 'Currículo recebido!',
                                                content: const Text(
                                                    'A partir de agora empresa e candidato se comunicarão através das plataformas de e-mail, confira o e-mail do candidato na lista de candidatos.'),
                                                onConfirm: () {
                                                  Get.offAndToNamed(
                                                    '/enterprise',
                                                  );
                                                });
                                          }
                                        });
                                      } finally {
                                        _loading.out();
                                      }
                                    },
                                    label: const Text(
                                      'Recebido',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : TextButton.icon(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.grey,
                                      ),
                                    ),
                                    onPressed: null,
                                    label: const Text(
                                      'Recebido',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
