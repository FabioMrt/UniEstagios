import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/shared/csc_picker.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class InternSecondSignUp extends StatefulWidget {
  const InternSecondSignUp({Key? key}) : super(key: key);

  @override
  State<InternSecondSignUp> createState() => _InternSecondSignUpState();
}

class _InternSecondSignUpState extends State<InternSecondSignUp> {
  final controller = Get.find<SignUpController>();

  final _userController = Get.find<UserController>();

  final formKey = GlobalKey<FormState>();
  final _loading = Get.find<LoadingController>();
  File? _photo;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future uploadFile(File? _photo, User user) async {
    if (_photo == null) return;
    final fileName = basename(_photo.path);
    final destination = 'uploads/${user.uid}/$fileName';
    try {
      _loading.on();
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo);
      await ref.getDownloadURL().then((value) async {
        await firestore
            .collection('estagiarios')
            .doc(user.uid)
            .update({'fotoPerfil': value});
      }).then((value) {
        _userController.authState;
        _loading.out();
      });
    } catch (e) {
      _loading.out();
      appWarningDialog(
        title: 'Erro!',
        middleText: 'Tente novamente',
      );
    } finally {
      _loading.out();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Center(
                      child: Text(
                        'ESTAGIÁRIO',
                        style: titleText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Escolha uma foto para o seu perfil',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        _photo == null
                            ? CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                backgroundImage: AssetImage(
                                  'assets/images/logo.png',
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                backgroundImage: FileImage(
                                  _photo!,
                                ),
                              ),
                        Positioned(
                          right: -16,
                          bottom: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.white),
                                ),
                                primary: Colors.white,
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {
                                imgFromGallery();
                              },
                              child: SvgPicture.asset(
                                "assets/icons/camera_icon.svg",
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: kDefaultPadding,
                    child: CSCPicker(
                      flagState: CountryFlag.DISABLE,
                      showStates: true,
                      showCities: true,
                      currentCountry: 'Brazil',
                      defaultCountry: DefaultCountry.Brasil,
                      dropdownDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      stateSearchPlaceholder: "Estado onde mora",
                      citySearchPlaceholder: "Cidade onde mora",
                      countryDropdownLabel: "País onde mora",
                      stateDropdownLabel: "Estado onde mora",
                      cityDropdownLabel: "Cidade onde mora",
                      layout: Layout.vertical,
                      disableCountry: true,
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      onCountryChanged: (value) {
                        setState(() {});
                      },
                      onStateChanged: (value) {
                        setState(() {
                          controller.internModel.state = value ?? '';
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          controller.internModel.city = value ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: kDefaultPadding,
                child: PrimaryButton(
                  buttonText: 'Finalizar cadastro',
                  onTap: () async {
                    if (_photo == null) {
                      appWarningDialog(
                        title: 'Erro!',
                        middleText: 'Você precisa selecionar uma foto',
                      );
                    } else {
                      if (controller.internModel.state!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar um estado',
                        );
                      } else if (controller.internModel.city!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar uma cidade',
                        );
                      } else {
                        try {
                          _loading.on();
                          await controller.signIntern().then((user) async {
                            await uploadFile(_photo, user);
                          });
                        } finally {
                          _loading.out();
                        }
                      }
                    }
                  },
                ),
              ),
            ],
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
