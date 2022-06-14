import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/areas.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

import '../../../controllers/user_controller.dart';
import '../../../shared/csc_picker.dart';

class EnterpriseSecondSignUp extends StatefulWidget {
  const EnterpriseSecondSignUp({Key? key}) : super(key: key);

  @override
  State<EnterpriseSecondSignUp> createState() => _EnterpriseSecondSignUpState();
}

class _EnterpriseSecondSignUpState extends State<EnterpriseSecondSignUp> {
  final controller = Get.find<SignUpController>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final _loading = Get.find<LoadingController>();
  String _selectedItem = "";
  File? _photo;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _userController = Get.find<UserController>();

  bool responseValue = true;

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
            .collection('empresas')
            .doc(user.uid)
            .update({'foto': value});
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
                        'EMPRESA',
                        style: titleText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Escolha uma foto para a empresa',
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
                  // Padding(
                  //   padding: kDefaultPadding,
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: double.infinity,
                  //     child: InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Área de atuação',
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(5.0)),
                  //         contentPadding: EdgeInsets.only(
                  //           left: 10,
                  //           top: 10,
                  //         ),
                  //       ),
                  //       child: ButtonTheme(
                  //         materialTapTargetSize: MaterialTapTargetSize.padded,
                  //         child: DropdownButton<String>(
                  //           isExpanded: true,
                  //           underline: Container(color: Colors.transparent),
                  //           items: appAreas
                  //               .map(
                  //                 (e) => DropdownMenuItem<String>(
                  //                   child: Text(
                  //                     e,
                  //                     style: TextStyle(
                  //                       color: Colors.black,
                  //                     ),
                  //                   ),
                  //                   onTap: () {
                  //                     setState(() {
                  //                       controller.enterpriseModel.area = e;
                  //                     });
                  //                   },
                  //                   value: e,
                  //                 ),
                  //               )
                  //               .toList(),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               this._selectedItem = value ?? '';
                  //               controller.enterpriseModel.area = value;
                  //             });
                  //           },
                  //           value: this._selectedItem.isEmpty
                  //               ? appAreas.first
                  //               : this._selectedItem,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                          color: Colors.grey.shade500,
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
                      stateSearchPlaceholder: "Estado",
                      citySearchPlaceholder: "Cidade",
                      countryDropdownLabel: "País",
                      stateDropdownLabel: "Estado",
                      cityDropdownLabel: "Cidade",
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
                          controller.enterpriseModel.state = value ?? '';
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          controller.enterpriseModel.city = value ?? '';
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: kDefaultPadding,
                child: PrimaryButton(
                  buttonText: 'Inscrever-se',
                  onTap: () async {
                    controller.enterpriseModel.area ??= '';
                    if (_photo == null) {
                      appWarningDialog(
                        title: 'Erro!',
                        middleText: 'Você precisa selecionar uma foto',
                      );
                    } else {
                      try {
                        _loading.on();
                        await controller.signEnterprise().then((user) async {
                          await uploadFile(_photo, user);
                        });
                      } finally {
                        _loading.out();
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
