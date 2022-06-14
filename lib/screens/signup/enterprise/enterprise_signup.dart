import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/areas.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

import '../../../shared/csc_picker.dart';

class EnterpriseSignUp extends StatefulWidget {
  const EnterpriseSignUp({Key? key}) : super(key: key);

  @override
  State<EnterpriseSignUp> createState() => _EnterpriseSignUpState();
}

class _EnterpriseSignUpState extends State<EnterpriseSignUp> {
  final controller = Get.find<SignUpController>();
  final cnpjController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final _loading = Get.find<LoadingController>();
  String _selectedItem = "";

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
                        'EMPRESA',
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
                            hintText: 'Razão social (nome)',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.enterpriseModel.socialReason = value!;
                            },
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'CNPJ',
                            keyboardType: TextInputType.number,
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.CNPJ,
                            ),
                            onSaved: (value) {
                              controller.enterpriseModel.cnpj = value!;
                              print('CNPJ ${controller.enterpriseModel.cnpj}');
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CnpjInputFormatter(),
                            ],
                          ),
                          SizedBox(height: 10),
                          AppInput(
                            hintText: 'Email',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.EMAIL,
                            ),
                            onSaved: (value) {
                              controller.userEnterpriseModel.email = value!;
                              print(
                                  'EMAIL ${controller.userEnterpriseModel.email}');
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
                              controller.userEnterpriseModel.phone = value!;
                              print(
                                  'PHONE ${controller.userEnterpriseModel.phone}');
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
                              controller.userEnterpriseModel.password = value!;
                              print(
                                  'PASSWORD ${controller.userEnterpriseModel.password}');
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
                  SizedBox(height: 20),
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

                      Get.toNamed('/register/enterprise/second');
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
