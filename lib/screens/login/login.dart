import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:uniestagios/screens/login/login_controller.dart';
import 'package:uniestagios/screens/reset/reset_password.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';

import '../../domain/form_validation/input_validator.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final controller = Get.find<LoginController>();
  final formKey = GlobalKey<FormState>();
  final _loading = Get.find<LoadingController>();
  UserModel model = UserModel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
          ),
          child: Scaffold(
            body: Padding(
              padding: kDefaultPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Text(
                      'Bem Vindo',
                      style: titleText,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Não tem cadastro?',
                          style: subTitle,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/register');
                          },
                          child: Text(
                            'Inscrever-se',
                            style: textButton.copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          AppInput(
                            hintText: 'Email',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.EMAIL,
                            ),
                            onSaved: (value) {
                              model.email = value ?? '';
                            },
                          ),
                          SizedBox(height: 10),
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()));
                      },
                      child: Text(
                        'Esqueceu a Senha?',
                        style: TextStyle(
                          color: kZambeziColor,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: kDefaultPadding,
                child: PrimaryButton(
                  buttonText: 'Entre',
                  onTap: () async {
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
