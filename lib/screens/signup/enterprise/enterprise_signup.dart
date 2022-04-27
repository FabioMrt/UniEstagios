import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/theme.dart';
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
                            hintText: 'Razão social',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.enterpriseModel.socialReason = value!;
                              print(
                                  'RAZAO ${controller.enterpriseModel.socialReason}');
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
                  Padding(
                    padding: kDefaultPadding,
                    child: CSCPicker(
                      flagState: CountryFlag.DISABLE,
                      showStates: true,
                      showCities: true,
                      currentCountry: 'Brazil',
                      defaultCountry: DefaultCountry.Brasil,
                      dropdownDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      stateSearchPlaceholder: "Estado onde mora",
                      citySearchPlaceholder: "Cidade onde mora",
                      countryDropdownLabel: "País onde mora",
                      stateDropdownLabel: "Estado onde mora",
                      cityDropdownLabel: "Cidade onde mora",
                      layout: Layout.vertical,
                      disableCountry: true,
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      dropdownHeadingStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      onCountryChanged: (value) {
                        setState(() {});
                      },
                      onStateChanged: (value) {
                        setState(() {
                          controller.enterpriseModel.state = value ?? '';
                          print('estado ${controller.enterpriseModel.state}');
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          controller.enterpriseModel.city = value ?? '';
                          print('cidade ${controller.enterpriseModel.city}');
                        });
                      },
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

                      if (controller.enterpriseModel.state!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar um estado',
                        );
                      } else if (controller.enterpriseModel.city!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar uma cidade',
                        );
                      }

                      try {
                        _loading.on();
                        await controller.signEnterprise();
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
