import 'package:flutter/material.dart';
import 'package:uniestagios/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final onTap;
  const PrimaryButton({
    required this.buttonText,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: kPrimaryColor),
        child: Text(
          buttonText,
          style: textButton.copyWith(color: kWhiteColor),
        ),
      ),
    );
  }
}
