import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Center(
                      child: Text(
                        'ESTAGIÁRIO',
                        style: titleText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: kDefaultPadding,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          AppInput(
                            hintText: 'Nome completo',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.userInternModel.name = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'Universidade',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.internModel.university = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'Curso',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.internModel.course = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'Email',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.EMAIL,
                            ),
                            onSaved: (value) {
                              controller.userInternModel.email = value!;
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
                              controller.userInternModel.phone = value!;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter(),
                            ],
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
                              controller.userInternModel.password = value!;
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
                child: ElevatedButton(
                  child: SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  )),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();

                      Get.toNamed('/register/intern/second');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    minimumSize: Size(128, 56),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
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
