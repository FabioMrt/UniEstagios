import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Minha Conta",
            icon: "icons/user_icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notificações",
            icon: "icons/bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Configurações",
            icon: "icons/settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Currículo",
            icon: "icons/Mail.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Sair",
            icon: "icons/log_out.svg",
            press: () {
              _userController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
