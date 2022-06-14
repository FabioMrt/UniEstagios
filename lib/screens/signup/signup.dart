import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/validate_form.dart';

import '../../utils/overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controller = Get.find<SignUpController>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final _loading = Get.find<LoadingController>();

  UserModel model = UserModel();

  bool responseValue = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  'CADASTRO',
                  style: titleText,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/register/intern');
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: width * 0.65,
                height: height * 0.30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/student.png',
                      width: 90,
                      height: 90,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sou um estudante',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Busco vagas de estágios',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xff6D6C6C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 64,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/register/enterprise');
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 4,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: width * 0.65,
                height: height * 0.30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/enterprise.png',
                      width: 90,
                      height: 90,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sou uma empresa',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Busco estagiários',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xff6D6C6C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
