import 'package:flutter/material.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
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
            press: () {},
          ),
        ],
      ),
    );
  }
}
