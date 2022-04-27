import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uniestagios/components/input/app_input.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/controllers/loading_controller.dart';
import 'package:uniestagios/domain/form_validation/input_validator.dart';
import 'package:uniestagios/screens/signup/signup_controller.dart';
import 'package:uniestagios/shared/csc_picker.dart';
import 'package:uniestagios/theme.dart';
import 'package:uniestagios/utils/overlay.dart';
import 'package:uniestagios/utils/validate_form.dart';
import 'package:uniestagios/widgets/warning_dialog.dart';

class InternSecondSignUp extends StatefulWidget {
  const InternSecondSignUp({Key? key}) : super(key: key);

  @override
  State<InternSecondSignUp> createState() => _InternSecondSignUpState();
}

class _InternSecondSignUpState extends State<InternSecondSignUp> {
  final controller = Get.find<SignUpController>();

  final formKey = GlobalKey<FormState>();
  final _loading = Get.find<LoadingController>();

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
                            hintText: 'Universidade',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.internModel.university = value!;
                            },
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          AppInput(
                            hintText: 'Idade',
                            validator: (value) => validateForm(
                              value,
                              ValidationMethod.SIMPLE_FIELD,
                            ),
                            onSaved: (value) {
                              controller.internModel.age = value!;
                            },
                          ),
                          SizedBox(height: 10),
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
                          controller.internModel.state = value ?? '';
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          controller.internModel.city = value ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: kDefaultPadding,
                child: PrimaryButton(
                  buttonText: 'Finalizar cadastro',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();

                      if (controller.internModel.state!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar um estado',
                        );
                      } else if (controller.internModel.city!.isEmpty) {
                        appWarningDialog(
                          title: 'Erro!',
                          middleText: 'Você precisa selecionar uma cidade',
                        );
                      }

                      try {
                        _loading.on();
                        await controller.signIntern();
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
