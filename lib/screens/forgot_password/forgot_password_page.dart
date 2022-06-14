import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/forgot_password/forgot_password_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/app_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String title;
  const ForgotPasswordPage({Key? key, this.title = 'ForgotPasswordPage'})
      : super(key: key);
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _loading = Get.find<LoadingController>();
  final _controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width,
                      height: height * 0.35,
                      child: Center(
                        child: Image.asset(
                          'assets/images/login_logo.png',
                        ),
                      ),
                    ),
                    Text(
                      'Esqueceu sua senha?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Não tem problema! Só precisamos do E-Mail que você usou ao criar seu cadastro em nosso aplicativo',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    AppInput(
                      hintText: 'Email',
                      suffix: Icon(
                        Icons.mail,
                        color: kPrimaryColor,
                      ),
                      onSaved: (value) {
                        _controller.email = value!;
                      },
                      validator: (value) => validateForm(
                        value,
                        ValidationMethod.EMAIL,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Obx(
                        () => AppButton(
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          title: 'Enviar',
                          busy: _loading.status.value,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();

                              try {
                                _loading.on();
                                await _controller.resetPassword();
                              } finally {
                                if (_controller.checked.value == true) {
                                  _showResetAlert();
                                  _loading.out();
                                }
                                _loading.out();
                              }
                            }
                          },
                        ),
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

  _showResetAlert() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "Verifique a sua caixa de E-Mail ou spam para modificar a sua senha",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              ),
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
