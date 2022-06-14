import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:uniestagios/screens/login/login_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/app_button.dart';

import '../../domain/form_validation/input_validator.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final controller = Get.find<LoginController>();
  final formKey = GlobalKey<FormState>();
  final _loading = Get.find<LoadingController>();
  UserModel model = UserModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: kDefaultPadding,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    AppInput(
                      hintText: 'Email',
                      validator: (value) => validateForm(
                        value,
                        ValidationMethod.EMAIL,
                      ),
                      suffix: Icon(
                        Icons.mail,
                        color: kPrimaryColor,
                      ),
                      onSaved: (value) {
                        model.email = value ?? '';
                      },
                    ),
                    SizedBox(height: 20),
                    AppInput(
                      hintText: 'Senha',
                      isObscure: true,
                      validator: (value) => validateForm(
                        value,
                        ValidationMethod.PASSWORD,
                      ),
                      onSaved: (value) {
                        model.password = value ?? '';
                      },
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Obx(
                        () => AppButton(
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          title: 'Entrar',
                          busy: _loading.status.value,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();

                              try {
                                _loading.on();
                                await controller.signIn(
                                  model.email,
                                  model.password,
                                );
                              } finally {
                                _loading.out();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton.text(
                            title: 'Esqueci minha senha',
                            textColor: Colors.black,
                            onPressed: () {
                              Get.toNamed('/forgotPassword');
                            },
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Não possui uma conta? ',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Cadastre-se',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed('/register');
                              },
                          ),
                        ],
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/register');
                          },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
