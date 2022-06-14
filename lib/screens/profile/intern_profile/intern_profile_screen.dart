import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/controllers/user_controller.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/widgets/profile_menu.dart';
import 'package:path/path.dart';
import 'package:uniestagios/theme.dart';

class InternProfileScreen extends StatefulWidget {
  const InternProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InternProfileScreen> createState() => _InternProfileScreenState();
}

class _InternProfileScreenState extends State<InternProfileScreen> {
  final user = Get.find<UserController>();
  final _loading = Get.find<LoadingController>();

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? _photo;
  String profilePic = '';

  @override
  void initState() {
    super.initState();
    getProfilePic();
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
        uploadFile(_photo);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(File? _photo) async {
    if (_photo == null) return;
    final fileName = basename(_photo.path);
    final destination = 'uploads/${user.internModel.id}/$fileName';
    try {
      _loading.on();
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo);
      await ref.getDownloadURL().then((value) async {
        await firestore
            .collection('estagiarios')
            .doc(user.userId)
            .update({'fotoPerfil': value});
      }).then((value) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: kPrimaryColor,
          messageText: Text(
            'Foto atualizada com sucesso!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 4),
        ));
      });
    } catch (e) {
      _loading.out();
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.red,
        messageText: Text(
          'Ocorreu algum erro, tente novamente',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        getProfilePic();
      });
      _loading.out();
    }
  }

  Future<String> getProfilePic() async {
    var data = await firestore.collection('estagiarios').doc(user.userId).get();
    profilePic = data['fotoPerfil'];
    return profilePic;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Perfil"),
            backgroundColor: kPrimaryColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      FutureBuilder<String>(
                          future: getProfilePic(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                ),
                              );
                            }

                            String? picture = snapshot.data == ''
                                ? 'https://firebasestorage.googleapis.com/v0/b/uniestagios-e460b.appspot.com/o/uploads%2Fplaceholder.jpeg?alt=media&token=aa90dd7a-44ae-4a8e-97dd-3a3ebe83318a'
                                : snapshot.data;

                            return CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              backgroundImage: NetworkImage(
                                picture!,
                              ),
                            );
                          }),
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
                ProfileMenu(
                  text: "Minha Conta",
                  icon: "assets/icons/user_icon.svg",
                  press: () => {
                    Get.toNamed('/profile'),
                  },
                ),
                // ProfileMenu(
                //   text: "Notificações",
                //   icon: "assets/icons/bell.svg",
                //   press: () {},
                // ),
                ProfileMenu(
                  text: "Configurações",
                  icon: "assets/icons/settings.svg",
                  press: () {},
                ),
                // ProfileMenu(
                //   text: "Currículo",
                //   icon: "assets/icons/mail.svg",
                //   press: () {
                //     Get.toNamed('/candidateCv');
                //   },
                // ),
                ProfileMenu(
                  text: "Sair",
                  icon: "assets/icons/log_out.svg",
                  press: () {
                    user.signOut().then((value) => Get.offAllNamed('/login'));
                  },
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
