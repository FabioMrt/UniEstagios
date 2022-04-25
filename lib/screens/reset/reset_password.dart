import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/components/primary_button.dart';
import 'package:uniestagios/screens/reset/reset_form.dart';
import 'package:uniestagios/theme.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
            ),
            Text(
              'Alterar Senha',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Informe seu endereço de e-mail:',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            ResetForm(),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/login');
              },
              child: PrimaryButton(
                buttonText: 'Alterar Senha',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
