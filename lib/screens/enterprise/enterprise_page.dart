import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/controllers/user_controller.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => _EnterprisePageState();
}

class _EnterprisePageState extends State<EnterprisePage> {
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Empresa',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _userController.signOut();
              Get.toNamed('/login');
            },
            child: Text(
              'Sair',
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Empresa page',
        ),
      ),
    );
  }
}
