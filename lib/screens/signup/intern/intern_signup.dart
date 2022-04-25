import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/models/user_model.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';

class InternSignUp extends StatefulWidget {
  const InternSignUp({Key? key}) : super(key: key);

  @override
  State<InternSignUp> createState() => _InternSignUpState();
}

class _InternSignUpState extends State<InternSignUp> {
  final controller = Get.find<SignUpController>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final _loading = Get.find<LoadingController>();

  UserModel model = UserModel();

  bool responseValue = true;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Text(
                      'Criar Conta',
                      style: titleText,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Row(
                      children: [
                        Text(
                          'Já tem cadastro?',
                          style: subTitle,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            'Entre',
                            style: textButton.copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Form(
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
                              model.email = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'Telefone',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              model.phone = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            controller: _pass,
                            hintText: 'Senha',
                            isObscure: true,
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.PASSWORD,
                            ),
                            onSaved: (value) {
                              model.password = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            controller: _confirmPass,
                            hintText: 'Confirme a Senha',
                            isObscure: true,
                            validator: (value) {
                              if (value != _pass.text) {
                                return 'As senhas não conferem';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
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
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();

                      try {
                        _loading.on();
                        await controller.signUp(model);
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
